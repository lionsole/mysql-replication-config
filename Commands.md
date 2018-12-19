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



insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(1,'172.17.0.2',3306,1,'Write Group');
insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(2,'172.17.0.3',3307,1,'Read Group');

UPDATE mysql_servers SET max_connections=10 WHERE hostname='172.16.0.2';
UPDATE mysql_servers SET weight=1 WHERE hostname='172.16.0.1' AND hostgroup_id=1;
UPDATE mysql_servers SET status='OFFLINE_SOFT' WHERE hostname='172.16.0.2';
DELETE FROM mysql_servers WHERE hostgroup_id=1 AND hostname IN ('172.16.0.1','172.16.0.2');

### proxysql mysql 分别对应设置
GRANT ALL ON *.* TO 'proxysql'@'%' IDENTIFIED BY '123456';
GRANT SELECT ON *.* TO 'monitor'@'%' IDENTIFIED BY 'monitor';


insert into mysql_users(username,password,default_hostgroup,transaction_persistent) values('root','123456',1,1);
insert into mysql_users(username,password,default_hostgroup,transaction_persistent) values('monitor','monitor',2,1);


