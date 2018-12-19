FROM mysql

EXPOSE 3306

COPY my.cnf /etc/mysql/

CMD ["mysqld"]
