#!/bin/bash
wd=$(pwd)
ELEMENTS_PATH="$wd/custom-elements:$wd/diskimage-builder/diskimage_builder/elements"
#ELEMENTS_PATH="custom-elements:diskimage-builder/diskimage_builder/elements"

output_type=${output_type:-"raw"}
output_dir=${output_dir:-"output"}
input_dir=${input_dir:-"images"}
cache_dir=${cache_dir:-"cache"}
tmp_dir=${input_dir:-"tmp"}

images=$(ls $input_dir)
dib_cmd="ELEMENTS_PATH='$ELEMENTS_PATH' disk-image-create -t $output_type --image-cache $cache_dir --checksum"

echo "images found: $images"

for img in $images; do
    input_elements_file="$input_dir/$img/elements"
    input_env="$input_dir/$img/env"
    output_path="$output_dir/$img"
    echo "building $img from $input_elements_file and $input_env to create $output_path"
    input_elements=$(cat $input_elements_file | grep -v "#" | xargs echo)
    echo "image elements requested: $input_elements"
    build_cmd=". $input_env; $dib_cmd -o $output_path $input_elements"
    echo "Build command: $build_cmd"
    sudo -EH bash -c "$build_cmd"
done


