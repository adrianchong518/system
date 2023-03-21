local M = {}

M.setup = function()
  local status_ok, fidget = pcall(require, "fidget")
  if not status_ok then
    return
  end

  fidget.setup {
    text = {
      spinner = {
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
      },
      done = "", -- character shown when all tasks are complete
      commenced = " ", -- message shown when task starts
      completed = " ",
    },
    timer = {
      spinner_rate = 100, -- frame rate of spinner animation, in ms
      fidget_decay = 500, -- how long to keep around empty fidget, in ms
      task_decay = 300, -- how long to keep around completed task, in ms
    },
    sources = {
      ["null-ls"] = { ignore = true },
    },
  }
end

return M
