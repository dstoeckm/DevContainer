# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Known Issues
- Terraform container uses "ansible" as username instead of "terraform"
- Dockerfile comments reference "UBI 9" but actual base image is UBI 10.1
- SSH/AWS credential mounts target `/root/` instead of user home directory
- Terraform requirements.txt includes unnecessary Ansible packages

## [1.1.0] - Current

### Added
- Comprehensive README with troubleshooting section
- Individual README files for ansible-devcontainer and terraform-devcontainer
- Detailed examples for both Ansible and Terraform workflows
- Architecture documentation explaining the template → generator → script flow
- Contributing guidelines
- System requirements documentation
- Customization guide

### Changed
- Improved main README structure with table of contents
- Enhanced documentation for all template directories

## [1.0.0] - Initial Release

### Added
- Ansible DevContainer template with:
  - Ansible Core 2.15+
  - Ansible Lint
  - Terraform 1.13.5
  - VMware and General collections
  - Python development environment
  - Red Hat UBI 10.1 base image
  
- Terraform DevContainer template with:
  - Terraform 1.13.5
  - Python development environment
  - Red Hat UBI 10.1 base image

- Generator script (`generate_all_inits.sh`) to create standalone init scripts
- Init scripts for both environments:
  - `init-ansible-devcontainer`
  - `init-terraform-devcontainer`

### Features
- Automatic UID/GID mapping for file permissions
- SSH and AWS credentials mounting
- VS Code extensions pre-configured
- Passwordless sudo for container users
- Automatic workspace permission fixing

[Unreleased]: https://github.com/yourusername/DevContainer/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/yourusername/DevContainer/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/yourusername/DevContainer/releases/tag/v1.0.0
