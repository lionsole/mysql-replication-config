docker run --rm -v ${HOME}/DockerSource/mysql/data:/var/lib/mysql -v ${HOME}/Playspace/Sql:/root/playspace --name mysql -u root -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysql


docker inspect --format='{{.NetworkSettings.IPAddress}}' 53e248296a37

docker run --name mysql_master -p 3306:3306 -v ${HOME}/DockerSource/mysql/my.cnf:/etc/mysql/my.cnf -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7.22
docker run --name mysql_slave -p 3307:3306 -v ${HOME}/DockerSource/mysql/my01.cnf:/etc/mysql/my.cnf -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7.22

docker run --name mysql_slave -p 3307:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql


docker run --rm -v ${HOME}/DockerSource/mysql/data:/var/lib/mysql -v ${HOME}/Playspace/Sql:/root/playspace --name mysql -u root -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysqlmaster:1.0.0


change master to master_host='172.17.0.2', master_user='slave', master_password='123456', master_port=3306, master_log_file='zhongshu.000001', master_log_pos=154, master_connect_retry=30;


docker run -v /Users/tan/DockerSource/mysql/proxysql.cnf:/etc/proxysql.cnf -d severalnines/proxysql


mysql -uadmin -padmin -h127.0.0.1 -P6032
mysql -uadmin -padmin -h127.0.0.1 -P6032
mysql -uadmin -padmin -h127.0.0.1 -P6032 --prompt='Admin> '

mysql -uroot -p123456 -h127.0.0.1 -P6032 --prompt='Master> '

