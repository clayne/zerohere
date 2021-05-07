CC=gcc
CFLAGS=-O2 -pipe
#CFLAGS=-Og -g -pipe
BUILD_CFLAGS=-std=gnu99 -I. -D_FILE_OFFSET_BITS=64 -pipe -fstrict-aliasing
BUILD_CFLAGS += -Wall -Wextra -Wcast-align -Wstrict-aliasing -pedantic -Wstrict-overflow -Wno-unused-parameter
LDFLAGS=-lm

prefix=/usr
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
mandir=${prefix}/man
datarootdir=${prefix}/share
datadir=${datarootdir}
sysconfdir=${prefix}/etc

BUILD_CFLAGS += $(CFLAGS_EXTRA)
ifdef DEBUG
BUILD_CFLAGS += -DDEBUG
endif

all: zerohere manual

zerohere: zerohere.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(BUILD_CFLAGS) -o zerohere zerohere.o

manual:
#	gzip -9 < zerohere.1 > zerohere.1.gz

.c.o:
	$(CC) -c $(BUILD_CFLAGS) $(CFLAGS) $<

clean:
	rm -f *.o *~ zerohere debug.log *.?.gz

distclean:
	rm -f *.o *~ zerohere debug.log *.?.gz zerohere*.pkg.tar.*

install: all
#	install -D -o root -g root -m 0644 zerohere.1.gz $(DESTDIR)/$(mandir)/man1/zerohere.1.gz
	install -D -o root -g root -m 0755 -s zerohere $(DESTDIR)/$(bindir)/zerohere

