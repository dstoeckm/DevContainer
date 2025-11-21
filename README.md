# DevContainer Templates & Init Scripts

This repository contains ready-to-use **Development Container** configurations for Ansible and Terraform, along with a generator script to build standalone initialization scripts.

These scripts allow you to instantly set up a standardized, containerized development environment in any project folder, ensuring consistency across your team.

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

## Modifying the Templates

If you want to customize the templates (e.g., add a new VS Code extension or system package):

1.  Modify the source files in the corresponding source directory:
    *   `ansible-devcontainer/`
    *   `terraform-devcontainer/`
2.  Run the generator script to update the standalone init scripts:

```bash
./generate_all_inits.sh
```

This will regenerate `init-ansible-devcontainer` and `init-terraform-devcontainer` with your changes.

## Requirements

*   **Docker Desktop** (or Rancher Desktop / OrbStack / Podman Desktop)
*   **Visual Studio Code**
*   **Dev Containers Extension** for VS Code
