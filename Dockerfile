FROM debian:buster-slim
MAINTAINER jandre
COPY srcs/start.sh .
# COPY srcs/nginxconf .
# COPY srcs/info.php .
RUN sh start.sh .
