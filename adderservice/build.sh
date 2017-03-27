#!/bin/bash
sh source ~/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
  build)
    npm install
  ;;
  test)
    npm test
  ;;
  container)
    sudo docker build -t adderservice:$GITSHA .
    sudo docker tag adderservice:$GITSHA pelger/adderservice:$GITSHA 
    echo _________________________________________________________
    whoami
    sudo whoami

    test docker login -> ger rid of the push here and just login with echo and close

    sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD && docker push pelger/adderservice:$GITSHA 

    #sadfsdf sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD && docker push pelger/adderservice:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ -e s/_IMAGE_/pelger\\/adderservice:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo kubectl apply -f svc.yml
    sudo kubectl apply -f dep.yml
  ;;
  *)
    echo 
    exit 1
  ;;
esac

