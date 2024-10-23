#include "apue.h"
#include <dirent.h>
#include <limits.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <libgen.h>

#define BUFSIZE 4096

/* function type that is called for each filename */
typedef	int	Myfunc(const char*, const struct stat*, int);

static Myfunc	myfunc;
static int		myftw(char*, Myfunc*);
static int		dopath(Myfunc*);

static long	nreg, ndir, nblk, nchr, nfifo, nslink, nsock, ntot;
static long	nsmall_reg; // 新增：用于统计小于等于4096字节的常规文件数量

static void
handle_default_case(char* pathname);

static void
handle_comp_case(char* pathname, char* comp_filename);

static int
compare_files(const char* file1, const char* file2_content);

static char** name_list = NULL;
static int name_count = 0;

static void
handle_name_case(char* pathname, int argc, char* argv[]);

int
main(int argc, char* argv[]) {
    if (argc == 2) {
        handle_default_case(argv[1]);
    } else if (argc == 4 && strcmp(argv[2], "-comp") == 0) {
        handle_comp_case(argv[1], argv[3]);
    } else if (argc >= 4 && strcmp(argv[2], "-name") == 0) {
        handle_name_case(argv[1], argc, argv);
    } else {
        err_quit("usage: ftw <starting-pathname> [-comp <filename> | -name <str>...]");
    }

    return 0;
}

static void
handle_default_case(char* pathname) {
    int ret;
    ret = myftw(pathname, myfunc);

    ntot = nreg + ndir + nblk + nchr + nfifo + nslink + nsock;
    if (ntot == 0)
        ntot = 1;		/* avoid divide by 0; print 0 for all counts */
    printf("regular files  = %7ld, %5.2f %%\n", nreg,
        nreg * 100.0 / ntot);
    printf("directories    = %7ld, %5.2f %%\n", ndir,
        ndir * 100.0 / ntot);
    printf("block special  = %7ld, %5.2f %%\n", nblk,
        nblk * 100.0 / ntot);
    printf("char special   = %7ld, %5.2f %%\n", nchr,
        nchr * 100.0 / ntot);
    printf("FIFOs          = %7ld, %5.2f %%\n", nfifo,
        nfifo * 100.0 / ntot);
    printf("symbolic links = %7ld, %5.2f %%\n", nslink,
        nslink * 100.0 / ntot);
    printf("sockets        = %7ld, %5.2f %%\n", nsock,
        nsock * 100.0 / ntot);
    printf("small regular files = %7ld, %5.2f %%\n", nsmall_reg,
        nsmall_reg * 100.0 / nreg);
}


static char* comp_file_content;
static off_t comp_file_size;

static void
handle_comp_case(char* pathname, char* comp_filename) {
    int ret;
    struct stat comp_stat;
    int comp_fd;
    char cwd[PATH_MAX];
    char abs_path[PATH_MAX * 2];  // 增加缓冲区大小

    if (stat(comp_filename, &comp_stat) < 0) {
        err_ret("error: cannot stat %s ", comp_filename);
        return;
    }
    comp_file_size = comp_stat.st_size;

    comp_fd = open(comp_filename, O_RDONLY);
    if (comp_fd < 0) {
        err_ret("error: cannot open %s ", comp_filename);
        return;
    }
    comp_file_content = malloc(comp_file_size);
    if (comp_file_content == NULL) {
        err_sys("error: malloc failed");
    }
    if (read(comp_fd, comp_file_content, comp_file_size) != comp_file_size) {
        err_ret("error: cannot read %s ", comp_filename);
        free(comp_file_content);
        close(comp_fd);
        return;
    }
    close(comp_fd);

    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        err_sys("error: getcwd failed");
    }

    if (pathname[0] != '/') {
        char* dir = cwd;
        char* base = basename(pathname);
        if (snprintf(abs_path, sizeof(abs_path), "%s/%s", dir, base) >= sizeof(abs_path)) {
            err_sys("error: pathname too long");
        }
        ret = myftw(abs_path, myfunc);
    } else {
        ret = myftw(pathname, myfunc);
    }

    free(comp_file_content);
}

static void
handle_name_case(char* pathname, int argc, char* argv[]) {
    int i;
    name_count = argc - 3;
    name_list = malloc(name_count * sizeof(char*));
    if (name_list == NULL) {
        err_sys("error: malloc failed");
    }
    for (i = 0; i < name_count; i++) {
        name_list[i] = argv[i + 3];
    }

    int ret = myftw(pathname, myfunc);

    free(name_list);
}

/*
 * Descend through the hierarchy, starting at "pathname".
 * The caller's func() is called for every file.
 */
#define	FTW_F	1		/* file other than directory */
#define	FTW_D	2		/* directory */
#define	FTW_DNR	3		/* directory that can't be read */
#define	FTW_NS	4		/* file that we can't stat */

