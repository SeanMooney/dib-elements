#!/bin/bash
wd=$(pwd)
ELEMENTS_PATH="$wd/custom-elements:$wd/diskimage-builder/diskimage_builder/elements"


output_type=${output_type:-"raw"}
output_dir=${output_dir:-"$wd/output"}
input_dir=${input_dir:-"$wd/images"}
cache_dir=${cache_dir:-"$wd/cache"}
tmp_dir=${input_dir:-"$wd/tmp"}
image_filter=${image_filter:-""}
docker_tag=${docker_tag:-"latest"}
docker_repo=${docker_repo:-"seanmooney"}

images=$(ls $input_dir | grep -E "$image_filter")
dib_cmd="ELEMENTS_PATH='$ELEMENTS_PATH' disk-image-create -t $output_type --image-cache $cache_dir --checksum"
echo images | xargs echo "images found:"

for img in $images; do
    docker_target=""
    input_elements_file="$input_dir/$img/elements"
    input_env="$input_dir/$img/env"
    output_path="$output_dir/$img"
    echo "building $img from $input_elements_file and $input_env to create $output_path"
    input_elements=$(cat $input_elements_file | grep -v "#" | xargs echo)
    echo "image elements requested: $input_elements"
    build_cmd=". $input_env; $dib_cmd -o $output_path"
    if [[  "${output_type}" =~ "docker" ]]; then
        docker_target="${docker_repo}/${img}:${docker_tag}"
        build_cmd+=" --docker-target ${docker_target}"
    fi
    build_cmd+=" ${input_elements}"
    echo "Build command: $build_cmd"
    sudo -EH bash -c "$build_cmd"
done


