return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    -- Set sessionoptions to include 'localoptions' for proper filetype and highlighting
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

    -- Neo-tree can end up open from two different paths at startup:
    -- hijack_netrw_behavior converting a directory buffer (e.g. `nvim .`),
    -- or auto-session explicitly calling `Neotree show`. These race: when
    -- nvim starts with a path argument, hijack_netrw fires slightly after
    -- VimEnter, so checking "is a tree already open" here can miss it and
    -- open a second, independent tree instance. Skip entirely whenever an
    -- argument was passed — hijack_netrw alone is authoritative for that
    -- case. Only bare `nvim` (our `ide` launcher, argc() == 0) needs this
    -- hook to open the sidebar itself.
    vim.api.nvim_create_user_command("EnsureNeoTree", function()
      if vim.fn.argc() > 0 then
        return
      end
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "neo-tree" then
          return
        end
      end
      vim.cmd("Neotree show")
    end, {})

    require("auto-session").setup({
      log_level = "info",
      -- Only restore the session that matches the cwd; restoring the "last"
      -- session from another project breaks the per-project `ide` flow
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_save_enabled = true,
      auto_restore_enabled = true,
      -- Neo-tree windows don't serialize properly in sessions: close before
      -- saving, re-open the sidebar after restore (or when no session exists)
      pre_save_cmds = { "Neotree close" },
      post_restore_cmds = { "EnsureNeoTree" },
      no_restore_cmds = { "EnsureNeoTree" },
    })
  end,
}
