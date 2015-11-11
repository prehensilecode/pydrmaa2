PYTHONVERSION=3.5m

CC=gcc
CFLAGS=-fpic -O2 -march=corei7-avx -mfpmath=sse
CPPFLAGS=-I. -I$(PYTHONDIR)/include/python$(PYTHONVERSION)
LD=ld
LDFLAGS=-shared
LIBS=-L$(PYTHONDIR)/lib -lpython$(PYTHONVERSION) -L$(SGE_ROOT)/lib/$(SGE_ARCH) -ldrmaa2 -lrt -lpthread -lm -ldl

SWIG=swig
SWIGINCLUDES=-I$(SGE_ROOT)/include

%.o : %.c drmaa2.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

%.py %_wrap.c : %.i
	$(SWIG) -python $(SWIGINCLUDES) $<

all: _drmaa2.so

clean: 
	-/bin/rm -rf _drmaa2.so drmaa2.py* drmaa2_wrap.c drmaa2_wrap.o drmaa2.h __pycache__/

### Munge the system drmaa.h
drmaa2.h: $(SGE_ROOT)/include/drmaa2.h
	-/bin/grep -v drmaa2_r_free $(SGE_ROOT)/include/drmaa2.h > $@

_drmaa2.so: drmaa2_wrap.o
	$(LD) $(LDFLAGS) $< -o $@ $(LIBS)

