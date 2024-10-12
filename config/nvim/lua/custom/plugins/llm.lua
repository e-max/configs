return {
  {
    'huggingface/llm.nvim',
    opts = {
      api_token = nil, -- cf Install paragraph
      model = 'Qwen/CodeQwen1.5-7B', -- the model ID, behavior depends on backend
      backend = 'openai', -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
      url = 'https://language-model-platform.ai-prod.bd-prod-1.kraken.zone/', -- the http url of the backend
      tokens_to_clear = {
        '<|endoftext|>',
        '<fim_prefix>',
        '<fim_middle>',
        '<fim_suffix>',
      }, -- tokens to remove from the model's output
      -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
      request_body = {
        max_tokens = 60,
        temperature = 1.0,
        top_p = 0.95,
        presence_penalty = 1.0,
        stop = { '<|endoftext|>', '<fim_prefix>', '<fim_suffix>', '<fim_middle>' },
      },
      -- set this if the model supports fill in the middle
      fim = {
        enabled = true,
        prefix = '<fim_prefix>',
        middle = '<fim_middle>',
        suffix = '<fim_suffix>',
      },
      debounce_ms = 150,
      accept_keymap = '<C-a>',
      dismiss_keymap = '<S-Tab>',
      tls_skip_verify_insecure = true,
      -- llm-ls configuration, cf llm-ls section
      lsp = {
        host = nil,
        port = nil,
        version = '0.5.3',
      },
      tokenizer = {
        repository = 'Qwen/CodeQwen1.5-7B',
      },
      context_window = 2048, -- max number of tokens for the context window
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = '*', -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
      disable_url_path_completion = false, -- cf Backend
    },
  },
}
