# GPU-Image-Interpolation
Main aim in this project was to implement basic Image Interpolation Technique in NVIDIA CUDA C/C++ which would enhance our processing speed upto a great extent.
I implemented various GPU schemes for image interpolation such as 
1) Nearest neighbor interpolation: This method copies the nearest pixel to fill the empty positions.
2) Bilinear interpolation : This method takes the average of the four closest pixels to the specified input coordinates, and assigns that value to the output coordinates.
                            The two linear interpolations are performed in one direction and next linear
                            interpolation is performed in the perpendicular direction.
3) Bicubic interpolation : Bicubic interpolation is an extension of cubic interpolation for interpolating data points on a two dimensional regular grid. The interpolated surface is smoother than corresponding surfaces obtained by bilinear or nearest-neighbor interpolation.

In these three interpolation optimization technique were also used to further enhance GPU performence
1) GPU-based on many thread blocks using Global memory.
2) Further Optimization With Register Memory.
3) Further Improvement With More L1 Cache Than Shared Memory.
4) Using Asynchronous Data Transfer for Further Speeding Up.
