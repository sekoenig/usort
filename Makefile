# Simple Makefile to build usort as a static library.

MPICXX ?= mpicxx
CFLAGS ?= -O3 -fopenmp -std=c++11
LFLAGS ?= -fopenmp

PREFIX ?= /usr/local

LIBNAME ?= libusort

SRC     = ./src
INCLUDE = ./include

INCS   = -I$(INCLUDE)
AR     = ar

USORT_SOURCES = binUtils.cpp parUtils.cpp

USORT_HEADERS = binUtils.h \
                parUtils.h parUtils.hpp \
                seqUtils.h seqUtils.hpp \
                ompUtils.h ompUtils.hpp \
                indexHolder.h \
                dtypes.h \
                sort_profiler.h \
                usort.h

SOURCES = $(addprefix $(SRC)/, $(USORT_SOURCES))
HEADERS = $(addprefix $(INCLUDE)/, $(USORT_HEADERS))

OBJECTS = $(SOURCES:.cpp=.o)

.PHONY: all lib test main clean install

all: lib test

clean:
	rm -f $(OBJECTS)
	rm -f *.a

lib: $(LIBNAME).a

test: main

main: $(LIBNAME).a $(SRC)/main.o
	$(MPICXX) $ $(LFLAGS) $(SRC)/main.o ./$(LIBNAME).a -o $@

libusort.a: $(OBJECTS)
	$(AR) -rcs $@ $(OBJECTS)

%.o : %.cpp
	$(MPICXX) $(INCS) -c $(CFLAGS) -o $@ $<

install: $(LIBNAME).a $(HEADERS)
	install -d $(PREFIX)/include/usort
	install -d $(PREFIX)/lib
	install ./$(LIBNAME).a $(PREFIX)/lib/$(LIBNAME).a
	install -t $(PREFIX)/include/usort $(HEADERS)
