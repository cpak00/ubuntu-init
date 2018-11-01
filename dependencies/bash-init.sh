#! /bin/bash

# init define
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
RES='\E[0m'

info(){
 echo -e "${GREEN_COLOR}$1${RES}"
}

warning(){
 echo -e "${YELLOW_COLOR}$1${RES}"
}

error(){
 echo -e "${RED_COLOR}$1${RES}"
}

info "init finished"