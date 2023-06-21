
CUDA_LD_LIBRARY=/usr/local/cuda-11.8/targets/x86_64-linux/lib
MAX_SEQ_LEN=300

.cpp.o:
	g++ -g -c -O3 -Wall -DMAX_SEQ_LEN=300

all: test_prog.out

test_prog.out: test_prog.o
	g++ -O3 -o test_prog.out -L$(CUDA_LD_LIBRARY) -L../lib test_prog.o -fopenmp -lcudart -lmapper

clean:
	rm -f -r *~ *.exe *.o *.out *.txt *~ *.tsv
	
test_prog.o: Timer.h
