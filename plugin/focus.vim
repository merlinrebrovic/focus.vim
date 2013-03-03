" Vim plugin for focusing on a single buffer
" Copyright (c) 2012 Merlin Rebrovic
" License: This plugin is released under the MIT License

" Double loading guard
if exists("g:loaded_focusmode")
  finish
endif
let g:loaded_focusmode = 1

" Guard against users using 'compatible'
let s:save_cpo = &cpo
set cpo&vim

" Create a new window on the left side of the current one and
" return the cursor back to it.
function s:CreateSideWindow(width)
    vnew
    setlocal nonumber
    exe "vert resize ".a:width
    " jump back (to the right window)
    exe "normal \<C-w>l"
endfunc

function s:HideChrome()
    " save previous state and insert empty space as a fill char
    let t:focus_fillchars = &fillchars
    set fillchars+=vert:\ 

    " remove color from vertical and horizontal bars
    if has("gui_running")
        let l:guibg = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        if l:guibg != ""
            exec "highlight VertSplit guifg=".l:guibg." guibg=".l:guibg
        endif
    else
        " TODO: terminal mode coloring doesn't cover all situations
        let l:ctermbg = synIDattr(synIDtrans(hlID("Normal")), "bg", "cterm")
        if l:ctermbg != -1
            exec "highlight VertSplit ctermbg=".l:ctermbg." ctermfg=".l:ctermbg
        else
            highlight VertSplit ctermbg=NONE
        endif
    endif
endfunc

function s:ShowChrome()
    " restore original fill characters
    exec "set fillchars=".escape(t:focus_fillchars, "|")

    " restore all tampering with colors
    if exists("g:colors_name")
        exec "colorscheme ".g:colors_name
    else
        exec "colorscheme default"
    endif
    unlet t:focus_fillchars
endfunc

""" FocusMode
function s:ToggleFocusMode(...)
    if !exists("t:focusmode")
        mksession!
        only!
        let t:focusmode = 1

        call s:HideChrome()

        let l:max_width = winwidth(0)
        let l:text_width = 80
        let l:left_margin = (l:max_width - l:text_width) / 2
        call s:CreateSideWindow(l:left_margin)
    else
        call s:ShowChrome()
        " restore original session
        silent! so Session.vim
        exec delete("Session.vim")
        unlet t:focusmode
    endif
endfunc

" Default mapping if no mapping exists
if !hasmapto('<Plug>FocusmodeToggle')
  map <unique> <Leader>fmt <Plug>FocusmodeToggle
endif
noremap <unique> <script> <Plug>FocusmodeToggle <SID>ToggleFocusMode
noremap <SID>ToggleFocusMode :call <SID>ToggleFocusMode()<CR>

" Resetting the 'compatible' guard
let &cpo = s:save_cpo
