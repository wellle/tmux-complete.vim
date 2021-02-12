local compe = require'compe'
local Source = {}

function Source.get_metadata(_)
  return {
    priority = 10,
    dup = 0,
    menu = '[Tmux]'
  }
end

function Source.determine(_, context)
  return compe.helper.determine(context)
end

function Source.complete(_, context)
  local items = vim.fn["tmuxcomplete#complete"](0, context.input)

  context.callback({ items = items })
end

return Source
