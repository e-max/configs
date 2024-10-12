return {
  'famiu/bufdelete.nvim',
  keys = {
    {
      '<leader>bd',
      mode = { 'n' },
      function()
        require('bufdelete').bufdelete(0)
      end,
      desc = '[D]elete buffer',
    },
    {
      '<leader>bw',
      mode = { 'n' },
      function()
        require('bufdelete').bufwipeout(0)
      end,
      desc = '[W]ipeout buffer',
    },
  },
}
