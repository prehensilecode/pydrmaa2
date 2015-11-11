PYTHONVERSION=3.5m

CC=gcc
CFLAGS=-fpic -O2 -march=corei7-avx -mfpmath=sse
CPPFLAGS=-I$(SGE_ROOT)/include -I$(PYTHONDIR)/include/python$(PYTHONVERSION)
LD=ld
LDFLAGS=-shared
LIBS=-L$(PYTHONDIR)/lib -lpython$(PYTHONVERSION) -L$(SGE_ROOT)/lib/$(SGE_ARCH) -ldrmaa2

SWIG=swig
SWIGINCLUDES=-I$(SGE_ROOT)/include

%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

%.py %_wrap.c : %.i
	$(SWIG) -python $(SWIGINCLUDES) $<

all: _drmaa2.so

clean: 
	-/bin/rm -f _drmaa2.so drmaa2.py drmaa2_wrap.c drmaa2_wrap.o

_drmaa2.so: drmaa2_wrap.o
	$(LD) $(LDFLAGS) $< -o $@ $(LIBS)

