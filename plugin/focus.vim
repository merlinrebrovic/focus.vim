" Create a new window on the left side of the current one and
" return the cursor back to it.
function! CreateSideWindow(width)
    vnew
    setlocal nonumber
    exe "vert resize ".a:width
    " jump back (to the right window)
    exe "normal \<C-w>l"
endfunc

function! HideChrome()
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

function! ShowChrome()
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
function! ToggleFocusMode(...)
  if !exists("t:focusmode")
    mksession!
    only
    let t:focusmode = 1

    call HideChrome()

    let l:max_width = winwidth(0)
    let l:text_width = 80
    let l:left_margin = (l:max_width - l:text_width) / 2
    call CreateSideWindow(l:left_margin)
  else
    call ShowChrome()
    " restore original session
    so Session.vim
    unlet t:focusmode
    exec delete("Session.vim")
  endif
endfunc
