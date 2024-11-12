# DBoW2 和 g2o 都只编译一次就好了，所以编译完一次把这些注释掉即可！
echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

cd ../../Sophus

echo "Configuring and building Thirdparty/Sophus ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

# cd ../../../

# echo "Uncompress vocabulary ..."          字典文件解压一次就可以了！

# cd Vocabulary
# tar -xf ORBvoc.txt.tar.gz
# cd ..

# echo "Configuring and building YOLO_ORB_SLAM3 ..."
echo "Configuring and building YOLO_ORB_SLAM3_with_pointcloud_map ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
# make rgbd_tum -j4
make rgbd_tum -j
