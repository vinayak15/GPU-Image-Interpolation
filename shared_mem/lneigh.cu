//Nearest Neighbour interpolation technique implemented on an image with shared memory 
//In this interpolation we are taking the image and dividing it in two parts upper half and lower half  
//Main reason for dividing is we cant have full image in our shared memeory array of pixels.
#include<Windows.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>
#include <stdio.h>
#include<time.h>
#include <iostream>
#include<device_atomic_functions.h>
#include<device_functions.h>

__global__ void lneigh(unsigned char *new_image, const unsigned char *image, int rows, int cols,int flag)
{
	__shared__ unsigned char a[256 * 128];								//here half part of image is taken and interpolated because of memeory concerns of our GPU Hardware
	int index;
	int	col = threadIdx.x + blockDim.x*blockIdx.x; 				
	int row=threadIdx.y + blockDim.y*blockIdx.y;

	index = (row + rows*flag / 4)*cols/2 + col;						//index of image is decided to be intrpolated
	int index1 = row*cols/2 + col;
	row += flag*rows / 4;
	row *= 2;
	col *= 2;

	a[index1] = image[index];
	new_image[(row)*cols + col] = a[index1];						//interpolation happens
	new_image[(row)*cols + col + 1] = a[index1];
	new_image[(row + 1 )*cols + col] = a[index1];
	new_image[(row + 1)*cols + col + 1] = a[index1];
}
