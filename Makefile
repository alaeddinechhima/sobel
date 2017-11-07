SRC_DIR=src
HEADER_DIR=include

OBJ_DIR=obj
CUDA_HOME=/usr/local/cuda
CUDASDK=/usr/local/cuda/samples
CUDANVIDIA=/usr/lib64/nvidia
NVCC=$(CUDA_HOME)/bin/nvcc

CC=gcc
#CFLAGS=-O3 -I$(HEADER_DIR)
LDFLAGS=-lm

SRC= dgif_lib.c \
	egif_lib.c \
	gif_err.c \
	gif_font.c \
	gif_hash.c \
	gifalloc.c \
	main.c \
	openbsd-reallocarray.c \
	quantize.c

OBJ= $(OBJ_DIR)/dgif_lib.o \
	$(OBJ_DIR)/egif_lib.o \
	$(OBJ_DIR)/gif_err.o \
	$(OBJ_DIR)/gif_font.o \
	$(OBJ_DIR)/gif_hash.o \
	$(OBJ_DIR)/gifalloc.o \
	$(OBJ_DIR)/main.o \
	$(OBJ_DIR)/openbsd-reallocarray.o \
	$(OBJ_DIR)/quantize.o

NVCFLAGS=-arch=sm_30 -ccbin /opt/gcc-5.4.0/bin -I $(CUDA_HOME)/include -I$(CUDASDK)/common/inc

CFLAGS= -arch=sm_21 -L $(CUDA_HOME)/lib64 -L $(CUDANVIDIA) -lglut -lGLU -lGL

all: $(OBJ_DIR) sobelf

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

$(OBJ_DIR)/dgif_lib.o : $(SRC_DIR)/dgif_lib.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^
$(OBJ_DIR)/egif_lib.o : $(SRC_DIR)/egif_lib.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^
$(OBJ_DIR)/gif_err.o : $(SRC_DIR)/gif_err.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^
$(OBJ_DIR)/gif_font.o : $(SRC_DIR)/gif_font.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^
$(OBJ_DIR)/gif_hash.o : $(SRC_DIR)/gif_hash.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^
$(OBJ_DIR)/gifalloc.o : $(SRC_DIR)/gifalloc.c
	$(CC) -O3 -I$(HEADER_DIR) -c -o $@ $^

$(OBJ_DIR)/main.o : $(SRC_DIR)/main.cu
	$(NVCC) $(NVCFLAGS) -c -o $@ $<


sobelf:$(OBJ)
	$(CC) -O3 -I$(HEADER_DIR)  $(LDFLAGS) -fopenmp -pg  -c -o $@ $^ -L/usr/local/cuda/lib64 -lcudart -lstdc++ 


clean:
	rm -f sobelf $(OBJ)
