## Simple Sinatra app

### Docker Packaging
Why Docker?
- To achieve a Development-Test-QA-Production parity. "Build once - run anywhere".
- To allow for a predictable and repeatable deployment process of an application and its dependencies, plus easy rollbacks and possible blue/green deployments.
- To promote/encourage/enforce good practice. I.e. with docker it is easy to standartise service discovery, logging, monitoring/alerting, security aspects.
- Speeds up development process - docker instances boot up/shut down in seconds.
- Easy to achieve application scalability while maintaining cost effectiveness - allows for a denser deployment than the conventional VMs.

### Development of the application with Docker

```
git clone https://github.com/fforloff/docker-simple-sinatra-app.git
cd docker-simple-sinatra-app
docker build -f Dockerfile.dev -t app_dev . --no-cache
docker run -v $(pwd):/app -p 3000:3000 app_dev
# to test
curl localhost:3000
```
This setup is suitable for running on developers machines. The application directory is volume-mounted inside a docker instance. This allows to work on the code without rebuilding the image.

Notes:
- Alpine Linux is used as a base image, with a minimal list of packages deployed. There are no other docker security measures implemented in this option.
- Group 'unicorn' is added to the Gemfile - therefore the same Gemfile can be used for this example (with 'bundle install --without unicorn') and the one below.
- Gemfile.lock is currently in .gitignore.


### All-in-one deployment with Docker

```
git clone https://github.com/fforloff/docker-simple-sinatra-app.git
cd docker-simple-sinatra-app
docker build -f Dockerfile.allinone -t app_allinone . --no-cache
docker run -d -p 8080:8080 app_allinone
# to test
curl localhost:8080
```
With this deployment the Sinatra application is packaged with the Unicorn application server and NGINX web server as a single Docker image.

It uses the same Alpine base image as the option above, however, for additional security, both Unicorn and NGINX are run as a non-privileged user.

Sinatra application code is copied at the Docker build time, therefore the resulting image is suitable for a non-production application sharing, i.e. as a dependency for another application development/testing.

### Web and App as a separate Docker containers

```
git clone https://github.com/fforloff/docker-simple-sinatra-app.git
cd docker-simple-sinatra-app
docker-compose build --no-cache
docker-compose up -d
# to test
curl localhost:8080
```
This is a sample multi-container setup. It uses docker-compose for linking web and application containers.

For a purpose of simplicity both components are re-using the same Dockerfile as in the all-in-one solution. nginx.conf.compose and unicorn.rb.compose change communication method from a socket file to a TCP port. These files are volume-mounted on the NGINX and on the application containters at the run time.

A simple application scaliability/load balancing can be achieved with 'docker-compose scale' command, i.e.:
```
docker-compose scale appsrv=2
```

### Possible Future Improvements
- Separate dockerfiles for the app and the web components - to allow for independent management of the NGINX version and Unicorn/Ruby version.
- Copy nginx.conf.compose and unicorn.rb.compose at the build time for portability
- Use HTTPS
- Introduce service discovery / orchestration, i.e. with Hashicorp Consul or ETCD, Joyent ContainerPilot, Hashicorp consul-template. This will allow for the future production deployment across multiple network tiers.
- Package static content (if any) with the NGINX image -  for improved performance.
