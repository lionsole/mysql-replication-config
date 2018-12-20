## Proxysql 设置

### 启动
docker run --name proxysql \
--rm \
-p 6033:6033 -p 6032:6032 \
-v /Users/tan/Projects/Workspace/ainit/dockers/proxysql.cnf:/etc/proxysql.cnf \
-v ${HOME}/DockerSource/mysql/proxydata:/var/lib/proxysql \
-d severalnines/proxysql

mysql -u admin -padmin -h 127.0.0.1 -P6032 --prompt='Admin> '

insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(1,'172.17.0.2',3306,1,'Write Group');
insert into mysql_servers(hostgroup_id,hostname,port,weight,comment) values(2,'172.17.0.3',3307,1,'Read Group');
insert into mysql_users(username,password,default_hostgroup,transaction_persistent) values('monitor','monitor',2,1);

UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_password';


### 相应数据库设置
GRANT SELECT ON *.* TO 'monitor'@'%' IDENTIFIED BY 'monitor';

LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

### Proxy check
select * from mysql_servers;
select * from mysql_users;
select * from stats_mysql_connection_pool;
select hostgroup,srv_host,srv_port,status,Queries from stats_mysql_connection_pool;

SELECT * FROM monitor.mysql_server_ping_log ORDER BY time_start_us DESC LIMIT 10;
SELECT digest,SUBSTR(digest_text,0,25),count_star,sum_time FROM stats_mysql_query_digest WHERE digest_text LIKE 'SELECT%' ORDER BY count_star DESC LIMIT 5;

#### 规则击中率
select * from stats_mysql_query_rules;

#### To check how what statements application has executed :
select Command,Total_Time_us,Total_cnt from stats_mysql_commands_counters where Total_Time_us> 0 ;

SELECT hostgroup, username, digest_text, count_star, sum_time FROM stats_mysql_query_digest;


#### Test DML Queries
INSERT INTO mysql_query_rules(rule_id,active,username,schemaname,match_digest,mirror_hostgroup,apply) VALUES (12,1,"sysbench","sbtest","^(INSERT|UPDATE|DELETE)",7,1);

#### workbench
sysbench --test=oltp --oltp-table-size=10000 --mysql-db=sbtest --mysql-user=sysbench --db-driver=mysql --mysql-password=sysbench --mysql-host=127.0.0.1 --max-time=1 --oltp-read-only=off --max-requests=0 --mysql-port=6033 --num-threads=1 --db-ps-mode=disable run


## 参考
[proxysql debug](https://mydbops.wordpress.com/2018/04/13/proxysql-series-mirroring-mysql-queries/)
[proxysql config](https://github.com/sysown/proxysql/wiki/ProxySQL-Configuration)
[proxysql config](http://seanlook.com/2017/04/10/mysql-proxysql-install-config/)
[proxysql router](http://seanlook.com/2017/04/17/mysql-proxysql-route-rw_split/)
[proxy operations](https://severalnines.com/blog/mysql-load-balancing-proxysql-overview)
[proxysql performance](https://www.percona.com/blog/2017/04/10/proxysql-rules-do-i-have-too-many/#comment-10967989)
[proxysql performance](http://seanlook.com/2017/04/20/mysql-proxysql-performance-test/)
