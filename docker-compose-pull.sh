#!/bin/bash
cd /home/ubuntu/wotc/
git pull
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 725661429481.dkr.ecr.us-east-1.amazonaws.com
docker-compose -f /home/ubuntu/wotc/docker-compose.yml pull
docker-compose -f /home/ubuntu/wotc/docker-compose.yml up -d