-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require("nvim-surround").setup()
require("which-key").setup()
require("auto-hlsearch").setup()
require("crates").setup()
-- require("fidget").setup()
require("Comment").setup()
-- require("inc_rename").setup()

require("mini.icons").setup()

require("remote-nvim").setup({
  client_callback = function(port, workspace_config)
    local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s")
        :format(
          port,
          ("'Remote: %s'"):format(workspace_config.host)
        )
    if vim.env.TERM == "xterm-kitty" then
      cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
    end
    vim.fn.jobstart(cmd, {
      detach = true,
      on_exit = function(job_id, exit_code, event_type)
        print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
      end,
    })
  end,
})
