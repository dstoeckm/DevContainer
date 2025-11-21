# ARGs - Define variables for the build
ARG USERNAME=ansible
ARG USER_UID=1000
ARG USER_GID=1000
ARG TERRAFORM_VERSION=1.13.5

# OPTIMIZATION: Switched to UBI 9 (Universal Base Image)
# Lighter (~200MB) than toolbox, fully compatible with RHEL 9
FROM registry.access.redhat.com/ubi10:10.1

# Re-declare ARGs to bring them into scope after FROM
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG TERRAFORM_VERSION

USER root

# 1. Install System Dependencies
# We install 'epel-release' first because packages like 'sshpass' are not in standard RHEL repos
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf update -y && \
    dnf install -y \
    git \
    wget \
    unzip \
    vim \
    python3-pip \
    python3-devel \
    openssh-clients \
    sshpass \
    acl \
    sudo \
    shadow-utils && \
    dnf clean all

# 2. Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# 3. Create Ansible User with Explicit UID/GID
# We force UID 1000 to match the local user for permission compatibility
RUN groupadd --gid $USER_GID $USERNAME || echo "Group exists" && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# 4. Create Directories with correct ownership
RUN mkdir -p /home/$USERNAME/.ansible && \
    mkdir -p /home/$USERNAME/workspace && \
    chown -R $USER_UID:$USER_GID /home/$USERNAME

# 5. Install Python Dependencies
# Requires a 'build/requirements.txt' file in your project context
COPY build/requirements.txt /tmp/requirements.txt

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt \
    ansible-core \
    ansible-lint

# 6. Switch to User
USER $USERNAME

# 7. Set Working Directory
# Matches the 'workspaceMount' in devcontainer.json
WORKDIR /home/$USERNAME/workspace

# 8. Install Ansible VMware Collection
RUN ansible-galaxy collection install community.vmware && \
    ansible-galaxy collection install community.general

CMD ["/bin/bash"]

LABEL com.redhat.component="ansible-dev-tools-container" \
      name="ansible-dev-tools-ubi9" \
      version="1.1.0" \
      maintainer="DStoeckm"
