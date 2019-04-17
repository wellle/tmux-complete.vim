# tmux-complete.vim

Vim plugin for insert mode completion of words in adjacent tmux panes

## Motivation

If you're using Vim in tandem with Tmux you might be familiar with this pesky
situation:

You're happily editing your lovely files in Vim, when you notice you need to
type a word that you can see in a different Tmux pane right next to Vim. This
might be some secret key found in your REPL or the name of a failing test.

Usually the interesting text is too short to warrant switching panes and going
into Tmux' copy mode, so you end typing it out again.

## But fear no longer!

This plugin adds a completion function that puts all words visible in your Tmux
panes right under your fingertips. Just enter insert mode, start typing any
word you see and press `<C-X><C-U>` to the trigger user defined insert mode
completion.

![][example]

It also completes words that are scrolled off, hidden in background tmux
windows and even different tmux sessions. And it even works from gvim or
MacVim!

![][gvim]

[example]: https://raw.githubusercontent.com/wellle/images/master/tmux-complete-example.png
[gvim]: https://raw.githubusercontent.com/wellle/images/master/gvim-complete.png

## Third party integration

Tmux complete is automatically integrated with the following plugins:

- [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim)

    To see tmux completions in your asyncomplete pop-up you will need the async
    plugin as well:

    ```vim
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'wellle/tmux-complete.vim'
    ```

    This integration comes with sensible defaults, but you have some options to
    fine tune it. To start put a block like this into your vimrc:

    ```vim
    let g:tmuxcomplete#asyncomplete_source_options = {
                \ 'name':      'tmuxcomplete',
                \ 'whitelist': ['*'],
                \ 'config': {
                \     'splitmode':      'words',
                \     'filter_prefix':   1,
                \     'show_incomplete': 1,
                \     'sort_candidates': 0,
                \     'scrollback':      0,
                \     'truncate':        0
                \     }
                \ }
    ```

    With `name` you can change how it appears in the pop-up. `whitelist` makes
    it possible to enable this integration only for certain filetypes.

    The `splitmode` can be `words`, `lines`, `ilines`, or `linies,words`.
    `ilines` stands for "inner line", starting with a word character (ignoring
    special chararcters in front) and `ilines,words` completes both lines and
    words.

    If `filter_prefix` is enabled, we will filter candidates based on the
    entered text, this usually gives faster results. For fuzzy matching this
    should be disabled.

    If there you are using many tmux windows with a lot of text in it,
    completion can be slow. That's why we start showing candidates as soon as
    they come in. If you prefer to only see candidates once the list is
    complete, you can disable this by setting `show_incomplete`.

    `sort_candidates` controls whether we sort candidates from tmux externally.
    If it's enabled we can't get early incomplete results. If you have
    `show_incomplete` disabled, this might get slightly quicker results and
    potentially better sorted completions.

    If `scrollback` is positive we will consider that many lines in each tmux
    pane's history for completion.

    If 'truncate' is positive, then only prefixes of the matches up to this
    length are shown in the completion pop-up. Upon selection the full match is
    completed of course.

- [coc](https://github.com/neoclide/coc.nvim)

    You can see tmux completions right in your coc pop-up.

- [ncm2](https://github.com/ncm2/ncm2)

    You can see tmux completions right in your ncm2 pop-up.

- [neocomplete](https://github.com/Shougo/neocomplete.vim)

    You can see tmux completions right in your neocomplete pop-up.

- [neocomplcache](https://github.com/Shougo/neocomplcache.vim)

    You can see tmux completions right in your neocomplcache pop-up.

- [deoplete](https://github.com/Shougo/deoplete.nvim)

    You can see tmux completions right in your deoplete pop-up.

- [unite](https://github.com/Shougo/unite.vim)

    You can use tmux complete as a unite source:

    ```vim
    Unite tmuxcomplete       " opens a menu containing words from adjacent tmux windows
    Unite tmuxcomplete/lines " opens a menu containing words from adjacent tmux windows and lines where they were found
    ```

## Installation

Use your favorite plugin manager.

- [Vim-plug][vim-plug]

    ```vim
    Plug 'wellle/tmux-complete.vim'
    ```

- [NeoBundle][neobundle]

    ```vim
    NeoBundle 'wellle/tmux-complete.vim'
    ```

- [Vundle][vundle]

    ```vim
    Bundle 'wellle/tmux-complete.vim'
    ```

- [Pathogen][pathogen]

    ```sh
    git clone git://github.com/wellle/tmux-complete.vim.git ~/.vim/bundle/tmux-complete.vim
    ```

[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen

## Settings

Use the `#trigger` option to tune the way you interact with
tmux-complete by putting one of these lines into your `.vimrc`:

- By default, tmux-complete sets Vim's `completefunc`, that can be invoked with
  `<C-X><C-U>`.

    ```vim
    let g:tmuxcomplete#trigger = 'completefunc'
    ```

- Alternatively, you can use Vim's `omnifunc`, that can be invoked with
  `<C-X><C-O>`. This setting also integrates with
  [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) so you can see
  Tmux completions when hitting `<C-Space>`.

    ```vim
    let g:tmuxcomplete#trigger = 'omnifunc'
    ```

- If you're using the [neocomplete](https://github.com/Shougo/neocomplete.vim),
  [neocomplcache](https://github.com/Shougo/neocomplcache.vim) or
  [deoplete](https://github.com/Shougo/deoplete.nvim) integration, you probably
  don't need the additional trigger.

    ```vim
    let g:tmuxcomplete#trigger = ''
    ```

The trigger function itself is named `tmuxcomplete#complete` (in case you want
to call it manually).
