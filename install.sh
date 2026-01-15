#!/bin/bash
# Symlink dotfiles to home directory

DOTFILES="$HOME/git/dotfiles"

files=(.zshrc .vimrc .gitconfig .gitignore_global)

for file in "${files[@]}"; do
    target="$HOME/$file"
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Backing up existing $file to $file.bak"
        mv "$target" "$target.bak"
    fi
    ln -sf "$DOTFILES/$file" "$target"
    echo "Linked $file"
done

# VS Code settings
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
if [[ -d "$VSCODE_DIR" ]]; then
    target="$VSCODE_DIR/settings.json"
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Backing up existing VS Code settings.json"
        mv "$target" "$target.bak"
    fi
    ln -sf "$DOTFILES/vscode/settings.json" "$target"
    echo "Linked VS Code settings.json"
fi

# Claude Code settings
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"
target="$CLAUDE_DIR/CLAUDE.md"
if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Backing up existing CLAUDE.md"
    mv "$target" "$target.bak"
fi
ln -sf "$DOTFILES/claude/CLAUDE.md" "$target"
echo "Linked CLAUDE.md"

echo "Done!"
