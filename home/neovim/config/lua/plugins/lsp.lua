return {
  -- LSP Core Plugin
  'neovim/nvim-lspconfig',

  dependencies = {
    -- LSP Management
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP UI Feedback
    {
      'j-hui/fidget.nvim',
      opts = {
        progress = {
          display = { done_icon = '✓' },
          ignore = {
            function(msg)
              return msg.lsp_client.name == "pylsp" and string.find(msg.title, "lint:")
            end,
          },
        },
        notification = {
          filter = vim.log.levels.WARN,
          window = { winblend = 0 },
        },
      },
    },
  },

  config = function()
    -----------------------------------------------------------
    -- 1. Capabilities
    -----------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -----------------------------------------------------------
    -- 2. Server Configurations
    -----------------------------------------------------------
    local servers = {
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      emmet_language_server = {},

      -- Go
      gopls = {},
      goimports = {},
      templ = {},

      -- PHP
      phpactor = {},
      phpstan = {},
      pint = {},
      duster = {},
      tlint = {},

      -- Kotlin
      kotlin_lsp = {},

      -- Ruby
      solargraph = {},
      rubocop = {},

      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = { callSnippet = 'Replace' },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      -- Docker
      dockerls = {},
      docker_compose_language_service = {},

      -- Python
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              rope_autoimport = { enabled = true },
              pylsp_mypy = { enabled = true },
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      },
      mypy = {},
      ruff = {
        commands = {
          RuffAutofix = {
            function()
              vim.lsp.buf.execute_command {
                command = 'ruff.applyAutofix',
                arguments = { { uri = vim.uri_from_bufnr(0) } },
              }
            end,
            description = 'Ruff: Fix all auto-fixable problems',
          },
          RuffOrganizeImports = {
            function()
              vim.lsp.buf.execute_command {
                command = 'ruff.applyOrganizeImports',
                arguments = { { uri = vim.uri_from_bufnr(0) } },
              }
            end,
            description = 'Ruff: Format imports',
          },
        },
      },

      -- Rust
      rust_analyzer = {
        ['rust-analyzer'] = {
          cargo = { features = 'all' },
          checkOnSave = true,
          check = { command = 'clippy' },
        },
      },

      -- Terraform
      terraformls = {},
      tflint = {},
      tfsec = {},

      -- Web / Misc
      tailwindcss = {},
      jsonls = {},
      sqlls = {},
      yamlls = {},
      bashls = {},
      graphql = {},

      -- C# / .NET
      csharpier = {},
      netcoredbg = {},
      omnisharp = {
        organize_imports_on_format = true,
        enable_editorconfig_support = true,
        enable_roslyn_analyzers = true,
        enable_import_completion = true,
        sdk_include_prereleases = false,
        handlers = {
          ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        ),
      },
    }

    -----------------------------------------------------------
    -- 3. Mason Setup
    -----------------------------------------------------------
    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Lua formatter
      'java-debug-adapter',
      'java-test',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -----------------------------------------------------------
    -- 4. Diagnostics Setup
    -----------------------------------------------------------
    vim.lsp.handlers['textDocument/publishDiagnostics'] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = { spacing = 4, severity = vim.diagnostic.severity.WARN },
        update_in_insert = false,
        signs = { severity = vim.diagnostic.severity.WARN },
      })


    -----------------------------------------------------------
    -- 5. VueJS special setup: https://www.reddit.com/r/neovim/comments/1mbk9sk/cannot_install_vue_ls_after_version_upgrade_to_v3/
    -----------------------------------------------------------
    local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'

    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }

    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    }

    local vue_ls_config = {
      on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
          local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
          if #clients == 0 then
            vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
            command = 'typescript.tsserverRequest',
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
            local response = r and r.body
            -- TODO: handle error or response nil here, e.g. logging
            -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
            local response_data = { { id, response } }

            ---@diagnostic disable-next-line: param-type-mismatch
            client:notify('tsserver/response', response_data)
          end)
        end
      end,
    }
    -- nvim 0.11 or above
    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.enable { 'vtsls', 'vue_ls' }

    vim.lsp.config('nixd', {
      cmd = { 'nixd' },
      settings = {
        nixd = {
          nixpkgs = {
            expr = 'import <nixpkgs> { }',
          },
          formatting = {
            command = { 'nixfmt' },
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake "github:BenediktHofirek/nix-dotfiles").nixosConfigurations.laptop.options',
            },
            home_manager = {
              expr = '(builtins.getFlake "github:BenediktHofirek/nix-dotfiles").nixosConfigurations.laptop.options',
            },
          },
        },
      },
    })
    vim.lsp.enable('nixd')

  end,
}
