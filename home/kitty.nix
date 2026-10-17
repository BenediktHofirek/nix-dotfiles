{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "CaskaydiaCove Nerd Font Mono";
      size = 16.5;
    };

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # bold_font = "auto";
      # italic_font = "auto";
      # bold_italic_font = "auto";

      window_padding_width = 5;
      hide_window_decorations = true;
      background_opacity = 1.0;
      confirm_os_window_close = 0;
      allow_remote_control = false;
      notify_on_cmd_finish = "invisible 20";
      shell_integration = "enabled";
      allow_hyperlinks = true;
      paste_actions = "quote-urls-at-prompt";
      enable_audio_bell = false;
      # Makes all the difference on light background
      text_composition_strategy = "legacy";

      # Max number of lines in the output
      scrollback_lines = -1;
    };

    keybindings = {
      "ctrl+i" = "send_text all \\x1f[105;5u";
    };

    autoThemeFiles = {
      light = "AtomOneLight";
      dark = "Broadcast";
      noPreference = "AtomOneLight";
    };
  };

  home.packages = with pkgs; [
    kitty-themes
  ];
}
