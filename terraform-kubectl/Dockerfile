# Use the Debian image as the base
FROM debian:bullseye-slim

# Maintainer and author label
LABEL maintainer="youremail@example.com"

# Set versions for tools to install
ENV TERRAFORM_VERSION=1.0.5
ENV KUBECTL_VERSION=v1.22.0

# Install necessary utilities and tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    --no-install-recommends && \
    # Install Terraform
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    # Cleanup
    apt-get remove --purge -y curl unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Confirm the tools were installed
RUN terraform --version
RUN kubectl version --client
RUN git --version

# Command to keep the container running
CMD ["/bin/bash"]