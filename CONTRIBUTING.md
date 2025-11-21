# Contributing to DevContainer Templates

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Adding a New Environment](#adding-a-new-environment)
- [Testing Changes](#testing-changes)
- [Submitting Changes](#submitting-changes)
- [Coding Standards](#coding-standards)

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/DevContainer.git
   cd DevContainer
   ```
3. Make the generator script executable:
   ```bash
   chmod +x generate_all_inits.sh
   ```

## Development Workflow

The project uses a template-based architecture:

1. **Edit templates** in `<environment>-devcontainer/` directories
2. **Generate scripts** by running `./generate_all_inits.sh`
3. **Test** the generated `init-*` scripts in real projects
4. **Commit** both template changes and generated scripts

### What to Edit

**Template Files** (always edit these):
- `<environment>-devcontainer/Dockerfile`
- `<environment>-devcontainer/devcontainer.json`
- `<environment>-devcontainer/build/requirements.txt`

**Generated Files** (regenerated automatically):
- `init-ansible-devcontainer`
- `init-terraform-devcontainer`

**Don't edit generated files manually** - they will be overwritten!

## Adding a New Environment

To add a new development environment (e.g., Go, Node.js, Python):

### 1. Create the Template Directory

```bash
mkdir -p myenv-devcontainer/build
```

### 2. Create the Dockerfile

`myenv-devcontainer/Dockerfile`:
```dockerfile
ARG USERNAME=myenv
ARG USER_UID=1000
ARG USER_GID=1000

FROM your-base-image:tag

ARG USERNAME
ARG USER_UID
ARG USER_GID

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    your-packages \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

# Setup workspace
RUN mkdir -p /home/$USERNAME/workspace && \
    chown -R $USER_UID:$USER_GID /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME/workspace

CMD ["/bin/bash"]
```

### 3. Create the devcontainer.json

`myenv-devcontainer/devcontainer.json`:
```json
{
    "name": "My Environment Development",
    "build": {
        "dockerfile": "Dockerfile",
        "context": "."
    },
    "remoteUser": "myenv",
    "workspaceMount": "source=${localWorkspaceFolder},target=/home/myenv/workspace,type=bind",
    "workspaceFolder": "/home/myenv/workspace",
    "updateRemoteUserUID": true,
    "customizations": {
        "vscode": {
            "settings": {
                "terminal.integrated.defaultProfile.linux": "bash"
            },
            "extensions": [
                "your-extension-ids"
            ]
        }
    },
    "postCreateCommand": "sudo chown -R myenv:myenv /home/myenv/workspace"
}
```

### 4. Create requirements.txt (if needed)

`myenv-devcontainer/build/requirements.txt`:
```
# Python packages if your environment uses Python
package1>=1.0.0
package2
```

### 5. Generate the Init Script

```bash
./generate_all_inits.sh
```

This creates `init-myenv-devcontainer`.

### 6. Add Documentation

Create `myenv-devcontainer/README.md`:
```markdown
# My Environment DevContainer Template

## Contents
- Description of what's included
- Configuration details
- Known issues
- Modification instructions
```

## Testing Changes

### Test Locally

1. Create a test project directory:
   ```bash
   mkdir ~/test-project
   cd ~/test-project
   ```

2. Run your generated init script:
   ```bash
   ../DevContainer/init-myenv-devcontainer
   ```

3. Open in VS Code:
   ```bash
   code .
   ```

4. Click "Reopen in Container"

5. Verify:
   - Container builds successfully
   - All tools are available
   - File permissions work correctly
   - VS Code extensions load
   - Terminal works as expected

### Test Different Scenarios

- Empty project directory
- Existing project with files
- Different operating systems (macOS, Linux, Windows/WSL)
- Different Docker setups (Docker Desktop, Rancher, etc.)

## Submitting Changes

### Before Submitting

1. **Test thoroughly** - Run the init script in multiple test projects
2. **Regenerate scripts** - Always run `./generate_all_inits.sh`
3. **Update documentation** - Update READMEs if adding features
4. **Check file sizes** - Ensure generated scripts aren't excessively large
5. **Lint Dockerfiles** - Use `hadolint` if available

### Pull Request Process

1. Create a feature branch:
   ```bash
   git checkout -b feature/my-improvement
   ```

2. Commit your changes:
   ```bash
   git add .
   git commit -m "Add: Description of changes"
   ```

3. Push to your fork:
   ```bash
   git push origin feature/my-improvement
   ```

4. Open a Pull Request with:
   - Clear description of changes
   - Why the change is needed
   - Testing you performed
   - Screenshots (if UI-related)

### Commit Message Format

Use clear, descriptive commit messages:

```
Type: Short description (50 chars max)

Longer explanation if needed. Wrap at 72 characters.

- Bullet points for multiple changes
- Reference issues: Fixes #123
```

Types:
- `Add:` - New feature or functionality
- `Fix:` - Bug fix
- `Update:` - Update existing functionality
- `Docs:` - Documentation changes
- `Refactor:` - Code restructuring
- `Test:` - Adding or updating tests

## Coding Standards

### Dockerfile Guidelines

1. **Comments**: Explain non-obvious steps
2. **Layer optimization**: Combine related RUN commands
3. **Clean up**: Remove temporary files in the same layer
4. **Pin versions**: Specify exact versions for critical tools
5. **Security**: Don't include secrets or credentials

Example:
```dockerfile
# Good: Combined, commented, cleaned up
RUN dnf install -y \
    package1 \
    package2 \
    && dnf clean all

# Bad: Multiple layers, no cleanup
RUN dnf install -y package1
RUN dnf install -y package2
```

### devcontainer.json Guidelines

1. **Comments**: Use JSON comments to explain settings
2. **Consistent naming**: Follow existing naming patterns
3. **Extensions**: Only include essential extensions
4. **Settings**: Document why non-standard settings are needed

### Shell Script Guidelines

1. **POSIX compliance**: Avoid bash-specific features in init scripts
2. **Error handling**: Check for errors and provide helpful messages
3. **Colors**: Use consistent color scheme for output
4. **Quoting**: Always quote variables: `"$VAR"`

### Documentation Guidelines

1. **Clear headings**: Use descriptive section titles
2. **Examples**: Include working code examples
3. **Commands**: Show full command syntax with output
4. **Links**: Reference official documentation where relevant

## Questions or Issues?

- Open an issue for bugs or feature requests
- Start a discussion for questions
- Check existing issues before creating new ones

Thank you for contributing! 🎉
