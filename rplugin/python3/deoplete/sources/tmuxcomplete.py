from .base import Base

import deoplete.util
from subprocess import check_output

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'tmux-complete'
        self.kind = 'keyword'
        self.mark = '[tmux]'
        self.rank = 4

    def gather_candidates(self, context):
        command = self.vim.call('tmuxcomplete#getcommand', '', 'words')
        words = check_output(['sh', '-c', command]).decode('utf-8').splitlines()
        return [{ 'word': x } for x in words]
