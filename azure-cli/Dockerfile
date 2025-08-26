# Use the Debian image as the base
FROM debian:bookworm-slim

# Set versions for tools to install: https://releases.hashicorp.com/terraform/
ENV TERRAFORM_VERSION=1.11.3
##How to check the latest version of kubectl: https://dl.k8s.io/release/stable.txt
ENV KUBECTL_VERSION=v1.32.3
# Azure CLI deb package version (must match repo, e.g. 2.64.0-1~bookworm)
ENV AZURE_CLI_VERSION=2.64.0-1~bookworm

# Base dependencies
RUN apt-get update && apt-get install -y \
    gpg \
    curl \
    unzip \
    git \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Terraform
RUN set -eux; \
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
    mv terraform /usr/local/bin/; \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip; 

# Kubectl
RUN set -eux; \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
    chmod +x kubectl; \
    mv kubectl /usr/local/bin/

# Azure CLI
RUN set -eux; \
    mkdir -p /etc/apt/keyrings; \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft-archive-keyring.gpg > /dev/null; \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list; \
    apt-get update; \
    apt-get install -y azure-cli=${AZURE_CLI_VERSION}; \
    rm -rf /var/lib/apt/lists/*

# Confirm the tools were installed (single layer)
RUN terraform --version && \
    kubectl version --client && \
    git --version && \
    az version

# Keep container interactive
CMD ["/bin/bash"]
