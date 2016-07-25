//Bilinear image interpolation using L1 cache optimization
//Here there is not much difference in code as compared to register memory optimization


#include<Windows.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>
#include <stdio.h>
#include<time.h>
#include <iostream>
#include<device_atomic_functions.h>
#include<device_functions.h>
#include<stdlib.h>
__global__ void bilinear1(unsigned char *new_image, const unsigned char *image, int rows, int cols)
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	int index = row*cols / 2 + col;

	row *= 2;
	col *= 2;
	new_image[row*cols + col] = image[index];
	__syncthreads();

}
__global__ void bilinear2(unsigned char *new_image, const unsigned char *image, int rows, int cols)
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
//	int index = row*cols / 2 + col;


	row *= 2;
	col *= 2;

	new_image[(row + 1)*cols + col + 1] = (new_image[(row + 2)*cols + col] + new_image[(row*cols + col + 2)] + new_image[(row + 2)*cols + col + 2] + new_image[(row*cols + col)]) / 4;

	__syncthreads();

}

__global__ void bilinear3(unsigned char *new_image, const unsigned char *image, int rows, int cols)
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
//	int index = row*cols / 2 + col;
	row *= 2;
	col *= 2;
	unsigned char a, b;
	a = new_image[row*cols + col];
	b = new_image[(row + 1)*cols + col + 1];
	new_image[row*cols + col + 1] = (a + new_image[(row - 1)*cols + col + 1] + new_image[row*cols + col + 2] + b) / 4;

	new_image[(row + 1)*cols + col] = (a + new_image[(row + 1)*cols + col - 1] + b + new_image[(row + 2)*cols + col]) / 4;
	__syncthreads();

}
