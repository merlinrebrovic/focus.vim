" Create a new window on the left side of the current one and
" return the cursor back to it.
function! CreateSideWindow(width)
    vnew
    setlocal nonumber
    exe "vert resize ".a:width
    " jump back (to the right window)
    exe "normal \<C-w>l"
endfunc

""" FocusMode
function! ToggleFocusMode(...)
  if !exists("t:focusmode")
    mksession!
    only
    let t:focusmode = 1

    " save previous state and insert empty space as a fill char
    let t:focus_fillchars = &fillchars
    set fillchars+=vert:\ 
    " remove color from vertical and horizontal bars
    highlight VertSplit ctermbg=NONE guibg=NONE
    highlight StatusLine ctermbg=NONE guibg=NONE
    highlight StatusLineNC ctermbg=NONE guibg=NONE

    let l:max_width = winwidth(0)
    let l:text_width = 80
    let l:left_margin = (l:max_width - l:text_width) / 2
    call CreateSideWindow(l:left_margin)
  else
    " restore original fill characters
    exec "set fillchars=".escape(t:focus_fillchars, "|")
    unlet t:focus_fillchars

    " restore original session
    so Session.vim
    unlet t:focusmode
    exec delete("Session.vim")

    " restore all tampering with colors
    exec "colorscheme ".g:colors_name
  endif
endfunc