static char* fullpath;		/* contains full pathname for every file */
static size_t pathlen;

static int					/* we return whatever func() returns */
myftw(char* pathname, Myfunc* func) {
    fullpath = path_alloc(&pathlen);	/* malloc PATH_MAX+1 bytes */
    /* ({Prog pathalloc}) */
    if (pathlen <= strlen(pathname)) {
        pathlen = strlen(pathname) * 2;
        if ((fullpath = realloc(fullpath, pathlen)) == NULL)
            err_sys("realloc failed");
    }
    strcpy(fullpath, pathname);
    return(dopath(func));
}

/*
 * Descend through the hierarchy, starting at "fullpath".
 * If "fullpath" is anything other than a directory, we lstat() it,
 * call func(), and return.  For a directory, we call ourself
 * recursively for each name in the directory.
 */
static int					/* we return whatever func() returns */
dopath(Myfunc* func) {
    struct stat		statbuf;
    struct dirent* dirp;
    DIR* dp;
    int				ret, n;

    if (lstat(fullpath, &statbuf) < 0)	/* stat error */
        return(func(fullpath, &statbuf, FTW_NS));
    if (S_ISDIR(statbuf.st_mode) == 0)	/* not a directory */
        return(func(fullpath, &statbuf, FTW_F));

    /*
     * It's a directory.  First call func() for the directory,
     * then process each filename in the directory.
     */
    if ((ret = func(fullpath, &statbuf, FTW_D)) != 0)
        return(ret);

    n = strlen(fullpath);
    if (n + NAME_MAX + 2 > pathlen) {	/* expand path buffer */
        pathlen *= 2;
        if ((fullpath = realloc(fullpath, pathlen)) == NULL)
            err_sys("realloc failed");
    }
    fullpath[n++] = '/';
    fullpath[n] = 0;

    if ((dp = opendir(fullpath)) == NULL)	/* can't read directory */
        return(func(fullpath, &statbuf, FTW_DNR));

    while ((dirp = readdir(dp)) != NULL) {
        if (strcmp(dirp->d_name, ".") == 0 ||
            strcmp(dirp->d_name, "..") == 0)
            continue;		/* ignore dot and dot-dot */
        strcpy(&fullpath[n], dirp->d_name);	/* append name after "/" */
        if ((ret = dopath(func)) != 0)		/* recursive */
            break;	/* time to leave */
    }
    fullpath[n - 1] = 0;	/* erase everything from slash onward */

    if (closedir(dp) < 0)
        err_ret("can't close directory %s", fullpath);
    return(ret);
}

static int
myfunc(const char* pathname, const struct stat* statptr, int type) {
    if (comp_file_content != NULL) {
        if (type == FTW_F && S_ISREG(statptr->st_mode)) {
            if (statptr->st_size == comp_file_size) {
                if (compare_files(pathname, comp_file_content) == 0) {
                    printf("%s\n", pathname);
                }
            }
        }
    } else if (name_list != NULL) {
        if (type == FTW_F) {
            char* filename = basename((char*)pathname);
            for (int i = 0; i < name_count; i++) {
                if (strcmp(filename, name_list[i]) == 0) {
                    printf("%s\n", pathname);
                    break;
                }
            }
        }
    } else {
        switch (type) {
        case FTW_F:
            switch (statptr->st_mode & S_IFMT) {
            case S_IFREG:	
                nreg++;		
                if (statptr->st_size <= 4096) {
                    nsmall_reg++;
                }
                break;
            case S_IFBLK:	nblk++;		break;
            case S_IFCHR:	nchr++;		break;
            case S_IFIFO:	nfifo++;	break;
            case S_IFLNK:	nslink++;	break;
            case S_IFSOCK:	nsock++;	break;
            case S_IFDIR:
                err_dump("error: S_IFDIR for %s", pathname);
            }
            break;
        case FTW_D:
            ndir++;
            break;
        case FTW_DNR:
            err_ret("error: cannot read directory %s", pathname);
            break;
        case FTW_NS:
            err_ret("error: cannot stat %s", pathname);
            break;
        default:
            err_dump("error: unknown type %d, pathname %s", type, pathname);
        }
    }
    return 0;
}

static int
compare_files(const char* file1, const char* file2_content) {
    int fd;
    char buf[BUFSIZE];
    ssize_t n;
    off_t offset = 0;

    fd = open(file1, O_RDONLY);
    if (fd < 0) {
        return -1;
    }

    while ((n = read(fd, buf, BUFSIZE)) > 0) {
        if (memcmp(buf, file2_content + offset, n) != 0) {
            close(fd);
            return 1;
        }
        offset += n;
    }

    close(fd);
    return (n < 0) ? -1 : 0;
}