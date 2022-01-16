FROM alpine:latest
COPY ./script.sh /tmp/script.sh
RUN apk add apache2 \
&& apk add openrc \
&& apk add jq \
&& chmod +x /tmp/script.sh \
&& apk add --update curl \
&& rm -rf /etc/apk/cache
CMD ["/tmp/script.sh"]

EXPOSE 80
