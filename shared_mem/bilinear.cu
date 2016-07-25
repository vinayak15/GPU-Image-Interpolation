// Bi Linear image interpolation using shared memeory optimization technique
//In this method image is interpolated in 3 phase although shared memeory optimiztion did not gave much speed up in this case 


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
__global__ void bilinear1(unsigned char *new_image, const unsigned char *image, int rows, int cols)  //First phase of BI linear interpolation
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	int index = row*cols / 2 + col;

	row *= 2;
	col *= 2;
	new_image[row*cols + col] = image[index];
	__syncthreads();
}
__global__ void bilinear2(unsigned char *new_image, const unsigned char *image, int rows, int cols)	//Second phase of Image Interpolation
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	int index = row*cols / 2 + col;


	row *= 2;
	col *= 2;

	new_image[(row + 1)*cols + col + 1] = (new_image[(row + 2)*cols + col] + new_image[(row*cols + col + 2)] + new_image[(row + 2)*cols + col + 2] + new_image[(row*cols + col)]) / 4;

	__syncthreads();

}

__global__ void bilinear3(unsigned char *new_image, const unsigned char *image, int rows, int cols)  //Third phase of Image Interpolation
{
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;
	int index = row*cols / 2 + col;
	row *= 2;
	col *= 2;

	new_image[row*cols + col + 1] = (new_image[row*cols + col] + new_image[(row - 1)*cols + col + 1] + new_image[row*cols + col + 2] + new_image[(row + 1)*cols + col + 1]) / 4;

	new_image[(row + 1)*cols + col] = (new_image[row*cols + col] + new_image[(row + 1)*cols + col - 1] + new_image[(row + 1)*cols + col + 1] + new_image[(row + 2)*cols + col]) / 4;
	__syncthreads();

}
