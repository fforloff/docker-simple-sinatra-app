FROM alpine

COPY . /app
WORKDIR /app
ENV PORT 3000
RUN apk update && \
    apk add --no-cache ruby==2.3.3-r0 && \
    apk add --no-cache ruby-bundler=1.13.4-r0 && \
    apk add --no-cache nginx==1.10.3-r0 && \
    bundle install
CMD ruby helloworld.rb
