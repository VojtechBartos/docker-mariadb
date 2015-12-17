FROM tutum/mariadb:5.5
MAINTAINER Vojta Bartos <hi@vojtech.me>

ADD create_mariadb_database_and_user.sh /create_mariadb_database_and_user.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
