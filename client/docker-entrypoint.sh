#!/bin/bash
gunicorn --paste config/webserver.ini --forwarded-allow-ips "*" -b 0.0.0.0:8080
