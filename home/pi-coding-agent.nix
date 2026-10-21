{
  programs.pi-coding-agent = {
    enable = true;
  };

  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    defaultProvider = "ollama";
    defaultModel = "qwen2.5:7b";
    # You can configure themes, history settings, etc., here
  };

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers = {
      ollama = {
        baseUrl = "http://localhost:11434/v1";
        api = "openai-completions";
        apiKey = "ollama";
        models = [
          { id = "qwen2.5:7b"; }
        ];
      };
    };
  };
}
