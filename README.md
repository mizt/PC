# PC

```
const PM = [1.426317,0.000000,0.000000,0.000000,0.000000,2.535675,0.000000,0.000000,-0.001979,0.004613,-1.000000,-1.000000,0.000000,0.000000,-0.001000,0.000000];
const TM = [1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,-0.000000,0.000000,-0.000000,0.000000,1.000000,0.000000,0.000000,-0.000000,0.000000,1.000000];
```

```
cd "$(dirname "$0")"
cd ./

set -eu

LIBS="../libs"
echo ${LIBS}

clang++ -std=c++20 -Wc++20-extensions -fobjc-arc -O3 \
-framework Cocoa \
-I${LIBS}/boost/1.82.0_1/include \
${LIBS}/boost/1.82.0_1/lib/libboost_atomic-mt.a \
${LIBS}/boost/1.82.0_1/lib/libboost_filesystem-mt.a \
${LIBS}/lz4/1.9.4/lib/liblz4.a \
-I${LIBS}/eigen/3.4.0_1/include/eigen3 \
-I${LIBS}/flann/1.9.2_1/include \
${LIBS}/flann/1.9.2_1/lib/libflann_s.a \
-I${LIBS}/pcl/include \
-L${LIBS}/pcl/lib \
-lpcl_common -lpcl_kdtree -lpcl_filters -lpcl_search -lpcl_surface \
./main.mm \
-o ./main

./main
```