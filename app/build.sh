#!/bin/bash


echo $region,$reg_id,$tag

url=$reg_id.dkr.ecr.$region.amazonaws.com/$app_name:$tag

echo $url
echo $(aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $reg_id.dkr.ecr.$region.amazonaws.com)

echo $(docker build  -t $url .)

echo $(docker push  $url)
