#!/bin/bash

# STEP 1: CREATE A NAMESPACE = assign
kubectl create ns assign

# STEP 2: create DB using  mysql-deployment.yaml and create a persistent volume and claim for this as well using mysql-pv.yaml
kubectl -n assign create -f mysql-pv.yaml
kubectl -n assign create -f mysql-deployment.yaml


#STEP 3: create DB named flaskapp , tbale name users and inserrt dummy data into it using below command  ( EX: mysql -u USER -pPASSWORD -e "SQL_QUERY" )

kubectl -n assign run -it --rm --image=mysql:5.6 --restart=Never mysql-client-db-create-client -- mysql -h mysql.assign.svc.cluster.local -ppassword -e "CREATE DATABASE flaskapp; "

kubectl -n assign  run -it --rm --image=mysql:5.6 --restart=Never mysql-client-table-create-client -- mysql -h mysql.assign.svc.cluster.local -ppassword -e "use flaskapp; CREATE TABLE users(name varchar(20), email varchar(40)); "

kubectl -n assign  run -it --rm --image=mysql:5.6 --restart=Never mysql-table-show-client -- mysql -h mysql.assign.svc.cluster.local -ppassword -e "use flaskapp; show tables; select * from users;"

kubectl -n assign run -it --rm --image=mysql:5.6 --restart=Never mysql-client-table-insert-client -- mysql -h mysql.assign.svc.cluster.local -ppassword -e "use flaskapp;INSERT INTO users (name, email) VALUES ('mayank','mayank@mayank.com') ;"

kubectl -n assign run -it --rm --image=mysql:5.6 --restart=Never mysql-client-table-insert-client -- mysql -h mysql.assign.svc.cluster.local -ppassword -e "use flaskapp;INSERT INTO users (name, email) VALUES ('test','test@test.com') ;"


# STEP 4: Create app deployment using app-deployment.yaml 
kubectl -n assign create -f app-deployment.yaml

# STEP 5: Create app service using app-service.yaml 
kubectl -n assign create -f app-service.yaml

#STEP 6: Create HPA group 
kubectl -n assign create -f HPA.yaml
echo " WAITING FOR POD TO COME UP"
sleep 20
#STEP 7: Increase load on APP to see the autoscalling
docker run --rm loadimpact/loadgentest-wrk -c 300 -t 100 -d 15m http://<NODE_IP>:30500

echo " user this url to connect with application = http://<NODE_IP>:30500/users"
