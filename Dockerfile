FROM debian:buster-slim
MAINTAINER jandre
COPY srcs/start.sh .
COPY srcs/nginxconf .
COPY srcs/config.inc.php .
COPY srcs/wp-config.php .
COPY srcs/autoindex.sh .
ENTRYPOINT bash start.sh && tail -f /dev/null