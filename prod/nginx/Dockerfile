# base image ubuntu 14.04 image
FROM ubuntu:trusty

# set env vars
ENV INSTANCENAME mybook
ENV BOOKTYPE_SERVER 127.0.0.1:8000
ENV BOOKTYPE_URL http://127.0.0.1:8000
ENV BOOKTYPE_REDIS_HOST redis
ENV BOOKTYPE_BROKER_URL amqp://guest:guest@rabbit:5672/
ENV BOOKTYPE_DATABASE_ENGINE django.db.backends.postgresql_psycopg2
ENV BOOKTYPE_DATABASE_HOST db
ENV BOOKTYPE_DATABASE_PORT 5432
ENV BOOKTYPE_DATABASE_NAME booktype
ENV BOOKTYPE_DATABASE_USER booktype
ENV BOOKTYPE_DATABASE_PASSWORD booktype
ENV BOOKTYPE_PANDOC_PATH /usr/bin/pandoc
ENV BOOKTYPE_MPDF_DIR /code/mpdf60


# create booktype group, booktype user and assign it to the group
RUN groupadd booktype \
    && useradd booktype -g booktype -u 1000

# install system-wide dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    python-dev \
    python-pip \
    libjpeg-dev \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    tidy

ADD ./debs/pandoc-1.19.2.1-1-amd64.deb /home/pandoc-1.19.2.1-1-amd64.deb
RUN dpkg -i /home/pandoc-1.19.2.1-1-amd64.deb

# create dir for code
RUN mkdir -p /code/scripts

# create dir for configs
RUN mkdir -p /code/configs

# copy shell scripts
COPY scripts /code/scripts

# set working dir
WORKDIR /code

COPY ./code/Booktype/ /code/Booktype/
COPY ./code/mpdf60/ /code/mpdf60/

RUN apt-get -y install coreutils

# install && create && activate python virtualenv
# install python dependencies && generate project's skeleton
RUN pip install virtualenv \
    && virtualenv venv \
    && . venv/bin/activate \
    && pip install -r Booktype/requirements/prod.txt \
    && ./Booktype/scripts/createbooktype --database postgresql ${INSTANCENAME}

# make scripts executable
RUN chmod ug+x \
    scripts/web.sh \
    scripts/manage_py.sh \
    ${INSTANCENAME}/manage_prod.py

RUN chown -R booktype.booktype /code/ \
    && chmod -R 775 /code/${INSTANCENAME}/logs \
    && chmod -R 775 /code/${INSTANCENAME}/data

# copy configs
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY configs/nginx_booktype.conf /etc/nginx/sites-enabled/

EXPOSE 8000
USER booktype:booktype
CMD ["nginx", "-g", "daemon off;"]
