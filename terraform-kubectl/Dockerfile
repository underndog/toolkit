# Use the Debian image as the base
FROM debian:bullseye-slim

# Maintainer and author label
LABEL maintainer="Nimtechnology"

# Set versions for tools to install
ENV TERRAFORM_VERSION=1.0.5
ENV KUBECTL_VERSION=v1.22.0

# Install necessary utilities and tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    sudo \
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

# Install helm
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
RUN apt-get install apt-transport-https --yes
RUN echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update -y
RUN apt-get install helm -y

# Install eksctl
ENV EKSCTL_VERSION=v0.164.0
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ENV ARCH=amd64
RUN PLATFORM=$(uname -s)_$ARCH
RUN curl -sLO "https://github.com/eksctl-io/eksctl/releases/download/$EKSCTL_VERSION/eksctl_$PLATFORM.tar.gz"
# (Optional) Verify checksum
RUN curl -sL "https://github.com/eksctl-io/eksctl/releases/download/$EKSCTL_VERSION/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
RUN tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
RUN sudo mv /tmp/eksctl /usr/local/bin

# Command to keep the container running
CMD ["/bin/bash"]