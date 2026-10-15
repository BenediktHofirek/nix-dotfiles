#NIX_CONFIG='experimental-features = nix-command flakes' nix shell nixpkgs#git nixpkgs#home-manager nixpkgs#just -c bash -c '[ -d ~/dotfiles ] || git clone https://github.com/YOUR_USER/dotfiles ~/dotfiles; cd ~/dotfiles && home-manager switch --flake .#laptop'

run: build open

open:
    nix run --impure github:nix-community/nixGL#nixGLDefault -- ./result/bin/run-virtualMachine-vm

build: reset
    nix build --log-format internal-json -v .#nixosConfigurations.virtualMachine.config.system.build.vm |& nom --json 

reset:
    rm -f ./*.qcow2

# --- Real machine (laptop) ---

# system only
system:
    sudo nixos-rebuild switch --flake .#laptop

# home-manager only (fast dotfile iteration)
home:
    home-manager switch --flake .#laptop

iso:
    nix build .#nixosConfigurations.iso-installer.config.system.build.isoImage

# both
switch: system home
