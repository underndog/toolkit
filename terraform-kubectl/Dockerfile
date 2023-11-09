# Use the Debian image as the base
FROM debian:bookworm-slim

# Maintainer and author label
LABEL maintainer="Nimtechnology"

# Set versions for tools to install
ENV TERRAFORM_VERSION=1.6.3
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
    mv kubectl /usr/local/bin/

# Install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# Install eksctl
ENV EKSCTL_VERSION=v0.164.0
ENV ARCH=amd64
RUN PLATFORM=$(uname -s)_$ARCH && \
    curl -sLO "https://github.com/eksctl-io/eksctl/releases/download/$EKSCTL_VERSION/eksctl_$PLATFORM.tar.gz" && \
    curl -sL "https://github.com/eksctl-io/eksctl/releases/download/$EKSCTL_VERSION/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check && \
    tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz && \
    mv /tmp/eksctl /usr/local/bin

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Cleanup
RUN apt-get remove --purge -y curl unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Confirm the tools were installed
RUN terraform --version
RUN kubectl version --client
RUN git --version
RUN helm version
RUN aws --version
RUN eksctl version

# Command to keep the container running
CMD ["/bin/bash"]