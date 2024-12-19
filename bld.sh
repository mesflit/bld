#!/bin/bash

# Software version
VERSION="19.12.24"
GITHUB_URL="https://github.com/mesflit/bld"
# Build directories
BUILD_DIR="$HOME/.local/share/bld"
PKGBUILD_DIR="$BUILD_DIR/files"
CONFIG_FILE="$BUILD_DIR/config"


# Display version and GitHub URL
show_version_and_github() {
    echo "bld version: $VERSION"
    echo "GitHub: $GITHUB_URL"
    echo "Commands: add | build | remove | list | clone"
    echo "Config file: $CONFIG_FILE"
}

# Main function
if [ $# -eq 0 ]; then
    show_version_and_github
    exit 0
fi

# Existing functions (unchanged from your original script)


# Create directories
create_directory() {
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
    fi
    if [ ! -d "$PKGBUILD_DIR" ]; then
        mkdir -p "$PKGBUILD_DIR"
    fi
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "ShowVersion=false\nShowInstalled=false" > "$CONFIG_FILE" # Default config
    fi
}

# Get the package name from the PKGBUILD file
get_pkgname() {
    local pkgbuild_file="$1"
    local pkgname=$(grep "^pkgname=" "$pkgbuild_file" | head -n 1 | cut -d'=' -f2 | tr -d '"')
    echo "$pkgname"
}

# Get the package version from the PKGBUILD file
get_pkgver() {
    local pkgbuild_file="$1"
    local pkgver=$(grep "^pkgver=" "$pkgbuild_file" | head -n 1 | cut -d'=' -f2 | tr -d '"')
    echo "$pkgver"
}

# Read a setting from the config file
read_config() {
    local key="$1"
    local value=$(grep "^$key=" "$CONFIG_FILE" | cut -d'=' -f2)
    echo "$value"
}

# Add a PKGBUILD file
add_pkgbuild() {
    local pkgbuild_file="$1"
    if [ ! -f "$pkgbuild_file" ]; then
        echo "PKGBUILD file not found: $pkgbuild_file"
        return 1
    fi

    # Get the package name
    local pkgname=$(get_pkgname "$pkgbuild_file")
    if [ -z "$pkgname" ]; then
        echo "Package name not found in the PKGBUILD file."
        return 1
    fi

    # Create the target directory for the application
    local target_dir="$PKGBUILD_DIR/$pkgname"
    mkdir -p "$target_dir"

    # Move the PKGBUILD file
    cp "$pkgbuild_file" "$target_dir/PKGBUILD"
    echo "PKGBUILD file added to $target_dir."
}

# Build a PKGBUILD file
build_pkg() {
    local pkgname="$1"
    local target_dir="$PKGBUILD_DIR/$pkgname"
    if [ ! -d "$target_dir" ]; then
        echo "PKGBUILD file not found for $pkgname."
        return 1
    fi

    echo "Building $pkgname..."
    cd "$target_dir" && makepkg -si -f
    echo "$pkgname successfully built."
}

# Check if a package is installed on the system
is_installed() {
    local pkgname="$1"
    if pacman -Qi "$pkgname" &>/dev/null; then
        echo "Installed"
    else
        echo "Not Installed"
    fi
}

# List existing PKGBUILD files
list_pkgbuilds() {
    local pkgs=$(ls "$PKGBUILD_DIR")
    local show_version=$(read_config "ShowVersion")
    local show_installed=$(read_config "ShowInstalled")

    if [ -z "$pkgs" ]; then
        echo "No PKGBUILD files added yet."
    else
        echo "Current PKGBUILD files:"
        for pkg in $pkgs; do
            local pkg_info=" - $pkg"

            if [ "$show_version" == "true" ]; then
                local pkgver=$(get_pkgver "$PKGBUILD_DIR/$pkg/PKGBUILD")
                pkg_info+=" (Version: $pkgver)"
            fi

            if [ "$show_installed" == "true" ]; then
                local installed_status=$(is_installed "$pkg")
                pkg_info+=" [${installed_status}]"
            fi

            echo "$pkg_info"
        done
    fi
}

# Remove a PKGBUILD file
remove_pkgbuild() {
    local pkgname="$1"
    local target_dir="$PKGBUILD_DIR/$pkgname"
    if [ ! -d "$target_dir" ]; then
        echo "PKGBUILD not found for $pkgname."
        return 1
    fi

    # Remove the folder
    rm -rf "$target_dir"
    echo "PKGBUILD for $pkgname successfully removed."
}

# Clone a Git repository
clone_repo() {
    local repo_url="$1"
    if [ -z "$repo_url" ]; then
        echo "Git repository URL not specified."
        return 1
    fi

    echo "Cloning Git repository: $repo_url"
    git clone "$repo_url" "$PKGBUILD_DIR/$(basename "$repo_url" .git)"
    echo "Cloning complete."
}

# Main function
create_directory

case "$1" in
    add)
        if [ -z "$2" ]; then
            echo "PKGBUILD file path not specified."
            exit 1
        fi
        add_pkgbuild "$2"
        ;;
    build)
        if [ -z "$2" ]; then
            echo "Package name for building not specified."
            exit 1
        fi
        build_pkg "$2"
        ;;
    remove)
        if [ -z "$2" ]; then
            echo "Package name to remove not specified."
            exit 1
        fi
        remove_pkgbuild "$2"
        ;;
    list)
        list_pkgbuilds
        ;;
    clone)
        if [ -z "$2" ]; then
            echo "Git repository URL to clone not specified."
            exit 1
        fi
        clone_repo "$2"
        ;;
    *)
        echo "Usage: $0 {add|build|remove|list|clone}"
        exit 1
        ;;
esac
