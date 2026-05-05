# dotfiles

Personal dotfiles and machine setup scripts for macOS.

## Repository Structure

```
dotfiles/
├── bash/               # Bash configuration files
│   ├── .bashrc         # Main bash config (sources other files)
│   ├── .bash_aliases   # Shell aliases
│   ├── .bash_exports   # Exported environment variables
│   ├── .bash_inputrc   # Readline/input settings
│   ├── .bash_path      # PATH configuration
│   └── .bash_prompt    # Custom prompt
├── bin/                # Shell utility scripts
│   ├── .bash_library   # Shared library sourced by scripts
│   └── bash/           # Function modules
│       ├── file_system.sh
│       ├── misc.sh
│       ├── network.sh
│       └── os.sh
├── config/             # App and tool configuration
│   ├── Brewfile        # Homebrew bundle (formulae, casks, VS Code extensions)
│   ├── copilot/        # GitHub Copilot instructions and skills
│   ├── git/            # Git config
│   ├── tailspin/       # Tailspin log-highlighting theme
│   └── ...             # Other app configs (iTerm2, ripgrep, etc.)
├── setup/              # Machine setup and reset scripts
│   ├── bash/           # Bash setup and reset
│   ├── zsh/            # Zsh setup and reset
│   ├── constants.sh    # Shared constants
│   ├── utils.sh        # Shared utilities
│   └── setup-scripts/  # Individual install scripts
│       ├── applications/   # App installers (VS Code, IntelliJ, PyCharm)
│       ├── cli-packages/   # CLI tool installers
│       └── os/             # macOS system defaults
└── zsh/                # Zsh configuration files
    ├── .zshrc          # Main zsh config
    ├── .exports.zsh    # Exported environment variables
    ├── .macos.zsh      # macOS-specific settings
    ├── .options.zsh    # Zsh options
    ├── .path.zsh       # PATH configuration
    └── .plugins.zsh    # Plugin configuration
```

## Usage

Clone the repository (with submodules):

    git clone --recurse-submodules https://github.com/ByronAmbright/dotfiles.git
    cd dotfiles

### Bash setup

    ./setup/bash/setup.sh

To reset:

    ./setup/bash/reset.sh && exec bash

### Zsh setup

    ./setup/zsh/setup.sh

To reset:

    ./setup/zsh/reset.sh && exec zsh

### Homebrew packages

Install all packages, casks, and VS Code extensions defined in the Brewfile:

    brew bundle --file=config/Brewfile

## Sources

Sources for this repo were taken and modified from the following:

* https://github.com/theeldestelder/dotfiles
* https://github.com/bewuethr/dotfiles
* https://github.com/niketpathak/devpreferences
* https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/
* https://github.com/zacanger/dotfiles/
* https://github.com/sharfah/dotfiles
* https://github.com/sapegin/dotfiles
* https://github.com/mgedmin/dotfiles
* https://github.com/stevehanson/dotfiles
* https://github.com/tbk42/An-Azure-Armory/
* https://github.com/tomMoulard/configLoader/
* https://github.com/github/awesome-copilot