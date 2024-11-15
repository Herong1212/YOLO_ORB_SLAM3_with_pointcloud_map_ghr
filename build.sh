# DBoW2 和 g2o 都只编译一次就好了，所以编译完一次把这些注释掉即可！

echo
echo "----------------- 1、Configuring and building Thirdparty/DBoW2 ... ---------------------------------"

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

echo "Configuring and building done!"

cd ../../g2o

echo
echo "----------------- 2、Configuring and building Thirdparty/g2o ... ---------------------------------"

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
echo "Configuring and building done!"

cd ../../Sophus

echo
echo "----------------- 3、Configuring and building Thirdparty/Sophus ... ---------------------------------"

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
echo "Configuring and building done!"

cd ../../../

# 字典文件解压一次就可以了！
echo
echo "-------------------------------- 4、Uncompress vocabulary ... -----------------------------------------"

# cd Vocabulary
# tar -xf ORBvoc.txt.tar.gz
# cd ..

echo
echo "------------- Boss: Configuring and building YOLO_ORB_SLAM3_with_pointcloud_map ... --------------------"

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
# make rgbd_tum -j4
make -j4
echo "Configuring and building done!"
