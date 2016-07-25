#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include<math.h>
using namespace cv;
using namespace std;
void psnr(Mat img, Mat new_image)
{
	double sum = 0;
	Mat error(img.rows, img.cols, CV_8UC1);
	for (int i = 0; i < img.rows; i++)
	{
		for (int j = 0; j < img.cols; j++)
		{
			error.at<uchar>(i, j) = (int)fabs((double)img.at<uchar>(i, j) - (double)new_image.at<uchar>(i, j));
			sum += error.at<uchar>(i, j) *error.at<uchar>(i, j);
		}

	}
	sum /= (img.rows*img.cols);
	double psnr = pow(255, 2) / sum;
	psnr = 10 * log10(psnr);
	cout << psnr << endl;
}