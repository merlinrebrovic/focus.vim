Focus.vim
=========

Focus mode is a state where you are focusing on one thing and one thing only.
This is what this plugin does for you.

No matter the initial layout of your Vim session, once you activate focus mode
all buffers except for the current one will be closed. Also, the only remaining
buffer will be centered in your Vim window so you can have it in the center of
your viewing area. When you exit focus mode all your previously opened buffers
will be restored for you along with their corresponding windows.

Screenshots
============

![Animated gif of the extension](http://merlin.rebrovic.net/media/external/focus.gif)

Requirements
============

No requirements (except Vim of course). This is a stand-alone plugin with no
outside dependencies.

Installation
============

1. [Vundle]
   Add the following line to your `.vimrc`:

        Bundle "merlinrebrovic/focus.vim"

   After this just source your `.vimrc` and run `:BundleInstall` inside Vim.

2. [Pathogen]
   Copy or clone this repository to `.vim/bundle` folder
   (`vimfiles\bundle` on Windows).

3. Manually  
   Copy `focus.vim` script to `.vim/plugin` folder (`vimfiles\plugin` on
   Windows).

Configuration
=============

By default the plugin maps the `<leader>fmt` combination for toggling the focus
mode. You can set your own combination by adding the following lines in your `.vimrc`:

    let g:focus_use_default_mapping = 0
    nmap key_combination <Plug>FocusModeToggle

Be sure to use `nmap` instead of `noremap` as we are counting on the result
being remapped here. This is to prevent the plugin leaking stuff into the
global namespace as much as possible.

You can set the desired width of the focused buffer while in focus mode. There
are several ways to do this in order of priority:

1. If the `textwidth` Vim option is set, it will be used.

2. If it's not set, you can set `g:focusmode_width` variable at any time before
   entering the focus mode and Focus.vim will use that. If used regularly,
   put it in your `.vimrc` file. For example:

        let g:focusmode_width = 72

3. If the previous values were not set, the default value (80) is used.

License
=======

Copyright (c) Merlin Rebrović. Distributed under the [MIT license].

Created by Merlin Rebrović and [Zoran Meliš][landofz]

Contributors:

* [ict]
* [joshtch]

[Vundle]: https://github.com/gmarik/vundle
[Pathogen]: https://github.com/tpope/vim-pathogen
[MIT license]: http://opensource.org/licenses/MIT
[landofz]: https://github.com/landofz
[ict]: https://github.com/ict
[joshtch]: https://github.com/joshtch
