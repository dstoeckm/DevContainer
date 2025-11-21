# Quick Reference Guide

Quick commands and tips for using DevContainer templates.

## Installation

```bash
# Make scripts executable
chmod +x init-ansible-devcontainer init-terraform-devcontainer

# Install globally (optional)
sudo cp init-ansible-devcontainer /usr/local/bin/
sudo cp init-terraform-devcontainer /usr/local/bin/
```

## Usage

```bash
# Ansible project
cd my-ansible-project
init-ansible-devcontainer
code .

# Terraform project
cd my-terraform-project
init-terraform-devcontainer
code .
```

## Common Commands

### Inside the Container

**Ansible:**
```bash
# Check Ansible version
ansible --version

# Run playbook
ansible-playbook playbook.yml

# Lint playbook
ansible-lint playbook.yml

# Check VMware collection
ansible-galaxy collection list | grep vmware

# Test connectivity
ansible localhost -m ping
```

**Terraform:**
```bash
# Check version
terraform version

# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Format code
terraform fmt

# Validate configuration
terraform validate
```

### Docker Commands

```bash
# List running containers
docker ps

# Check container logs
docker logs <container-id>

# Remove all containers
docker rm -f $(docker ps -aq)

# Remove all images
docker rmi -f $(docker images -q)

# Clean up everything
docker system prune -a
```

## File Locations

### Host System
```
~/my-project/
├── .devcontainer/
│   ├── Dockerfile
│   ├── devcontainer.json
│   └── build/
│       └── requirements.txt
└── your-project-files
```

### Inside Container
```
/home/ansible/workspace/     # Your project (Ansible)
/home/terraform/workspace/   # Your project (Terraform)
/root/.ssh/                  # SSH keys (mounted)
/root/.aws/                  # AWS config (mounted)
```

## Troubleshooting Quick Fixes

```bash
# Permission errors - rebuild container
# In VS Code: Cmd/Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# Container won't start - check Docker
docker ps
docker system df

# Out of space - clean Docker
docker system prune -a --volumes

# Extension not loading - reload window
# In VS Code: Cmd/Ctrl+Shift+P → "Developer: Reload Window"

# Reset everything
rm -rf .devcontainer
init-ansible-devcontainer  # or init-terraform-devcontainer
```

## Customization Cheat Sheet

### Add VS Code Extension
Edit `.devcontainer/devcontainer.json`:
```json
"extensions": [
    "existing.extension",
    "your.new-extension"
]
```

### Change Terraform Version
Edit `.devcontainer/Dockerfile`:
```dockerfile
ARG TERRAFORM_VERSION=1.14.0  # Change version
```

### Add Python Package
Edit `.devcontainer/build/requirements.txt`:
```
existing-package
your-new-package>=1.0.0
```

### Add System Package
Edit `.devcontainer/Dockerfile` in the dnf install section:
```dockerfile
RUN dnf install -y \
    existing-packages \
    your-new-package \
    && dnf clean all
```

## Environment Variables

### Set in devcontainer.json
```json
"remoteEnv": {
    "MY_VAR": "value",
    "PATH": "${containerEnv:PATH}:/custom/path"
}
```

### Set in Dockerfile
```dockerfile
ENV MY_VAR=value
ENV PATH="${PATH}:/custom/path"
```

## Tips & Tricks

1. **Faster rebuilds**: Comment out `RUN dnf update -y` in Dockerfile during development
2. **Keep containers small**: Clean up in the same RUN layer
3. **Debug builds**: Add `RUN echo "Debug point"` in Dockerfile
4. **Test without IDE**: Use `docker build -t test .` in `.devcontainer/` directory
5. **Share configs**: Commit `.devcontainer/` to git for team consistency

## Keyboard Shortcuts (VS Code)

- `Cmd/Ctrl + Shift + P`: Command palette
- `Cmd/Ctrl + Shift + ` `: Open terminal
- `Cmd/Ctrl + K, Cmd/Ctrl + O`: Open folder
- `F1`: Command palette (alternative)

## Useful Links

- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Documentation](https://docs.docker.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Red Hat UBI](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image)
