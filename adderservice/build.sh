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
    sudo -i -u pelger docker build -t adderservice:$GITSHA .
    sudo -i -u pelger docker tag adderservice:$GITSHA pelger/adderservice:$GITSHA 
    sudo -i -u pelger docker push pelger/adderservice:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ -e s/_IMAGE_/pelger\\/adderservice:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo -i -u pelger kubectl apply -f svc.yml
    sudo -i -u pelger kubectl apply -f dep.yml
  ;;
  *)
    echo 
    exit 1
  ;;
esac

