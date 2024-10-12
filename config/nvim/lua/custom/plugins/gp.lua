return {
  dir = '~/work/gp.nvim/',
  --'robitx/gp.nvim',
  config = function()
    local conf = {
      log_sensitive = true,
      providers = {
        first_mate = {
          endpoint = 'https://language-model-platform.ai-prod.bd-prod-1.kraken.zone/v1/chat/completions',
          secret = '',
        },
      },
      agents = {
        {
          name = 'FirstMate',
          provider = 'first_mate',
          chat = true,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = 'meta-llama/Meta-Llama-3.1-70B-Instruct', temperature = 0.01, top_p = 0.9, max_tokens = 4096 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'Act as a world class Senior Software Engineer. Your job is to help with all software engineering tasks. You follow best practices in all programming languages, and you always provide working code. In response to questions/requests - Output code without descriptions, unless it is important and/or complex. Make it easy to copy and paste. Consider other possibilities to achieve the result, do not be limited by the prompt.',
        },
      },
    }
    require('gp').setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
