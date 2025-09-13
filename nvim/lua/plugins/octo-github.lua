return {
  'pwntester/octo.nvim',
  dependencies = {  -- Use 'dependencies' not 'requires' for lazy.nvim
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require("octo").setup({
      default_remote = {"upstream", "origin"}, -- use comma, not semicolon
      default_merge_method = "commit",
      ssh_aliases = {},
      reaction_viewer_hint_icon = "",
      user_icon = " ",
      timeline_marker = "",
      timeline_indent = 2,  -- NUMBER, not string!
      right_bubble_delimiter = "",
      left_bubble_delimiter = "",
      github_hostname = "",
      snippet_context_lines = 4,
      gh_env = {},
      timeout = 5000,
      ui = {
        use_signcolumn = true,
      },
      issues = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC"
        }
      },
      pull_requests = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC"
        },
        always_select_remote_on_create = false
      },
      file_panel = {
        size = 10,
        use_icons = true
      },
    })
  end,
  keys = {
    {'<leader>o', '', desc = '+octo'},
    {'<leader>oi', '<cmd>Octo issue list<cr>', desc = 'List issues'},
    {'<leader>op', '<cmd>Octo pr list<cr>', desc = 'List PRs'},
    {'<leader>or', '<cmd>Octo repo view<cr>', desc = 'View repo'},
    {'<leader>oic', '<cmd>Octo issue create<cr>', desc = 'Create issue'},
    {'<leader>opc', '<cmd>Octo pr create<cr>', desc = 'Create PR'},
  },
}
