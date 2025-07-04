return {
  'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require"octo".setup({
      default_remote = {"upstream", "origin"}; -- order to try remotes
      default_merge_method = "commit"; -- commit|rebase|squash|merge
      ssh_aliases = {},               -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
      reaction_viewer_hint_icon = "";     -- marker for user reactions
      user_icon = " ";                        -- user icon
      timeline_marker = "";                   -- timeline marker
      timeline_indent = "2";                     -- timeline indentation
      right_bubble_delimiter = "";            -- bubble delimiter
      left_bubble_delimiter = "";             -- bubble delimiter
      github_hostname = "";                     -- GitHub Enterprise host
      snippet_context_lines = 4;                -- number or lines around commented lines
      gh_env = {},                              -- extra environment variables to pass on to GitHub CLI can be a table or function returning a table
      timeout = 5000,                           -- timeout for requests between the remote server
      ui = {
        use_signcolumn = true,                  -- show "modified" marks on the sign column
      },
      issues = {
        order_by = {                            -- criteria to sort results of `Octo issue list`
          field = "CREATED_AT",                 -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC"                    -- either ASC or DESC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        }
      },
      pull_requests = {
        order_by = {                            -- criteria to sort the results of `Octo pr list`
          field = "CREATED_AT",                 -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC"                    -- either ASC or DESC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        },
        always_select_remote_on_create = false -- always give prompt to select base remote repo when creating PRs
      },
      file_panel = {
        size = 10,                              -- changed files panel rows
        use_icons = true                        -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
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
