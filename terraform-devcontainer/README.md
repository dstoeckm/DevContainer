# Terraform DevContainer Template

This directory contains the source template files for the Terraform development container.

## Contents

- **Dockerfile**: Container image definition with Terraform and Python tools
- **devcontainer.json**: VS Code Dev Container configuration
- **build/requirements.txt**: Python package dependencies

## What's Included

### Tools & Versions
- **Terraform**: 1.13.5
- **Python**: 3.x (from UBI 10)
- **Base Image**: Red Hat Universal Base Image (UBI) 10.1

### Python Packages
- jmespath
- pywinrm
- requests

### System Packages
- git, wget, unzip, vim
- openssh-clients, sshpass
- python3-pip, python3-devel
- acl, sudo

## Container Configuration

### User Setup
- **Username**: ansible (Note: Should be 'terraform' - see Known Issues)
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

## Known Issues

1. **Username inconsistency**: Container uses "ansible" username instead of "terraform"
   - Fix: Change `ARG USERNAME=ansible` to `ARG USERNAME=terraform` in Dockerfile
   - Update all `/home/ansible` references to `/home/terraform`

2. **Base image comment**: Dockerfile mentions "UBI 9" but uses UBI 10.1
   - Fix: Update comment to reflect actual base image version

3. **Unnecessary dependencies**: requirements.txt includes Ansible packages
   - Fix: Remove ansible-core and ansible-lint from requirements.txt

## Modifying This Template

After making changes to any files in this directory:

1. Test your changes locally by copying to a test project
2. Regenerate the init script:
   ```bash
   cd ..
   ./generate_all_inits.sh
   ```
3. The `init-terraform-devcontainer` script will be updated with your changes

## Notes

- The container uses UBI (Red Hat's Universal Base Image) for enterprise compatibility
- EPEL repository is enabled for additional packages
- File permissions are automatically fixed on container start via `postCreateCommand`
- This template shares the base structure with the Ansible template but focuses on Terraform workflows
