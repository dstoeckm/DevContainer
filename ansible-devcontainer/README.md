# Ansible DevContainer Template

This directory contains the source template files for the Ansible development container.

## Contents

- **Dockerfile**: Container image definition with Ansible, Terraform, Python tools
- **devcontainer.json**: VS Code Dev Container configuration
- **build/requirements.txt**: Python package dependencies

## What's Included

### Tools & Versions
- **Ansible Core**: 2.15+
- **Ansible Lint**: Latest
- **Terraform**: 1.13.5
- **Python**: 3.x (from UBI 10)
- **Base Image**: Red Hat Universal Base Image (UBI) 10.1

### Python Packages
- ansible-core
- ansible-lint
- jmespath
- pywinrm (for Windows management)
- requests
- PyVmomi (for VMware vSphere API)

### Ansible Collections
- community.vmware
- community.general

### System Packages
- git, wget, unzip, vim
- openssh-clients, sshpass
- python3-pip, python3-devel
- acl, sudo

## Container Configuration

### User Setup
- **Username**: ansible
- **UID/GID**: 1000 (matches most local users)
- **Sudo**: Passwordless sudo enabled

### Mounted Directories
- **Workspace**: Your project folder → `/home/ansible/workspace`
- **SSH Keys**: `~/.ssh` → `/root/.ssh` (read-only)
- **AWS Config**: `~/.aws` → `/root/.aws` (read-only)

### VS Code Extensions
- Red Hat Ansible (`redhat.ansible`)
- Python (`ms-python.python`)
- HashiCorp Terraform (`hashicorp.terraform`)

## Modifying This Template

After making changes to any files in this directory:

1. Test your changes locally by copying to a test project
2. Regenerate the init script:
   ```bash
   cd ..
   ./generate_all_inits.sh
   ```
3. The `init-ansible-devcontainer` script will be updated with your changes

## Notes

- The container uses UBI (Red Hat's Universal Base Image) for enterprise compatibility
- EPEL repository is enabled for additional packages (sshpass, etc.)
- File permissions are automatically fixed on container start via `postCreateCommand`
