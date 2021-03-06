//Shared Image interpolatin technique Implemented using CUDA and OpenCV





#include<Windows.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>
#include <stdio.h>
#include<time.h>
#include <iostream>
#include<device_atomic_functions.h>
#include "opencv2/opencv.hpp"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <cuda_runtime_api.h>
#include<stdlib.h>
#include<device_functions.h>
#include "opencv2\core\core.hpp"
#include "opencv2\core\cuda.hpp"
using namespace cv;
using namespace std;
#define BLOCK 32
#include<vector>
void psnr(Mat, Mat );
__global__ void lneigh(unsigned char *, const unsigned char *, int, int,int);
__global__ void bilinear1(unsigned char *, const unsigned char *, int, int);
//void psnr(Mat, Mat);
__global__ void bilinear2(unsigned char *, const unsigned char *, int, int);
__global__ void bilinear3(unsigned char *, const unsigned char *, int, int);
int main()
{

	LARGE_INTEGER frequency; // ticks per second
	LARGE_INTEGER t1, t2; // ticks
	double elapsedTime;

	
	Mat img1 = imread("C:\\Users\\User\\Downloads\\baboon.pgm", CV_LOAD_IMAGE_GRAYSCALE);//read the image data in the file "MyPic.JPG" and store it in 'img'
	if (!img1.data)
	{
		cout << "Image not Found\nTerminating Process\n";
		return 0;
	}
	namedWindow("original_picture", CV_WINDOW_AUTOSIZE);
	imwrite("C:\\Users\\User\\Downloads\\baboon(n3).bmp", img1);

	imshow("original_picture", img1);
	waitKey(0);
	cout << "1)Zoom in \n2)Zoom out image\n";

	unsigned char *img;
	QueryPerformanceFrequency(&frequency);
	QueryPerformanceCounter(&t1);
	img = ( unsigned char * )malloc( sizeof(unsigned char) * img1.rows*img1.cols / 4);
	for (int i = 0, a = 0; i < img1.rows && a < img1.rows/2; i += 2, a++)	//Compress the image to half of its size 
	{
		for (int j = 0, b = 0; j < img1.cols && b < img1.cols/2; j += 2, b++)
		{
			img[a*img1.cols/2 + b] = img1.at<uchar>(i, j);
		}
	}

	unsigned char *cuda_img,*cuda_new_img,*new_img;
	new_img = (unsigned char*)malloc(sizeof(char)*img1.rows*img1.cols);
	cudaMalloc((void **)&cuda_img, sizeof(char)*img1.rows * img1.cols / 4);
	cudaMalloc((void **)&cuda_new_img, sizeof(char)*img1.rows*img1.cols);
	cudaMemcpy(cuda_img, img, sizeof( char)*img1.rows *img1.cols/ 4, cudaMemcpyHostToDevice);

	//function to zoom image 2x times in cpu using open cv library

				 //Zooming with help nearest neighbour interpolation
	
	dim3 blockDim(BLOCK, BLOCK);
	dim3 gridDim(img1.cols / (2 * blockDim.x), img1.rows / (2 * blockDim.y));

//	lneigh << < gridDim,blockDim>> >( cuda_new_img, cuda_img , img1.rows , img1.cols,0);
//	lneigh << < gridDim, blockDim >> >(cuda_new_img, cuda_img, img1.rows, img1.cols,1);


//Zooming image with Bilinear image interpolation
	bilinear1 << <gridDim, blockDim >> >(cuda_new_img, cuda_img, img1.rows, img1.cols);
	bilinear2 << <gridDim, blockDim >> >(cuda_new_img, cuda_img, img1.rows, img1.cols);
	bilinear3 << <gridDim, blockDim >> >(cuda_new_img, cuda_img, img1.rows, img1.cols);



	cudaMemcpy(new_img, cuda_new_img, img1.rows*img1.cols*sizeof(unsigned char), cudaMemcpyDeviceToHost);
	Mat m=Mat(img1.rows , img1.cols , CV_8UC1,new_img); 
	psnr(img1, m);
	namedWindow("new_image", CV_WINDOW_AUTOSIZE);
	QueryPerformanceCounter(&t2);
	// compute and print the elapsed time in millisec
	elapsedTime = (t2.QuadPart - t1.QuadPart) * 1000.0 /
		frequency.QuadPart;
	imshow("new_image", m);
	waitKey(0);
	//psnr(img1, new_image);
	imwrite("C:\\Users\\User\\Downloads\\baboon(nearest neighbour).bmp", m);


	cout << elapsedTime << " ms.\n";

	return 0;

}
