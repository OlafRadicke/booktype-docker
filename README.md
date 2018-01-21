# booktype-docker #
Dockerized booktype

# Concept #

In this setup we don't use a supervisord. Way? The roll of supervisord is to
control processes and this is a roll conflict with docker environment like
kubernets or swarm. A kubernets or swarm manager can't look insert in a
container and analyze issues of a supervisord. Kubernets, swarm and co is using
only the docker container api. So a depth controlling and orchestration of
many containers is a job of a tool like kubernets or swarm manager, but not
for a supervisord.

The other point is, a supervisord is unknow about other supervisors in other
container (and back). So if you have more than one setup, you get big trouble
with automation jobs and orchestration. Believe me, supervisors do not solve
your problems

About setup scrips: It is inspired by githubs [Scripts To Rule Them All](https://github.com/github/scripts-to-rule-them-all)

# Requirements #

- Docker
- docker-compose
- \> 3GB disc storage
- wget
- uzip

# Bootstrap project #

To download the (latest version of) Booktype code enter:

```bash
./script/bootstrap
```

# Setup #

Enter:

```bash
./script/setup
```
for preparing the docker volumes directories.

# Run application #

Switch in the directory /prod . Enter:

```bash
docker-compose up
```

It will be build the docker images and start them.

# Parts of this setup #

This setup works some difference docker container together.  

## Nginx ##

This is a webserver and wokks as a load balancer and deliver static contents.

## PostgreSQL ##

This is a SQL database and works as storage and back end.

## Rabbit ##

This is a message queue.

## Redis ##

Redis is an in-memory data structure store, used as a database, cache and
message broker.

## uWSGI ##

uWSGI application server container.

## Celery ##

Celery is an open source asynchronous task queue or job queue which is based on
distributed message passing.

# todos #

# Questions #

## Way need this project three queues (Rabbit, Redis and Celery)? ##
