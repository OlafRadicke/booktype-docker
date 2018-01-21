#!/bin/bash
id
cd /code
/code/venv/bin/python /code/mybook/manage_prod.py celery worker --concurrency=10
