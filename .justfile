run: build
 nix run --impure github:nix-community/nixGL#nixGLDefault -- ./result/bin/run-laptop-vm

build:
 nix build .#nixosConfigurations.laptop.config.system.build.vm

