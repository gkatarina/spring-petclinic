 #!/bin/bash
 
if docker ps -q --filter "name=$CI_DOCKER_IMAGE_NAME" || docker ps -aq --filter "name=$CI_DOCKER_IMAGE_NAME"; then
    echo "Container found. Removing..";
    docker stop $CI_DOCKER_IMAGE_NAME;
    docker rm $CI_DOCKER_IMAGE_NAME;
    echo "Container removed";
    docker pull $CI_DOCKER_IMAGE_NAME:$TAG_VERSION;
    docker run -d --name $CI_DOCKER_IMAGE_NAME:$TAG_VERSION -p 80:8080 -e SPRING_PROFILES_ACTIVE=mysql -e GOOGLE_APPLICATION_CREDENTIALS=$GCP_KEY -v $GCP_KEY:$GCP_KEY $CI_DOCKER_IMAGE_NAME:$TAG_VERSION;
    echo "Application link: $lb_ip";
else
    echo "Container not found.";
    docker pull $CI_DOCKER_IMAGE_NAME:$TAG_VERSION;
    docker run -d --name $CI_DOCKER_IMAGE_NAME:$TAG_VERSION -p 80:8080 -e SPRING_PROFILES_ACTIVE=mysql -e GOOGLE_APPLICATION_CREDENTIALS=$GCP_KEY -v $GCP_KEY:$GCP_KEY $CI_DOCKER_IMAGE_NAME:$TAG_VERSION;
    echo "Application link: $lb_ip";
fi