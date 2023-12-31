GPU_SM_ARCH=
MAX_SEQ_LEN=
N_CODE=
N_PENALTY=
GPU_COMPUTE_ARCH=$(subst sm,compute,$(GPU_SM_ARCH))
NVCC=/usr/local/cuda-11.8/bin/nvcc
SRC_DIR=./src/
OBJ_DIR=./obj/
LIB_DIR=./lib/
INCLUDE_DIR=./include/
LOBJS=  mapper.o
LOBJS_PATH=$(addprefix $(OBJ_DIR),$(LOBJS))
VPATH=src:obj:lib
YELLOW=\033[1;33m
NC=\033[0m # No Color

ifeq ($(GPU_SM_ARCH),)
error1:
	@echo "Must specify GPU architecture as sm_xx"
endif
ifeq ($(MAX_SEQ_LEN),)
error2:
	@echo "Must specify maximum sequence length"
endif

ifeq ($(N_CODE),)
error3:
	@echo "Must specify the code for 'N'"
endif
#ifneq ($(GPU_SM_ARCH),clean)

.SUFFIXES: .cu .c .o .cc .cpp
ifeq ($(N_PENALTY),)
.cu.o:
	$(NVCC) -c -g -O3 -Xcompiler -Wall,-DMAX_SEQ_LEN=$(MAX_SEQ_LEN),-DN_CODE=$(N_CODE) -Xptxas -Werror  --gpu-architecture=$(GPU_COMPUTE_ARCH) --gpu-code=$(GPU_SM_ARCH) -lineinfo --ptxas-options=-v --default-stream per-thread $< -o $(OBJ_DIR)$@
else
.cu.o:
	$(NVCC) -c -g -O3 -Xcompiler -Wall,-DMAX_SEQ_LEN=$(MAX_SEQ_LEN),-DN_CODE=$(N_CODE),-DN_PENALTY=$(N_PENALTY) -Xptxas -Werror  --gpu-architecture=$(GPU_COMPUTE_ARCH) --gpu-code=$(GPU_SM_ARCH) -lineinfo --ptxas-options=-v --default-stream per-thread $< -o $(OBJ_DIR)$@
endif
all: makedir libmapper.a

makedir:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(LIB_DIR)
	@mkdir -p $(INCLUDE_DIR)
	@cp $(SRC_DIR)/mapper.h $(INCLUDE_DIR)
	@sed  -i "s,MAX_SEQ_LEN=.*,MAX_SEQ_LEN=$(MAX_SEQ_LEN),g" ./test_prog/Makefile
	 
ifeq ($(N_PENALTY),)
libmapper.a: $(LOBJS)
	ar -csru $(LIB_DIR)$@ $(LOBJS_PATH)
	@echo ""
	@echo -e "${YELLOW}WARNING:${NC}\"N\" is not defined"
else
libmapper.a: $(LOBJS)
	ar -csru $(LIB_DIR)$@ $(LOBJS_PATH)
endif
	
clean:
	rm -f -r $(OBJ_DIR) $(LIB_DIR) $(INCLUDE_DIR)  *~ *.exe *.o *.txt *~

mapper.o: mapper.h mapper_kernels_inl.h


