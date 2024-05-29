#include <stdio.h>
#include <time.h>
#include "datetime.h"

void print_current_datetime() {
    time_t rawtime;
    struct tm *timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    printf("Current date and time: %s", asctime(timeinfo));
}
