FROM debian:buster-slim
MAINTAINER jandre
COPY srcs/start.sh .
COPY srcs/nginxconf .
COPY srcs/config.inc.php .
COPY srcs/wp-config.php .
RUN bash start.sh && tail -f /dev/null