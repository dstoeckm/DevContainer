#!/bin/bash

# Loop through all directories ending in -devcontainer
for dir in *-devcontainer; do
    if [ -d "$dir" ]; then
        # Extract the name (e.g., ansible from ansible-devcontainer)
        name=$(echo "$dir" | sed 's/-devcontainer//')
        # Capitalize first letter for display
        display_name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
        
        script_name="init-$dir"
        echo "Generating $script_name from $dir..."

        # Start writing the script
        cat << OUTER_EOF > "$script_name"
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\${BLUE}Initializing $display_name Dev Container Environment...\${NC}"

# 1. Create Directories
echo -e "Creating directories..."
mkdir -p .devcontainer
mkdir -p .devcontainer/build

# 2. Generate Dockerfile
# We use 'EOF' (quoted) to prevent variable expansion during generation
echo -e "Generating .devcontainer/Dockerfile..."
cat << 'EOF' > .devcontainer/Dockerfile
OUTER_EOF

        # Append Dockerfile content
        if [ -f "$dir/Dockerfile" ]; then
            cat "$dir/Dockerfile" >> "$script_name"
            echo "" >> "$script_name"
        else
            echo "Warning: $dir/Dockerfile not found"
        fi

        # Close Dockerfile heredoc and start devcontainer.json
        cat << OUTER_EOF >> "$script_name"
EOF

# 3. Generate devcontainer.json
echo -e "Generating .devcontainer/devcontainer.json..."
cat << 'EOF' > .devcontainer/devcontainer.json
OUTER_EOF

        # Append devcontainer.json content
        if [ -f "$dir/devcontainer.json" ]; then
            cat "$dir/devcontainer.json" >> "$script_name"
            echo "" >> "$script_name"
        else
             echo "Warning: $dir/devcontainer.json not found"
        fi

        # Close devcontainer.json heredoc and start requirements.txt
        cat << OUTER_EOF >> "$script_name"
EOF

# 4. Generate requirements.txt
echo -e "Generating .devcontainer/build/requirements.txt..."
cat << 'EOF' > .devcontainer/build/requirements.txt
OUTER_EOF

        # Append requirements.txt content
        if [ -f "$dir/build/requirements.txt" ]; then
            cat "$dir/build/requirements.txt" >> "$script_name"
            echo "" >> "$script_name"
        fi

        # Close requirements.txt heredoc and finish script
        cat << OUTER_EOF >> "$script_name"
EOF

echo -e "\${GREEN}Success! $display_name Dev Container files created.\${NC}"
echo -e "To use: Open VS Code and select 'Reopen in Container'."
OUTER_EOF

        chmod +x "$script_name"
        echo "Created $script_name"
                
 #       echo "Installing $script_name to /usr/local/bin/..."
 #       sudo cp "$script_name" "/usr/local/bin/$script_name"
    fi
done
