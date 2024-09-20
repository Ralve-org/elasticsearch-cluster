# Elasticsearch 8-Node Cluster with Kibana

This repository provides a comprehensive setup for deploying an 8-node Elasticsearch cluster secured with SSL/TLS and integrated with Kibana for data visualization. The setup leverages Docker Compose for container orchestration, ensuring a scalable and manageable environment.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Configure Environment Variables](#2-configure-environment-variables)
  - [3. Generate SSL Certificates](#3-generate-ssl-certificates)
  - [4. Configure Elasticsearch and Kibana](#4-configure-elasticsearch-and-kibana)
  - [5. Start the Elasticsearch Cluster and Kibana](#5-start-the-elasticsearch-cluster-and-kibana)
  - [6. Access Kibana](#6-access-kibana)
- [Stopping the Cluster](#stopping-the-cluster)
- [GitHub Configuration](#github-configuration)
  - [1. Initialize Git Repository](#1-initialize-git-repository)
  - [2. Create `.gitignore`](#2-create-gitignore)
  - [3. Commit and Push to GitHub](#3-commit-and-push-to-github)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Features

- **8-Node Elasticsearch Cluster**: Distributed setup for high availability and fault tolerance.
- **Kibana Integration**: Real-time data visualization and monitoring.
- **SSL/TLS Security**: Secure communication between nodes and Kibana.
- **Docker Compose**: Simplified container orchestration and management.
- **Scalable Configuration**: Easily extendable to more nodes if needed.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Operating System**: Linux-based OS (e.g., Ubuntu, CentOS)
- **Docker**: Installed and running. [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: Installed. [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Git**: Installed. [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- **Sufficient Resources**: Ensure your server has enough memory and CPU to handle 8 Elasticsearch nodes and Kibana. Recommended: At least 32GB RAM.

## Project Structure

## Project Structure

```plaintext
elasticsearch-cluster/
├── certs/
│   └── ... (SSL certificates)
├── generate-certificates.sh
├── kibana/
│   └── config/
│       └── kibana.yml
├── node1/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node2/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node3/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node4/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node5/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node6/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node7/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── node8/
│   ├── config/
│   │   └── elasticsearch.yml
│   └── data/
├── docker-compose.yml
└── .gitignore



- **certs/**: Directory to store SSL certificates.
- **generate-certificates.sh**: Script to generate SSL certificates for Elasticsearch nodes.
- **kibana/config/kibana.yml**: Configuration file for Kibana.
- **nodeX/config/elasticsearch.yml**: Configuration files for each Elasticsearch node (replace `X` with node number).
- **nodeX/data/**: Data directories for each Elasticsearch node (excluded from Git).
- **docker-compose.yml**: Docker Compose configuration file to orchestrate the services.
- **.gitignore**: Specifies intentionally untracked files to ignore.

## Setup Instructions

Follow these steps to set up the Elasticsearch cluster and Kibana on a new server.

### 1. Clone the Repository

First, clone the repository to your server:

```bash
git clone https://github.com/Ralve-org/elasticsearch-cluster.git

cd elasticsearch-cluster

### 2. Configure Environment Variables

Ensure that the environment variables in `docker-compose.yml` are correctly set. Specifically, verify the `ELASTIC_PASSWORD` and any other sensitive information.

### 3. Generate SSL Certificates

The `generate-certificates.sh` script handles SSL certificate generation for each Elasticsearch node. Ensure the script has execution permissions:

```bash
chmod +x generate-certificates.sh

The script will automatically generate the necessary certificates when you start the Docker containers.

### 4. Configure Elasticsearch and Kibana

Ensure that each Elasticsearch node has its own elasticsearch.yml configuration file. Below is an example configuration for node1 (node1/config/elasticsearch.yml):

```bash
cluster.name: "prod-cluster"
node.name: "es-node1"
path.data: /usr/share/elasticsearch/data
path.logs: /usr/share/elasticsearch/logs
network.host: 0.0.0.0
http.port: 9200
transport.port: 9300
discovery.seed_hosts: ["es-node1", "es-node2", "es-node3", "es-node4", "es-node5", "es-node6", "es-node7", "es-node8"]
cluster.initial_master_nodes: ["es-node1", "es-node2", "es-node3"]
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.keystore.path: /usr/share/elasticsearch/config/certs/es-node1-certificates.p12
xpack.security.transport.ssl.truststore.path: /usr/share/elasticsearch/config/certs/es-node1-certificates.p12


Repeat similar configurations for node2 to node8, replacing node.name and certificate paths accordingly.

For Kibana (kibana/config/kibana.yml), ensure the following configuration:

```bash
server.host: "0.0.0.0"
server.publicBaseUrl: "http://195.26.231.7:5601"
elasticsearch.hosts:
  - "http://es-node1:9200"
  - "http://es-node2:9200"
  - "http://es-node3:9200"
  - "http://es-node4:9200"
  - "http://es-node5:9200"
  - "http://es-node6:9200"
  - "http://es-node7:9200"
  - "http://es-node8:9200"
elasticsearch.username: "elastic"
elasticsearch.password: "qnova@acs123"

### 5. Start the Elasticsearch Cluster and Kibana
Run the following command to start all services:

```bash
docker-compose up --build
This command will build the Docker images and start all Elasticsearch nodes along with Kibana. The generate-certificates.sh script will execute for each Elasticsearch node to generate the necessary SSL certificates.

### 6. Access Kibana
Once all services are up and running, you can access Kibana by navigating to:


http://195.26.231.7:5601

Use the elastic user and the password qnova@acs123 to log in.

### Stopping the Cluster
### Stopping the Cluster
To stop the Elasticsearch cluster and Kibana, run:

```bash
docker-compose down



This command will stop and remove all containers defined in the docker-compose.yml.



```bash
curl -u elastic:qnova@acs123 -X GET "localhost:9201/_cluster/health?pretty"
