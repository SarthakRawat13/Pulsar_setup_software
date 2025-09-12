1. First you need to install opencv

a. Download files from github
mkdir ./opencv
cd ./opencv
git clone -b 4.10.0 https://github.com/opencv/opencv.git
git clone -b 4.10.0 https://github.com/opencv/opencv_contrib.git
 

b. Install files
mkdir build && cd build
cmake ../opencv   -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules   -DCMAKE_BUILD_TYPE=Release   -DCMAKE_INSTALL_PREFIX=/usr/local   -DWITH_TBB=ON   -DWITH_V4L=ON   -DENABLE_NEON=ON   -DENABLE_VFPV3=OFF   -DCPU_BASELINE=NEON   -DCPU_DISPATCH=NEON_FP16,NEON_DOTPROD
 
make -j2
make install
 
 
2. Copy small_objection folder in your board.
 
