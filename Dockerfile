FROM alpine

COPY . /app
RUN apk update && \
    apk --no-cache add ruby==2.3.3-r0 \
    ruby-bundler=1.13.4-r0 \
    build-base ruby-dev=2.3.3-r0 libc-dev linux-headers \
    nginx==1.10.3-r0 && \
    chown -R nginx:www-data /app && \
    rm /etc/nginx/nginx.conf && \
    mv /app/nginx.conf /etc/nginx/nginx.conf && \
    ln -sf /dev/stdout /var/lib/nginx/logs/access.log && \
    ln -sf /dev/stderr /var/lib/nginx/logs/error.log
USER nginx
WORKDIR /app
ENV PORT 3000
ENV GEM_HOME /app/.gem
ENV PATH $PATH:/app/.gem/bin
RUN bundle install --no-cache --without development test
CMD unicorn -c unicorn.rb -D && nginx -g 'daemon off;'
