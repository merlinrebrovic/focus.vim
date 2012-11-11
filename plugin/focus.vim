""" FocusMode
function! ToggleFocusMode(...)
  " if (&foldcolumn != 12)
  if !exists("w:focusmode")
    mksession!
    only
    let w:focusmode = 1
    " set laststatus=0
    " set noruler
    " set nonu

    " styling
    " hi FoldColumn ctermbg=none
    " hi LineNr ctermfg=0 ctermbg=none
    " hi NonText ctermfg=0
    " hi VertSplit ctermfg=0 ctermbg=none
    " set fillchars+=vert:\ 

    let l:max_width = winwidth(0)
    let l:text_width = 80
    " -10 is for left size vertical line, numbers and foldcolumn
    let l:left_margin = (l:max_width - l:text_width) / 2
    vnew
    exe "vert resize ".l:left_margin
    " set foldcolumn=0
    exe "normal \<C-w>l"
  else
    so Session.vim
    unlet w:focusmode
    exec delete("Session.vim")
  endif
endfunc
