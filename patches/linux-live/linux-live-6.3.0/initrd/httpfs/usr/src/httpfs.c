
/*
 * HTTPFS: http filesystem using FUSE
 * This program can be distributed under the terms of the GNU GPL.
 */

#include <fuse.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>

#define TIMEOUT 30
#define BUFSIZE 1024
#define BIGBUFSIZE 64*BUFSIZE
#define RESP_STATUS_LEN 12 // sizeof "HTTP/1.1 200"
#define VERSION "for-slax-6.0.7"

#define MIN(a,b) \
    ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
        _a < _b ? _a : _b; })

static char *myself;
static char *arg_url;
static char *arg_mnt;

static char http_auth[BUFSIZE];
static char http_host[BUFSIZE];
static char http_base[BUFSIZE];
static char http_path[BUFSIZE];
static char http_file[BUFSIZE];
static unsigned short int http_port;

//static char host[BUFSIZE];
//static unsigned short port;
//static char *file_name;
//static char httpfs_path[BUFSIZE];
//static char http_base[BUFSIZE];
static int sockfd;
static char *http = "http://";

#ifdef USE_AUTH
/*
static char b64_encode_table[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',  // 0-7
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',  // 8-15
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',  // 16-23
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',  // 24-31
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',  // 32-39
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',  // 40-47
    'w', 'x', 'y', 'z', '0', '1', '2', '3',  // 48-55
    '4', '5', '6', '7', '8', '9', '+', '/'   // 56-63
};

// Do base-64 encoding on a hunk of bytes.   Return the actual number of
// bytes generated.  Base-64 encoding takes up 4/3 the space of the original,
// plus a bit for end-padding.  3/2+5 gives a safe margin.
//

static int b64_encode(char* ptr, int len, char* space, int size) {
    int ptr_idx;
    unsigned char c = 0;
    unsigned char d = 0;
    int space_idx = 0;
    int phase = 0;

    if (size <= 0) return 0;

    for (ptr_idx = 0; ptr_idx < len; ++ptr_idx) {
	switch (phase++) {
	    case 0:
		c = ptr[ptr_idx] >> 2;
		d = (ptr[ptr_idx] & 0x3) << 4;
		break;
	    case 1:
		c = d | (ptr[ptr_idx] >> 4);
		d = (ptr[ptr_idx] & 0xf) << 2;
		break;
	    case 2:
		c = d | (ptr[ptr_idx] >> 6);
		if (space_idx < size) space[space_idx++] = b64_encode_table[c];
		c = ptr[ptr_idx] & 0x3f;
		break;
	}
	space[space_idx++] = b64_encode_table[c];
	if (space_idx == size) return space_idx;
	phase %= 3;
    }
    if (phase != 0) {
	space[space_idx++] = b64_encode_table[d];
	if (space_idx == size) return space_idx;
	// Pad with ='s.
	while (phase++ > 0) {
	    space[space_idx++] = '=';
	    if (space_idx == size) return space_idx;
	    phase %= 3;
	}
    }
    return space_idx;
}
*/
#endif /* USE_AUTH */

/*
 * Function sets global variables http_host, http_path, http_file, http_port, and http_auth
 * url = http://user:password@domain.com:80/path/file.dat
 * If parsing fails, returns -1
 */
static int parse_url(char *url) {
    char *pos, *auth, *port, *path, *file;

    memset(http_auth,0,BUFSIZE);
    memset(http_host,0,BUFSIZE);
    memset(http_base,0,BUFSIZE);
    memset(http_path,0,BUFSIZE);
    memset(http_file,0,BUFSIZE);

    // http part is optional
    pos = url + (strcasestr(url, http) ? strlen(http) : 0);

    auth = strchr(pos, '@');
    if (auth != NULL) {
	fprintf(stderr,"user auth not supported yet, ignored");
	// http_auth = "user:pass"; // fix this
	pos = auth + 1;
    }

    path = strchr(pos, '/');
    port = strchr(pos, ':');

    if (port < path && port != NULL) { // a semicolon is sooner than slash for path - that specifies port number
	http_port = (unsigned short) atoi(port + 1);
    } else {
	http_port = 80;
    }

    if (path != NULL) {
	strncpy(http_host, pos, path - pos);
	file = strrchr(path, '/');
	strncpy(http_path, path, file == path ? 1 : file - path);
	strncpy(http_file, file + 1, strlen(file) - 1);
    } else {
	strncpy(http_host, pos, strlen(pos));
	http_path[0]='/';
    }

    strncpy(http_base, http, strlen(http));
    strncpy(http_base + strlen(http), http_host, strlen(http_host));
    if (strcmp(http_path, "/") != 0) strncpy(http_base + strlen(http_base), http_path, strlen(http_path));

    return 1;
}

