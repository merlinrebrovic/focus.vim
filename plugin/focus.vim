" Create a new window on the left side of the current one and
" return the cursor back to it.
function! CreateSideWindow(width)
    vnew
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

    let t:focus_fillchars = &fillchars
    set fillchars+=vert:\ 

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
  endif
endfunc
