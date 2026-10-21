{
  virtualisation.podman = {
    enable = true;

    # Optional: create a `docker` alias so docker CLI commands work
    dockerCompat = true;

    # Required for containers under podman-compose to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };
}
