run: build open

open:
    nix run --impure github:nix-community/nixGL#nixGLDefault -- ./result/bin/run-virtualMachine-vm

build:
    nix build .#nixosConfigurations.virtualMachine.config.system.build.vm

# wipe the VM's persistent disk (do this when users/passwords/etc. change)
reset:
    rm -f vm.qcow2

# --- Real machine (laptop) ---

# system only
system:
    sudo nixos-rebuild switch --flake .#laptop

# home-manager only (fast dotfile iteration)
home:
    home-manager switch --flake .#laptop

# both
switch: system home

deploy root boot:
    nix build .#nixosConfigurations.laptop.config.system.build.toplevel --out-link result-system
    nix build nixpkgs#nixos-install-tools --out-link result-install-tools
    sudo mkdir -p /mnt
    sudo mount {{root}} /mnt
    sudo mkdir -p /mnt/boot
    sudo mount {{boot}} /mnt/boot
    sudo env "PATH=$PATH" ./result-install-tools/bin/nixos-install \
        --root /mnt \
        --system "$(readlink -f result-system)" \
        --no-root-passwd
    sudo umount -R /mnt

