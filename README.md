# 3D-Reconstruction-using-Homography-Constraints-for-Uncalibrated-Images
This repo contains an implementation of 3D reconstruction and Plane detection using plane-to-plane homography constraints for uncalibrated image pair under Manhattan World Assumption. Given 2 images of the same scene from different perspective which has three main orthogonal planes in space, the planes can be reconstructed up to scale. **Notice here we don't require any calibration parameters, everything is computed from 2 raw images from scratch!**  

## Sample Results
<img src="https://github.com/ziliHarvey/3D-Reconstruction-using-Homography-Constraints-for-Uncalibrated-Images/blob/master/images/input/1_002.jpg" width=30% height=30%><img src="https://github.com/ziliHarvey/3D-Reconstruction-using-Homography-Constraints-for-Uncalibrated-Images/blob/master/demo/demo.gif" width=40% height=40%><img src="https://github.com/ziliHarvey/3D-Reconstruction-using-Homography-Constraints-for-Uncalibrated-Images/blob/master/images/input/1_003.jpg" width=30% height=30%>

## Run
MATLAB 2018 or higher version is recommended.

### 3D Reconstruction and Plane Detection
Run reconstructionUsingHomography.m
### (Optional) Vanishing Point Detection
Run vanishingPointDetection.m
