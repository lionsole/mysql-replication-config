## 主从数据库启动
docker run --name mysql.master \
-p 3306:3306 \
-v /Users/tan/Projects/Workspace/ainit/dockers/my.master.cnf:/etc/mysql/my.cnf \
-v ${HOME}/DockerSource/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
--rm \
-d mysql:5.7.22

docker run --name mysql.slave \
-p 3307:3306 \
-v /Users/tan/Projects/Workspace/ainit/dockers/my.slave.cnf:/etc/mysql/my.cnf \
-v ${HOME}/DockerSource/mysql/data-slave:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
--rm \
-d mysql:5.7.22

## 主库配置
CREATE USER 'slave'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';  

show master status;

## Docker 网址信息
docker inspect --format='{{.NetworkSettings.IPAddress}}' 

## 从库配置
change master to master_host='172.17.0.2', master_user='slave', master_password='password', master_port=3306, master_log_file='zhongshu.000004', master_log_pos=609, master_connect_retry=30;  

show slave status \G;
show slave status;
start slave;

master_host: Master 的IP地址
master_user: 在 Master 中授权的用于数据同步的用户
master_password: 同步数据的用户的密码
master_port: Master 的数据库的端口号
master_log_file: 指定 Slave 从哪个日志文件开始复制数据，即上文中提到的 File 字段的值
master_log_pos: 从哪个 Position 开始读，即上文中提到的 Position 字段的值
master_connect_retry: 当重新建立主从连接时，如果连接失败，重试的时间间隔，单位是秒，默认是60秒。


## 主从库操作
master> CREATE USER 'repl'@'%.example.com' IDENTIFIED BY 'password';
master> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.example.com';

slave> CHANGE MASTER TO
    ->     MASTER_HOST='master_host_name',
    ->     MASTER_USER='replication_user_name',
    ->     MASTER_PASSWORD='replication_password',
    ->     MASTER_LOG_FILE='recorded_log_file_name',
    ->     MASTER_LOG_POS=recorded_log_position;

### 备份
shell> mysql -h master < fulldb.dump

### Setting Up Replication with Existing Data
1. Start the slave, using the --skip-slave-start option so that replication does not start.
2. Import the dump file:
```
mysql < fulldb.dump
```
3. change master ...
4. start slave

## 数据库操作集合
SET @@GLOBAL.read_only = ON;
SHOW BINARY LOGS;

mysqlbinlog --read-from-remote-server --host=host_name --raw
  binlog.000130 binlog.000131 binlog.000132

mysqlbinlog --read-from-remote-server --host=host_name --raw
  --to-last-log binlog.000130

mysqlbinlog --read-from-remote-server --host=host_name --raw
  --stop-never binlog.000130

### 备份恢复
mysql --host=host_name -u root -p < dump_file

## 验证同步方法
1. 新建数据库




## 参考文章
1. [官网文档](https://dev.mysql.com/doc/refman/5.7/en/replication-howto.html)
2. [简书](https://www.jianshu.com/p/ab20e835a73f)
3. [同步日志参考](https://dev.mysql.com/doc/refman/5.7/en/mysqlbinlog-backup.html)
4. [数据备份同步](https://dev.mysql.com/doc/refman/5.7/en/replication-snapshot-method.html)

