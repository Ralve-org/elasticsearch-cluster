#!/bin/bash

set -e

# Capture the node name passed as an argument
node_name=$1

# Paths for the certificates
CERTS_DIR="/usr/share/elasticsearch/config/certs"
CA_CERT="$CERTS_DIR/elastic-stack-ca.p12"
NODE_CERT="$CERTS_DIR/${node_name}-certificates.p12"
CA_PASSWORD=""  # Set to empty if no password, or specify the password if required.

# Debugging - Print the node name and certificate paths
echo "Starting certificate generation for node: $node_name"
echo "CA Certificate Path: $CA_CERT"
echo "Node Certificate Path: $NODE_CERT"

# Only es-node1 should generate the CA certificate
if [ "$node_name" == "es-node1" ]; then
  if [ ! -f "$CA_CERT" ]; then
    echo "Generating CA certificate on es-node1..."
    /usr/share/elasticsearch/bin/elasticsearch-certutil ca --silent --pass "$CA_PASSWORD" --out "$CA_CERT"
  else
    echo "CA certificate already exists, skipping generation."
  fi
fi

# Ensure all nodes wait for the CA certificate before generating their node certificates
if [ ! -f "$CA_CERT" ]; then
  echo "Waiting for CA certificate to be available..."
  while [ ! -f "$CA_CERT" ]; do
    sleep 2
  done
  echo "CA certificate is now available."
fi

# Get the node's IP address
node_ip=$(getent hosts "$node_name" | awk '{ print $1 }')

# All nodes generate their own node certificate using the shared CA
if [ ! -f "$NODE_CERT" ]; then
  echo "Generating node certificate for $node_name..."
  /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca "$CA_CERT" --ca-pass "$CA_PASSWORD" --name "$node_name" --dns "$node_name" --ip "$node_ip" --pass "" --silent --out "$NODE_CERT"
else
  echo "Node certificate for $node_name already exists, skipping generation."
fi

echo "Certificates generated successfully for $node_name!"

# Continue with Elasticsearch startup
exec /usr/local/bin/docker-entrypoint.sh
