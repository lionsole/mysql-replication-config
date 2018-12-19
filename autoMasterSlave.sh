#!/bin/bash

MASTER_DIR=/var/lib/mysql/mysql-master
SLAVE_DIR=/var/lib/mysql/mysql-slave

## First we could rm the existed container
docker rm -f mysql-master
docker rm -f mysql-slave

## Rm the existed directory
rm -rf $MASTER_DIR
rm -rf $SLAVE_DIR

## Start instance
docker run -p 3306 --name mysql-master  -v /etc/master.cnf:/etc/mysql/my.cnf -v $MASTER_DIR:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d master/mysql:5.7.20
docker run -p 3306 --name mysql-slave  -v /etc/slave.cnf:/etc/mysql/my.cnf -v $MASTER_DIR:/var/lib/mysql --link mysql-master:master -e MYSQL_ROOT_PASSWORD=root -d slave/mysql:5.7.20

## Creating a User for Replication
docker stop mysql-master mysql-slave
docker start mysql-master mysql-slave

sleep 3

docker exec -it mysql-master mysql -S /var/lib/mysql/mysql.sock -e "CREATE USER 'users'@'127.0.0.1' IDENTIFIED BY 'mysql';GRANT REPLICATION SLAVE ON *.* TO 'users'@'127.0.0.1';"

## Obtaining the Replication Master Binary Log Coordinates
master_status=`docker exec -it master mysql -S /var/lib/mysql/mysql.sock -e "show master status\G"`
master_log_file=`echo "$master_status" | awk  'NR==2{print substr($2,1,length($2)-1)}'`
master_log_pos=`echo "$master_status" | awk 'NR==3{print $2}'`
master_log_file="'""$master_log_file""'"

## Setting Up Replication Slaves 
docker exec -it mysql-slave mysql -S /var/lib/mysql/mysql.sock -e "CHANGE MASTER TO MASTER_HOST='master',MASTER_PORT=3306,MASTER_USER='users',MASTER_PASSWORD='mysql',MASTER_LOG_FILE=$master_log_file,MASTER_LOG_POS=$master_log_pos;"
docker exec -it mysql-slave mysql -S /var/lib/mysql/mysql.sock -e "start slave;"
docker exec -it mysql-slave mysql -S /var/lib/mysql/mysql.sock -e "show slave status\G"

## Creates shortcuts
grep "alias mysql-master" /etc/profile
if [ $? -eq 1 ];then
    echo 'alias mysql="docker exec -it mysql-master mysql"' >> /etc/profile
    echo 'alias master="docker exec -it mysql-master mysql -h 127.0.0.1 -P3306"' >> /etc/profile
    echo 'alias slave="docker exec -it mysql-master mysql -h 127.0.0.1 -P3307"' >> /etc/profile
    source /etc/profile
fi
