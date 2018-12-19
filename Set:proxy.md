## Proxysql 设置

docker run --name proxysql \
--rm \
-p 6033:6033 -p 6032:6032 \
-d severalnines/proxysql

mysql -u admin -padmin -h 127.0.0.1 -P6032 --prompt='Admin> '

insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(1,'172.17.0.2',3306,1,'Write Group');
insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(2,'172.17.0.3',3307,1,'Read Group');

UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_password';

insert into mysql_users(username,password,default_hostgroup,transaction_persistent) values('monitor','monitor',2,1);

### 相应数据库设置
GRANT SELECT ON *.* TO 'monitor'@'%' IDENTIFIED BY 'monitor';

LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

### Proxy check
select * from mysql_servers;
select * from stats_mysql_connection_pool;
SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 10;
