#!/bin/bash

# Create the namespace
kubectl apply -f trandoshan/namespace.yaml

# Install tor-proxy
kubectl apply -f trandoshan/tor-proxy/deployment.yaml
kubectl apply -f trandoshan/tor-proxy/service.yaml

# Install helm on the cluster
helm init

# Wait for tiller to be up
sleep 5

# Install NATS using helm
helm install --namespace trandoshan-io --name messaging-system -f trandoshan/nats-config.yaml stable/nats

# Install MongoDB using helm
helm install --namespace trandoshan-io --name database -f trandoshan/mongodb-config.yaml stable/mongodb

# Install API
kubectl apply -f trandoshan/api/deployment.yaml
kubectl apply -f trandoshan/api/service.yaml

# Install Crawler
kubectl apply -f trandoshan/crawler/deployment.yaml

# Install Persister
kubectl apply -f trandoshan/persister/deployment.yaml

# Install Scheduler
kubectl apply -f trandoshan/scheduler/deployment.yaml

# Finally send initial crawling url by deploying feeder job
kubectl apply -f trandoshan/feeder/job.yaml

# Install dashboard
#kubectl apply -f dashboard.yaml
#kubectl apply -f dashboard-user.yaml
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
#url: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.