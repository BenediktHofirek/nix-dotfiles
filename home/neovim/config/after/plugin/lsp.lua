-- disable pylsp annoying linting messages

-- Store the original handler first
local original_progress_handler = vim.lsp.handlers["$/progress"]

-- Define the new handler
vim.lsp.handlers["$/progress"] = function(_, msg, info)
  local client = vim.lsp.get_client_by_id(info.client_id)

  -- If the client exists and is "pylsp", we return (skip processing)
  if client and (client.name == "pylsp" or client.name == "jdtls") then
    return
  end

  -- Otherwise, call the original handler to process the message
  -- We pass the same arguments it was originally designed to take
  if original_progress_handler then
    original_progress_handler(nil, msg, info)
  end
end