/* 
 * Function yields either a 'connected' socket for
 * host 'hostname' on port 'port'  or < 0 in case of error
 *
 * hostname is something like 'www.tmtd.de' or 192.168.0.86
 * port is expected in machine order (not net order)
 *
*/

static int open_client_socket() {
    int fd;
    struct hostent *he;
    struct sockaddr_in sa;
    struct timeval timeout;

    he = gethostbyname(http_host);
    if (he == NULL) {
	fprintf(stderr, "%s: unknown host - %s\n", myself, http_host);
	return -1;
    }

    memset((void*) &sa, 0, sizeof(sa));
    sa.sin_family = he->h_addrtype;
    memmove(&sa.sin_addr, he->h_addr, he->h_length);
    sa.sin_port = htons(http_port);

    fd = socket(sa.sin_family, SOCK_STREAM, 0);
    if (fd < 0) {
	fprintf(stderr, "%s: couldn't get socket\n", myself);
	return -1;
    }
    if (connect(fd, (struct sockaddr*) &sa, sizeof(sa)) < 0) {
	fprintf(stderr, "%s: couldn't connect socket\n", myself);
	return -1;
    }

    // set socket timeout
    timeout.tv_sec = TIMEOUT;
    timeout.tv_usec = 0;
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));

    return fd;
}

// return relative URL against the http_base
// compare case insensitive
char *relative_url(char *url) {
    if (strncasecmp(url, http_base, strlen(http_base)) == 0) url += strlen(http_base);
    if (strncasecmp(url, http, strlen(http)) == 0) url += strlen(url);
    return url;
}

/*
 * A generic sendRequest function
 * which handles all cases when connection no more exists
 */

static int sendRequest(const char *method, const char *path, off_t start, off_t end)
{
    char buf[BUFSIZE];
    char tmp[RESP_STATUS_LEN];
    char *pos;
    int bytes;
    int status;

    // build the request buffer
    memset(buf, 0, sizeof(buf));
    bytes = snprintf(buf, sizeof(buf), "%s %s%s HTTP/1.1\r\nHost: %s\r\n", method, strcmp(http_path,"/") == 0 ? "" : http_path, path, http_host);

    // keep the connection alive if requested
    bytes += snprintf(&buf[bytes], sizeof(buf) - bytes, "Connection: Keep-Alive\r\n");

    // handle HTTP_RANGE if needed
    if (start > 0 || end > 0) {
    	bytes += snprintf(&buf[bytes], sizeof(buf) - bytes, "Range: bytes=%llu-%llu\r\n", (unsigned long long) start, (unsigned long long) end);
    }

    // add authentication string if needed
    #ifdef USE_AUTH
    if ( *http_auth != '\0' )
        bytes += snprintf(&buf[bytes], sizeof(buf) - bytes, "Authorization: Basic %s\r\n", http_auth);
    #endif

    // finally send empty line so server can understnad it's all
    bytes += snprintf(&buf[bytes], sizeof(buf) - bytes, "\r\n");
fprintf(stderr,"------------- request -------------\n%s\n",buf);
    for (;;)
    {
        // write request to socket and read first 12 bytes of response
        write(sockfd, buf, bytes);
	memset(tmp, 0, sizeof(tmp));
        status = read(sockfd, tmp, sizeof(tmp));

	if (status > 0) {
	    // parse real status code
	    sscanf(tmp, "HTTP/1.1 %d", &status);

	    // handle HTTP redirect (status code 3xx with Location: header)
	    if (status > 300 && status < 400) {
    		read(sockfd, buf, sizeof(buf)); // hopefully we get enough data here
		pos = strstr(buf,"Location:");
		if (pos != NULL) {
		    pos[strcspn(pos, "\n\r")] = '\0';
		    pos = relative_url(pos+10); // 10 = strlen("Location: ")
		    if (strlen(pos) == 0) return 404;
		    close(sockfd);
		    return sendRequest(method, pos, start, end);
    		}
	    }

	    if (status >= 100 && status <= 999) {
        	return status;
    	    }
        }

        // if we got so far, we were unable to read from sockfd. Reconnect.
	close(sockfd);
        sockfd = open_client_socket();
    }
}

