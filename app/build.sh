#!/bin/bash


url="$reg_id:$tag"

echo $(aws ecr get-login-password --region $( echo $reg_id| awk -F"." '{print $4}') | docker login --username AWS --password-stdin $(echo $reg_id| grep -o '[^"]*com'))

echo $(docker build  -t $url .)

echo $(docker push  $url)
