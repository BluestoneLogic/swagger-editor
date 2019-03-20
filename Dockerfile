FROM centos:7

MAINTAINER jlevin

COPY ./docker-run.sh /

RUN yum install epel-release -y \
	&& yum install nginx -y 
	&& yum clean all -y

RUN mkdir -p /run/nginx \
	&& chown -R 1001:0 /etc/nginx \
	&& chown -R 1001:0 /usr/share/nginx/html \
	&& chown -R 1001:0 docker-run.sh
	&& chmod -R g=u /etc/nginx \
	&& chmod -R g=u /usr/share/nginx/html \
	&& chmod -R g=u docker-run.sh

RUN touch /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && chown -R 1001:0 /var/log/nginx \
    && chown -R 1001:0 /var/log/nginx \
    && chown -R 1001:0 /var/log/nginx/error.log \
    && chown -R 1001:0 /var/log/nginx/access.log \
    && chmod -R g=u /var/log/nginx \
    && chmod -R g=u /var/log/nginx \
    && chmod -R g=u /var/log/nginx/error.log \
    && chmod -R g=u /var/log/nginx/access.log

COPY nginx.conf /etc/nginx/

# copy swagger files to the `/js` folder
COPY ./index.html /usr/share/nginx/html/
ADD ./dist/*.js /usr/share/nginx/html/dist/
ADD ./dist/*.map /usr/share/nginx/html/dist/
ADD ./dist/*.css /usr/share/nginx/html/dist/
ADD ./dist/*.png /usr/share/nginx/html/dist/
ADD ./docker-run.sh /usr/share/nginx/

RUN find /usr/share/nginx/html/ -type f -regex ".*\.\(html\|js\|css\)" -exec sh -c "gzip < {} > {}.gz" \;

EXPOSE 8080

USER 1001

CMD ["sh", "/usr/share/nginx/docker-run.sh"]
