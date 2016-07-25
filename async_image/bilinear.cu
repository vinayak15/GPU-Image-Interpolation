//Asynchronous data transfer for further optimization in bilinear interpolation  
//here code is same as compared to shared memory optimization except for few changes

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


//here we are using flag to determine which part of image is to be interpolated

__global__ void bilinear1(unsigned char *new_image, const unsigned char *image, int rows, int cols,int flag)  
{
	int index;
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	 
	index = (row + rows*flag / 4)*cols / 2 + col;
	row += flag*rows / 4;
	row *= 2;
	col *= 2;

	unsigned char a = image[index];
	new_image[(row)*cols + col] = a;
	__syncthreads();

}
__global__ void bilinear2(unsigned char *new_image, const unsigned char *image, int rows, int cols,int flag)
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;


	row += flag*rows / 4;
	row *= 2;
	col *= 2;

	new_image[(row + 1)*cols + col + 1] = (new_image[(row + 2)*cols + col] + new_image[(row*cols + col + 2)] + new_image[(row + 2)*cols + col + 2] + new_image[(row*cols + col)]) / 4;

	__syncthreads();

}

__global__ void bilinear3(unsigned char *new_image, const unsigned char *image, int rows, int cols,int flag)
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	row += flag*rows / 4;
	row *= 2;
	col *= 2;

	new_image[row*cols + col + 1] = (new_image[row*cols + col] + new_image[(row - 1)*cols + col + 1] + new_image[row*cols + col + 2] + new_image[(row + 1)*cols + col + 1]) / 4;

	new_image[(row + 1)*cols + col] = (new_image[row*cols + col] + new_image[(row + 1)*cols + col - 1] + new_image[(row + 1)*cols + col + 1] + new_image[(row + 2)*cols + col]) / 4;
	__syncthreads();

}
