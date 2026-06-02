# asdf-b2

An [asdf](https://asdf-vm.com/) plugin for the
[Backblaze B2 command-line tool](https://github.com/Backblaze/B2_Command_Line_Tool).

Installs the official pre-built `b2` binaries from upstream GitHub
releases. No Python toolchain required on the target host — the
binaries are self-contained PyInstaller bundles.

## Install

```sh
asdf plugin add b2 https://github.com/badeyeye1/asdf-b2.git
```

## Usage

```sh
# List installable versions
asdf list all b2

# Install the latest stable
asdf install b2 latest

# Pin a project to a specific version
asdf set b2 4.7.0           # asdf >= 0.16
# or, on older asdf:
asdf local b2 4.7.0

# Run it
b2 version
```

## Dependencies

- `curl` — downloads the binary
- `git`  — lists versions via `git ls-remote`

## Supported platforms

| OS    | Architectures           | Asset name                  |
|-------|-------------------------|-----------------------------|
| Linux | `x86_64`                | `b2-linux`                  |
| Linux | `aarch64` / `arm64`     | `b2-linux-aarch64`          |

### macOS is not supported

Backblaze stopped publishing pre-built macOS binaries starting with
v4.0.0 (mid-2024). The plugin will fail loudly with a guidance
message if you try to install on Darwin. Install via Homebrew or pip
on macOS instead:

```sh
brew install b2-tools
# or
pip install b2
```

If Backblaze resumes publishing macOS binaries, this plugin will be
updated to support them.

### Windows is not supported

Upstream publishes a `b2-windows.exe` but the plugin is bash-only and
does not handle PE binary installs. Windows users should run via WSL
(where this plugin works as a Linux plugin) or use a native installer.

## License

MIT — see [LICENSE](./LICENSE).
