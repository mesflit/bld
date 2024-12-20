# bld - A Simple PKGBUILD Manager

`bld` is a lightweight Bash script designed to simplify the management of PKGBUILD files for Arch-based Linux distributions. It allows you to add, build, remove, list, and clone PKGBUILD files with ease.

## Features

- Add and manage PKGBUILD files.
- Build packages directly from PKGBUILD files.
- Check installed packages' status.
- Clone Git repositories containing PKGBUILD files.
- Lightweight and easy to use.

## Installation

### From PKGBUILD

1. Clone the repository:
   ```bash
   git clone https://github.com/mesflit/bld.git
   ```

2. Navigate to the project directory:
   ```bash
   cd bld
   ```

3. Build and install the package using `makepkg`:
   ```bash
   makepkg -si
   ```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mesflit/bld.git
   ```

2. Navigate to the project directory:
   ```bash
   cd bld
   ```

3. Make the script executable:
   ```bash
   chmod +x bld.sh
   ```

4. Optionally, move the script to a directory in your PATH:
   ```bash
   sudo mv bld.sh /usr/local/bin/bld
   ```

## Usage

Run `bld` without any arguments to see the version and available commands:
```bash
bld
```

### Commands

- **Add a PKGBUILD file**:
  ```bash
  bld add /path/to/PKGBUILD
  ```

- **Build a package**:
  ```bash
  bld build <package-name>
  ```

- **Remove a PKGBUILD file**:
  ```bash
  bld remove <package-name>
  ```

- **List all added PKGBUILD files**:
  ```bash
  bld list
  ```

- **Clone a Git repository containing a PKGBUILD file**:
  ```bash
  bld clone <repository-url>
  ```

### Configuration
The configuration file is located at:
```bash
~/.local/share/bld/config
```

Default settings:
```
ShowVersion=false
ShowInstalled=false
```

- **ShowVersion**: Display package versions in the list.
- **ShowInstalled**: Display whether a package is installed.

## Examples

1. **Adding a PKGBUILD file**:
   ```bash
   bld add ~/downloads/example/PKGBUILD
   ```

2. **Building a package**:
   ```bash
   bld build example-package
   ```

3. **Removing a PKGBUILD file**:
   ```bash
   bld remove example-package
   ```

4. **Listing added PKGBUILD files with versions and installed status**:
   Update the configuration file:
   ```bash
   echo -e "ShowVersion=true\nShowInstalled=true" > ~/.local/share/bld/config
   ```
   Run:
   ```bash
   bld list
   ```

## Requirements
- An Arch-based Linux distribution.
- `makepkg` and `pacman` utilities.
- `git` for cloning repositories.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/mesflit/bld).

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

For more information, visit the [GitHub page](https://github.com/mesflit/bld).
