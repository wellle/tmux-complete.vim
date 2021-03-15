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
  vim.fn["tmuxcomplete#async#gather_candidates"](function (items)
    context.callback({ items = items })
  end)
end

return Source
