// Linear image interpolation using L1 cache optimization



#include<Windows.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>
#include <stdio.h>
#include<time.h>
#include <iostream>
#include<device_atomic_functions.h>
#include<device_functions.h>

__global__ void lneigh(unsigned char *new_image, const unsigned char *image, int rows, int cols)
{
	unsigned char a;
	int	col = threadIdx.x + blockDim.x*blockIdx.x;
	int row = threadIdx.y + blockDim.y*blockIdx.y;


	int index = row*cols / 2 + col;

	row *= 2;
	col *= 2;

	a = image[index];
	new_image[(row)*cols + col] = a;
	new_image[(row)*cols + col + 1] = a;
	new_image[(row + 1)*cols + col] = a;
	new_image[(row + 1)*cols + col + 1] = a;
}
