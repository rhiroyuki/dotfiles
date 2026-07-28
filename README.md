# dotfiles

Default settings for personal use.

## Installation

For any distro
```
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/rhiroyuki/dotfiles/master/install.sh)"
```

`install.sh` is the single entry point. On Arch (auto-detected) it also runs
the Arch-specific steps; pass `--arch` to force them, and `--nvidia` on a box
with the NVIDIA proprietary driver:

```
$ bash install.sh --arch --nvidia
```

Arch packages are installed separately, before the above:

```
$ bash arch_package_install.sh
```

See `AGENTS.md` for what each tool's config is and how installation works.
