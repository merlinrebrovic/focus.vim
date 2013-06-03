focusmode.vim
=============
Focus mode is a state where you are focusing on one thing and one thing only.
This is what this plugin does for you.

No matter the initial layout of your Vim session, once you activate focus mode
all buffers except for the current one will be closed. Also, the only remaining
buffer will be centered in your Vim window so you can have it in the center of
your viewing area. When you exit focus mode all your previously opened buffers
will be restored for you along with their corresponding windows.

Requirements
============
No requirements (except Vim :)). This is a stand-alone plugin with no outside
dependencies.

Installation
============
The preferred way is to install the [vundle][] plugin manager and then add the
following line to your `.vimrc`:

    Bundle "merlinrebrovic/focus.vim"

After this just source your `.vimrc` and run `:BundleInstall` inside Vim.

Alternatively you can install using [pathogen][] or go the manual route.

Configuration
=============

By default the plugin maps the `<leader>fmt` combination for toggling the focus
mode. You can set your own combination by adding a line in your `.vimrc`:

    nmap key_combination <Plug>FocusModeToggle

Be sure to use `nmap` instead of `noremap` as we are counting on the result
being remapped here. This is to prevent the plugin leaking stuff into the
global namespace as much as possible.

You can set the desired width of the focused buffer while in focus mode. There
are several ways to do this in order of priority:

- Set the desired width in `g:focusmode_width` at any time before entering the
  focus mode.
- If the `textwidth` Vim option is set it will be used.
- If the previous values were not set the default value (80) is used.

License
=======

Copyright (c) Merlin Rebrovic. Distributed under the [MIT license][].


[vundle]: https://github.com/gmarik/vundle
[pathogen]: https://github.com/tpope/vim-pathogen
[MIT license]: http://opensource.org/licenses/MIT
