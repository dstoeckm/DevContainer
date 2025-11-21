# DevContainer Templates & Init Scripts

This repository contains ready-to-use **Development Container** configurations for Ansible and Terraform, along with a generator script to build standalone initialization scripts.

These scripts allow you to instantly set up a standardized, containerized development environment in any project folder, ensuring consistency across your team.

## Table of Contents
- [Available Environments](#available-environments)
- [Quick Start](#quick-start)
- [How it Works](#how-it-works)
- [Features](#features)
- [Requirements](#requirements)
- [Architecture](#architecture)
- [Modifying the Templates](#modifying-the-templates)
- [Examples](#examples)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

> 💡 **Quick Reference**: See [QUICKREF.md](QUICKREF.md) for common commands and tips.

## Available Environments

| Environment | Description | Includes |
| :--- | :--- | :--- |
| **Ansible** | For Ansible playbook development | Ansible Core, Ansible Lint, PyWinRM, VMware Collections, UBI 9 Base |
| **Terraform** | For Terraform infrastructure code | Terraform, UBI 9 Base, Common Utils |

## Quick Start

### 1. Install the scripts globally

To make the scripts available anywhere on your system, move them to a directory in your PATH, such as `/usr/local/bin`.

```bash
# Make them executable (if not already)
chmod +x init-ansible-devcontainer init-terraform-devcontainer

# Move to /usr/local/bin (requires sudo)
sudo cp init-ansible-devcontainer /usr/local/bin/
sudo cp init-terraform-devcontainer /usr/local/bin/
```

### 2. Initialize a project

Now you can run the initialization command from any project folder:

```bash
# Go to your project
cd ~/my-ansible-project

# Run the init script
init-ansible-devcontainer

# Open in VS Code
code .
# Then click "Reopen in Container" when prompted
```

## How it Works

The `init-*` scripts are standalone shell scripts that:
1.  Create the `.devcontainer` directory structure.
2.  Generate `Dockerfile`, `devcontainer.json`, and `requirements.txt` with pre-configured content.
3.  Set up necessary file permissions for the container user.

## Architecture

This project uses a **template → generator → standalone script** approach:

```
Template Directories          Generator              Output Scripts
┌─────────────────┐          ┌──────────┐          ┌────────────────┐
│ ansible/        │          │          │          │ init-ansible-  │
│ ├─ Dockerfile   ├─────────>│ generate │─────────>│ devcontainer   │
│ ├─ devcontainer │          │ _all_    │          │ (standalone)   │
│ └─ requirements │          │ inits.sh │          │                │
└─────────────────┘          └──────────┘          └────────────────┘
┌─────────────────┐                 │              ┌────────────────┐
│ terraform/      │                 │              │ init-terraform-│
│ ├─ Dockerfile   ├─────────────────┴─────────────>│ devcontainer   │
│ ├─ devcontainer │                                │ (standalone)   │
│ └─ requirements │                                │                │
└─────────────────┘                                └────────────────┘
```

### Why This Approach?

1. **Portability**: Init scripts are self-contained and can be distributed separately
2. **No dependencies**: Users don't need to clone this repo to use the scripts
3. **Version control**: Templates remain editable while scripts can be frozen
4. **Easy distribution**: Copy init scripts to `/usr/local/bin` for global access

## Modifying the Templates

If you want to customize the templates (e.g., add a new VS Code extension or system package):

1.  Modify the source files in the corresponding source directory:
    *   `ansible-devcontainer/` - See [ansible-devcontainer/README.md](ansible-devcontainer/README.md)
    *   `terraform-devcontainer/` - See [terraform-devcontainer/README.md](terraform-devcontainer/README.md)

2.  Run the generator script to update the standalone init scripts:

```bash
./generate_all_inits.sh
```

This will regenerate `init-ansible-devcontainer` and `init-terraform-devcontainer` with your changes.

3.  Test the generated script in a test project before distributing.

## Contributing

Contributions are welcome! Here's how to add a new environment:

1. Create a new directory: `<environment>-devcontainer/`
2. Add three files:
   - `Dockerfile` - Container image definition
   - `devcontainer.json` - VS Code configuration
   - `build/requirements.txt` - Python dependencies (if needed)
3. Run `./generate_all_inits.sh` to create the init script
4. Test thoroughly before submitting a PR

### Coding Standards
- Use clear comments in Dockerfiles
- Follow existing naming conventions
- Keep init scripts POSIX-compliant (avoid bashisms)
- Document any special requirements or setup steps

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built on Red Hat Universal Base Image (UBI)
- Inspired by the VS Code Dev Containers specification
- Uses HashiCorp Terraform and Red Hat Ansible

## Support

- 📖 **Documentation**: Start with this README
- 🐛 **Issues**: [Report bugs or request features](../../issues)
- 💬 **Discussions**: [Ask questions and share ideas](../../discussions)
- 📝 **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)
- 📋 **Changelog**: See [CHANGELOG.md](CHANGELOG.md)

## Requirements

*   **Docker Desktop** (or Rancher Desktop / OrbStack / Podman Desktop)
*   **Visual Studio Code** (version 1.70.0 or higher)
*   **Dev Containers Extension** for VS Code (`ms-vscode-remote.remote-containers`)

### System Requirements
- **macOS**: 10.15 or later (Catalina+)
- **Linux**: Kernel 4.x or higher with Docker support
- **Windows**: Windows 10/11 with WSL2 enabled
- **RAM**: Minimum 4GB available for Docker
- **Disk**: ~2GB per container image

## Troubleshooting

### Common Issues

**Container fails to build:**
- Ensure Docker is running: `docker ps`
- Check disk space: `docker system df`
- Clear Docker cache: `docker system prune -a`

**Permission errors in container:**
- The container uses UID/GID 1000 by default
- To use a different UID: Edit the Dockerfile ARG values before building
- Reset permissions: The `postCreateCommand` in devcontainer.json handles this automatically

**VS Code doesn't detect devcontainer:**
- Ensure `.devcontainer/` is in your project root
- Install/reinstall the Dev Containers extension
- Reload VS Code window (Cmd/Ctrl + Shift + P → "Reload Window")

**SSH keys not working:**
- Ensure `~/.ssh` directory exists on your host
- Check file permissions: `chmod 600 ~/.ssh/id_rsa`
- The container mounts your SSH directory as read-only

### Getting Help
- Check [VS Code Dev Containers documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- Review container logs: `docker logs <container-id>`
- Rebuild without cache: Delete `.devcontainer` folder and re-run init script

## Features

### Ansible DevContainer Includes:
- Ansible Core 2.15+
- Ansible Lint
- Terraform 1.13.5
- Python 3 with development tools
- VMware and General Ansible collections
- SSH client with sshpass support
- Git, vim, and common utilities

### Terraform DevContainer Includes:
- Terraform 1.13.5
- Python 3 with development tools
- Git, vim, and common utilities
- SSH client support

## Customization

### Adding VS Code Extensions
Edit the `devcontainer.json` file in your template directory:
```json
"extensions": [
    "redhat.ansible",
    "ms-python.python",
    "your-new-extension-id"
]
```

### Changing Terraform Version
Modify the `ARG TERRAFORM_VERSION` value in the Dockerfile.

### Adding Python Packages
Add packages to `build/requirements.txt` in your template directory.

### Modifying System Packages
Edit the `dnf install` command in the Dockerfile to add/remove packages.

## Examples

### Example 1: Ansible Project
```bash
# Create new project
mkdir my-ansible-infrastructure
cd my-ansible-infrastructure

# Initialize devcontainer
init-ansible-devcontainer

# Open in VS Code
code .
# Click "Reopen in Container" when prompted

# Inside the container, create your first playbook
cat << EOF > playbook.yml
---
- name: Example playbook
  hosts: localhost
  tasks:
    - name: Print message
      debug:
        msg: "Hello from DevContainer!"
EOF

# Run it
ansible-playbook playbook.yml
```

### Example 2: Terraform Project
```bash
# Create new project
mkdir my-terraform-infrastructure
cd my-terraform-infrastructure

# Initialize devcontainer
init-terraform-devcontainer

# Open in VS Code
code .
# Click "Reopen in Container" when prompted

# Inside the container, initialize Terraform
terraform init
terraform plan
```