static off_t getSize(const char * path) {
    char buf[BUFSIZE];
    char* pos;
    int status;

    memset(buf, 0, sizeof(buf));
    status = sendRequest("HEAD",path,0,0);
    read(sockfd, buf, sizeof(buf));

    pos = strstr(buf,"Content-Length:");
    if (pos == NULL || status != 200) return -1;
    return atoll(pos+16);
}

static int httpGet(const char * path, off_t start, size_t size, char * destination, off_t maxRange) {
    char buf[BUFSIZE];
    char *pos;
    int b, bytes, status, c;
    off_t end;

    end = start + size - 1;
    if (end > maxRange) end = maxRange;
    if (start > end) start = end;

    memset(buf, 0, sizeof(buf));
    status = sendRequest("GET", path, start, end);
    if (status >= 300) return -1;
    bytes = read(sockfd, buf, sizeof(buf));

    // If the response doesn't contain all headers ended by \r\n\r\n,
    // read more data. This should be rather handled by select() syscall,
    // but I do not know how to use it yet.
    b = 1;
    while (strstr(buf,"\r\n\r\n") == NULL && b > 0) {
        b = read(sockfd, buf + bytes, sizeof(buf) - bytes);
        bytes += b;
    }

    pos = strstr(buf,"Content-Length:");
    if (pos == NULL) {
	/*
	 * HTTP 1.1 specification states that if the response doesn't 
	 * specify Content-Length, Transfer-Encoding is always Chunked.
	 * For that reason, we assume chunks here. We will read only
	 * ONE chunk of data here, it should be enough for us.
	 *
	 * This part of httpGet is called by httpfs_readdir(), it should
	 * never happen to jump here in httpfs_read()
	 */
    	    size_t chunksize = 0;
    	    pos = strstr(buf,"\r\n\r\n")+4;
	    b = 1; // make sure we have at least one line of data in buffer
	    while ( strstr(pos,"\r\n") == NULL && b > 0 ) {
	        b = read(sockfd, buf + bytes, sizeof(buf) - bytes);
	        bytes += b;
	    }
	    sscanf(pos, "%x", &chunksize);
	    if (size > chunksize) size = chunksize;
    	    pos = strstr(pos,"\r\n")+2;
	    c = 1; // close connection at the end - to drop other chunks
    }
    else {
	size = (size_t) atoll(pos+16);
        pos = strstr(buf,"\r\n\r\n")+4;
        c = 0; // keep connection alive
    }

    // copy bytes from the current response to destination
    bytes -= (pos - buf);
    if (bytes < 0) return 0;
    memcpy(destination, pos, bytes);
    size -= bytes;

    // read the rest of the response directly to address destination+bytes
    for (; size > 0; size -= bytes) {
	destination += bytes;
	bytes = read(sockfd, destination, size);
	if (bytes == 0) break;
    }

    if (c) close(sockfd);
    return end - start + 1 - size;
}


static int httpfs_getattr(const char *path, struct stat *stbuf) {
    off_t size;
    memset(stbuf, 0, sizeof(struct stat));
    if (strcmp(path, "/") == 0) {
        stbuf->st_mode = S_IFDIR | 0555;
        stbuf->st_nlink = 2;
    } else {
	size = getSize(path);
	if (size < 0) {
    	    stbuf->st_mode = S_IFDIR | 0555;
    	    stbuf->st_nlink = 2;
	}
	else {
    	    stbuf->st_mode = S_IFREG | 0444;
    	    stbuf->st_nlink = 1;
	    stbuf->st_size = size;
	}
    }
    return 0;
}

