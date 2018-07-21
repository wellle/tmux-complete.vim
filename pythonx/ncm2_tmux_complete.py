# -*- coding: utf-8 -*-

import vim
from ncm2 import Ncm2Source, getLogger
from subprocess import check_output


logger = getLogger(__name__)


class Source(Ncm2Source):
    def __init__(self, nvim):
        super(Source, self).__init__(nvim)

    def on_complete(self, ctx):

        command = vim.call('tmuxcomplete#getcommand', '', 'words')
        words = check_output(['sh', '-c', command]
                             ).decode('utf-8').splitlines()
        matches = [{'word': x} for x in words]
        self.complete(ctx, ctx['startccol'], matches)


source = Source(vim)

on_complete = source.on_complete
