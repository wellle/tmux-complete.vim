from .base import Base

import deoplete.util

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'tmux-complete'
        self.kind = 'keyword'
        self.mark = '[tmux]'
        self.rank = 4

    def gather_candidates(self, context):
        return [{ 'word': x } for x in
                self.vim.call('tmuxcomplete#gather_candidates')]
