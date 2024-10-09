#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/times.h>
#include <time.h>

#define MIN_BUFFER_SIZE 256
#define MAX_BUFFER_SIZE (128 * 1024)

void print_time(clock_t start, clock_t end, struct tms *start_tms, struct tms *end_tms, long clk_tck, int buffer_size, long long loop_count) {
    double user_time = (end_tms->tms_utime - start_tms->tms_utime) / (double)clk_tck;
    double system_time = (end_tms->tms_stime - start_tms->tms_stime) / (double)clk_tck;
    double real_time = (end - start) / (double)clk_tck;

    printf("%7d %12.3f %14.3f %11.3f %10lld\n", 
           buffer_size, user_time, system_time, real_time, loop_count);
}

int main(int argc, char *argv[]) {
    // Check paremeters
    if (argc < 2 || argc > 3) {
        fprintf(stderr, "Usage: %s <outfile> [sync]\n", argv[0]);
        exit(1);
    }

    char *outfile = argv[1];
    int sync_flag = (argc == 3 && strcmp(argv[2], "sync") == 0) ? O_SYNC : 0;

    // Open output file
    int out_fd = open(outfile, O_WRONLY | O_CREAT | O_TRUNC | sync_flag, 0644);
    if (out_fd == -1) {
        perror("Error opening output file");
        exit(1);
    }

    // Get input file size
    off_t input_size = lseek(STDIN_FILENO, 0, SEEK_END);
    lseek(STDIN_FILENO, 0, SEEK_SET);

    // Allocate input buffer
    char *input_buffer = malloc(input_size);
    if (input_buffer == NULL) {
        perror("Error allocating input buffer");
        exit(1);
    }

    // Read entire input file
    if (read(STDIN_FILENO, input_buffer, input_size) != input_size) {
        perror("Error reading input file");
        exit(1);
    }

    long clk_tck = sysconf(_SC_CLK_TCK);

    printf("BUFFSIZE User CPU (s) System CPU (s) Clock time (s) Loop count\n");

    int buffer_size;

    for (buffer_size = MIN_BUFFER_SIZE; buffer_size <= MAX_BUFFER_SIZE; buffer_size *= 2) {
        char *write_buffer = malloc(buffer_size);
        if (write_buffer == NULL) {
            perror("Error allocating write buffer");
            exit(1);
        }

        lseek(out_fd, 0, SEEK_SET);

        struct tms start_tms, end_tms;
        clock_t start = times(&start_tms);
        long long bytes_written = 0;
        long long loop_count = 0;

        while (bytes_written < input_size) {
            int chunk_size = (input_size - bytes_written < buffer_size) ? 
                             (input_size - bytes_written) : buffer_size;
            memcpy(write_buffer, input_buffer + bytes_written, chunk_size);
            
            if (write(out_fd, write_buffer, chunk_size) != chunk_size) {
                perror("Error writing to output file");
                exit(1);
            }
            
            bytes_written += chunk_size;
            loop_count++;
        }

        clock_t end = times(&end_tms);

        print_time(start, end, &start_tms, &end_tms, clk_tck, buffer_size, loop_count);

        free(write_buffer);
    }

    free(input_buffer);
    close(out_fd);

    return 0;
}