all: compile

compile:
	@rm -f httpfs
	@gcc -c -O2 -Wall -D_FILE_OFFSET_BITS=64 -D_REENTRANT -DFUSE_USE_VERSION=25 -D_POSIX_C_SOURCE=200112L -D_POSIX_SOURCE -D_SVID_SOURCE -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -DUSE_AUTH httpfs.c
	@gcc -s httpfs.o -o httpfs -lfuse
	@rm -f httpfs.o

debug:
	@rm -f httpfs
	@gcc -g -c -O2 -Wall -D_FILE_OFFSET_BITS=64 -D_REENTRANT -DFUSE_USE_VERSION=25 -D_POSIX_C_SOURCE=200112L -D_POSIX_SOURCE -D_SVID_SOURCE -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -DUSE_AUTH httpfs.c
	@gcc -g httpfs.o -o httpfs -lfuse
	@rm -f httpfs.o

distclean: clean
clean: clean-files
clean-files:
	@rm -f httpfs.o
	@rm -f httpfs
