starship init fish | source
# ==========================================================
# === ENVIRONMENT VARIABLES & PATHS ===
# ==========================================================

# Native Fish way to safely append to PATH (no duplicates)
fish_add_path "$HOME/.local/bin"

# ==========================================================
# === ALIASES (Pacman & Paru) ===
# ==========================================================

# Arch (Pacman)
alias pu='sudo pacman -Syu'              # Update System
alias psi='sudo pacman -S'               # Install Package
alias pr='sudo pacman -Rns'             # Remove Package + Deps + Config
alias pc='sudo pacman -Sc'              # Clean cache
alias po='sudo pacman -Rns (pacman -Qdtq)' # Pacman command substitution uses () instead of $()
alias pd='sudo pacman -Rdd'

# AUR (Paru)
alias yu='paru -Syu'                     # Update System + AUR
alias ys='paru -S --skipreview'          # Install AUR pkg (skip review)
alias yss='paru -Ss'                     # Search AUR
alias yr='paru -Rns'                     # Remove AUR package

# Convenience 
alias please='sudo'
alias fs='fastfetch'

function rss
    stremio-service >/dev/null 2>&1 &
end
