#!/bin/bash

K3S_MASTER_IP=192.168.2.23

# Create stream configuration directory if it doesn't exist
sudo mkdir -p /etc/nginx/streams-enabled

# Configure Nginx for TCP/UDP load balancing
cat << EOF | sudo tee /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 1024;
}

# HTTP server configuration
http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                    '\$status \$body_bytes_sent "\$http_referer" '
                    '"\$http_user_agent"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}

# Stream configuration for TCP/UDP load balancing
stream {
    log_format stream '\$remote_addr \$upstream_addr - [\$time_local] '
                     '\$status \$upstream_bytes_sent \$upstream_bytes_received '
                     '\$session_time';

    access_log /var/log/nginx/stream_access.log stream;
    error_log /var/log/nginx/stream_error.log;

    include /etc/nginx/streams-enabled/*;
}
EOF

# Create TCP services configuration
cat << EOF | sudo tee /etc/nginx/streams-enabled/k8s-services.conf
# K8s API
upstream k8s-api {
    server ${K3S_MASTER_IP}:6443;
}

server {
    listen 6443;
    proxy_pass k8s-api;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# PostgreSQL
upstream postgres-backend {
    server ${K3S_MASTER_IP}:5432;
}

server {
    listen 5432;
    proxy_pass postgres-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# Redis
upstream redis-backend {
    server ${K3S_MASTER_IP}:6379;
}

server {
    listen 6379;
    proxy_pass redis-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# RabbitMQ AMQP
upstream rabbitmq-backend {
    server ${K3S_MASTER_IP}:5672;
}

server {
    listen 5672;
    proxy_pass rabbitmq-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# RabbitMQ Management (HTTP)
upstream rabbitmq-mgmt-backend {
    server ${K3S_MASTER_IP}:15672;
}

server {
    listen 15672;
    proxy_pass rabbitmq-mgmt-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# Elasticsearch
upstream elasticsearch-backend {
    server ${K3S_MASTER_IP}:9200;
}

server {
    listen 9200;
    proxy_pass elasticsearch-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# Kibana
upstream kibana-backend {
    server ${K3S_MASTER_IP}:5601;
}

server {
    listen 5601;
    proxy_pass kibana-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# APM Server
upstream apm-backend {
    server ${K3S_MASTER_IP}:8200;
}

server {
    listen 8200;
    proxy_pass apm-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# MongoDB
upstream mongodb-backend {
    server ${K3S_MASTER_IP}:27017;
}

server {
    listen 27017;
    proxy_pass mongodb-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# MinIO API
upstream minio-api-backend {
    server ${K3S_MASTER_IP}:9000;
}

server {
    listen 9000;
    proxy_pass minio-api-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# MinIO Console
upstream minio-console-backend {
    server ${K3S_MASTER_IP}:9090;
}

server {
    listen 9090;
    proxy_pass minio-console-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# OpenTelemetry Collector gRPC
upstream otlp-grpc-backend {
    server ${K3S_MASTER_IP}:4317;
}

server {
    listen 4317;
    proxy_pass otlp-grpc-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}

# Grafana
upstream grafana-backend {
    server ${K3S_MASTER_IP}:3000;
}

server {
    listen 3000;
    proxy_pass grafana-backend;
    proxy_timeout 300s;
    proxy_connect_timeout 5s;
}
EOF

# Test Nginx configuration
sudo nginx -t

# Enable and restart Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "Nginx load balancer configuration complete!"
echo "K3s API endpoint: localhost:6443"
echo "PostgreSQL endpoint: localhost:5432"
echo "Redis endpoint: localhost:6379"
echo "RabbitMQ endpoint: localhost:5672"
echo "RabbitMQ Management: http://localhost:15672"
echo "Elasticsearch endpoint: https://localhost:9200"
echo "Kibana UI: https://localhost:5601"
echo "APM Server: https://localhost:8200"
echo "MongoDB endpoint: mongodb://localhost:27017"
echo "MinIO S3 API endpoint: http://localhost:9000"
echo "MinIO Console: http://localhost:9090"
echo "OpenTelemetry Collector gRPC: localhost:4317"
echo "Grafana UI: http://localhost:3000"