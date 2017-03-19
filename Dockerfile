FROM alpine

COPY . /app
RUN apk update && \
    apk add --no-cache ruby==2.3.3-r0 && \
    apk add --no-cache ruby-bundler=1.13.4-r0 && \
    apk add --no-cache nginx==1.10.3-r0 && \
    chown -R nginx:www-data /app
USER nginx
WORKDIR /app
ENV PORT 3000
ENV GEM_HOME /app/.gem
ENV PATH $PATH:/app/.gem/bin
RUN  bundle install --no-cache
CMD ruby helloworld.rb