static int httpfs_access(const char *path, int mask) {
        return 0;
}

static int httpfs_readdir(const char *path, void *buffer, fuse_fill_dir_t filler,
                         off_t offset, struct fuse_file_info *fi) {

    char *w, *i;
    size_t len, bytes;
    char file[BUFSIZE];

    // download the given URL
    w = calloc(BIGBUFSIZE, 1);
    bytes = httpGet(path, 0, BIGBUFSIZE, w, 0);
    if (bytes < 0) goto end;

    // Now actually parse the files
    i = w;
    while ( (i = strcasestr(i, "href=")) != NULL ) {
	i += 5;
        i += strspn(i, "\t \n\r");

	if (*i == '"' || *i == '\'') i++;
	i = relative_url(i);

	len = strcspn(i, "?\"'\t \n\r>");
	while (*i == '/') {
	    i++;
	    len--;
	}
	len = MIN(len, strcspn(i, "/"));
	if (len > 0) {
    	    strncpy(file, i, len);
    	    file[len] = '\0';
fprintf(stderr,"file: %s\n", file);
fprintf(stderr,"http_file: %s\n", http_file);
fprintf(stderr,"path: %s\n", path);
fprintf(stderr,"http_path: %s\n", http_path);

    	    if (! (strncmp(file, http_file, strlen(http_file)) == 0
    	    && strlen(http_file)>0
            && strncmp(path, http_path, strlen(http_path)) == 0) ) {
	    	(*filler)(buffer, file, NULL, 0);
	    }
	}
    }

    if (strcmp(path, "/") == 0 && strlen(http_file) > 0)
	(*filler)(buffer, http_file, NULL, 0);

    i = w;
    end:
    free(w);
    return 0;
}

static int httpfs_open(const char *path, struct fuse_file_info *fi) {
    off_t size;
    size = getSize(path);
    if (size > 0) fi->fh = size-1;
    return 0;
}

static int httpfs_read(const char *path, char *buf, size_t size, off_t offset,
                      struct fuse_file_info *fi) {
    size_t got;

    got = httpGet(path, offset, size, buf, fi->fh);
    if (got < 0)
	return -1;

    return got;
}

static int httpfs_flush(const char *path, struct fuse_file_info *fi) {
    return 0;
}

static void *httpfs_init(void) {
    return NULL;
}

static void httpfs_destroy(void *arg) {
    return;
}

static struct fuse_operations httpfs_oper = {
    .flush	= httpfs_flush,
    .getattr	= httpfs_getattr,
    .access	= httpfs_access,
    .readdir	= httpfs_readdir,
    .open	= httpfs_open,
    .read	= httpfs_read,
    .init       = httpfs_init,
    .destroy    = httpfs_destroy,
};

int main(int argc, char *argv[]) {
    struct stat mpstat;
    int sr,ok;
    char* fusev[4];

    myself = argv[0];
    if (argc != 3) {
	fprintf(stderr, "HTTP Filesystem version %s\n", VERSION);
	fprintf(stderr, "usage: %s url mount-point\n", myself);
	return 1;
    }
    arg_url = argv[1];
    arg_mnt = argv[2];

    ok = parse_url(arg_url);
    if (ok == -1) 
	return 1;

    sockfd = open_client_socket();
    if (sockfd < 0)
	return 1;

    sr = stat(arg_mnt, &mpstat);
    if (sr < 0) {
	fprintf(stderr, "%s: bad mount-point %s\n", myself, arg_mnt);
	return 1;
    }

    if ((mpstat.st_mode & S_IFDIR) == 0) {
	fprintf(stderr, "%s: %s is not a directory\n", myself, arg_mnt);
	return 1;
    }

    fusev[0] = myself;
    fusev[1] = "-s"; // disable multi threaded support (to make HTTP work)
    fusev[2] = "-ononempty,attr_timeout=300,entry_timeout=300,negative_timeout=300,kernel_cache";
    fusev[3] = arg_mnt;
    return fuse_main(argc+1, fusev, &httpfs_oper);
    /*    close(sockfd);	*/
}

