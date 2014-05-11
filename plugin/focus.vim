" Vim plugin for focusing on a single buffer
" Copyright (c) 2012 Merlin Rebrovic
" License: This plugin is released under the MIT License

" Double loading guard
if exists("g:loaded_focusmode") && !exists("g:focusmode_debug")
  finish
endif
let g:loaded_focusmode = 1

" Guard against users using 'compatible'
let s:save_cpo = &cpo
set cpo&vim

function! s:HideChrome()
    " Save previous state and insert empty space as a fill char
    let t:focus_fillchars = &fillchars
    set fillchars+=vert:\ 

    " Remove color from vertical and horizontal bars
    if has("gui_running")
        highlight VertSplit gui=none,bold
        let l:guibg = synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
        if l:guibg != ""
            exec "highlight VertSplit guifg=".l:guibg." guibg=".l:guibg
        endif
    else
        highlight VertSplit cterm=none,bold
        let l:ctermbg = synIDattr(synIDtrans(hlID("Normal")), "bg", "cterm")
        if l:ctermbg != -1 && l:ctermbg != ""
            exec "highlight VertSplit ctermbg=".l:ctermbg." ctermfg=".l:ctermbg
        else
            highlight VertSplit ctermbg=NONE
        endif
    endif
endfunc

function! s:ShowChrome()
    " Restore original fill characters
    exec "set fillchars=".escape(t:focus_fillchars, "|")

    " Restore all tampering with colors
    if exists("g:colors_name")
        exec "colorscheme ".g:colors_name
    else
        exec "colorscheme default"
    endif
    unlet t:focus_fillchars
endfunc

" Get the right text width from a different array of options.
function! s:GetTextWidth()
    let l:text_width = 80 " default value if nothing is set
    if &textwidth
        let l:text_width = &textwidth
    elseif exists("g:focusmode_width")
        let l:text_width = g:focusmode_width
    endif
    return l:text_width
endfunc

" Create a new window on the left side of the current one and
" return the cursor back to it.
function! s:CreateSideWindow(width)
    let l:sr = &splitright
    set nosplitright
    vnew
    let &splitright = l:sr
    setlocal nonumber
    setlocal statusline=%(%)
    setfiletype focusmode
    exe "vert resize ".a:width
    set winfixwidth
    " Jump back to the window on the right
    exe "normal! \<C-w>l"
endfunc

" Center text on the screen
function! s:CenterText()
    let l:max_width = winwidth(0)
    let l:text_width = s:GetTextWidth()
    let l:left_margin = (l:max_width - l:text_width) / 2

    " Don't let the line numbers push the content too much
    if &number
        let l:left_margin = l:left_margin - &numberwidth
    endif
    if l:left_margin > 0
        call s:CreateSideWindow(l:left_margin)
    endif
endfunc

" Save current session to a temporary file
function! s:SaveCurrentSession()
    let l:saved_sessionoptions = &sessionoptions
    exec "set sessionoptions=blank,buffers,folds,help,tabpages,winsize"
    let s:temp_file = tempname().'.vim'
    exec "mksession! ".s:temp_file
    exec "set sessionoptions=".l:saved_sessionoptions
endfunc

" Turn on focus mode
function! s:EnterFocusMode()
    call s:SaveCurrentSession()
    silent! tabonly!
    silent! only!

    call s:HideChrome()
    call s:CenterText()
    augroup focusModeAutoQuit
        autocmd!
        autocmd BufUnload <buffer> qall!
    augroup END
endfunc

" Turn off focus mode
function! s:ExitFocusMode()
    augroup focusModeAutoQuit
        autocmd!
    augroup END
    let l:cursor_position = getpos('.')
    call s:ShowChrome()
    exec "silent! so ".s:temp_file
    exec delete(v:this_session)
    call setpos('.', l:cursor_position)
    let s:focusbuffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(bufname(v:val), "&filetype") != "focusmode" && bufwinnr(v:val)<0')
    if !empty(s:focusbuffers)
        exe 'bw '.join(s:focusbuffers, ' ')
    endif
endfunc

" FocusMode
function! s:ToggleFocusMode(...)
    if !exists("t:focusmode")
        let t:focusmode = 1
        call s:EnterFocusMode()
    else
        call s:ExitFocusMode()
        unlet t:focusmode
    endif
endfunc

if !exists('g:focus_use_default_mapping')
    let g:focus_use_default_mapping = 1
endif

if g:focus_use_default_mapping == 1
    map <Leader>fmt <Plug>FocusModeToggle
elseif g:focus_use_default_mapping == 0
    if maparg("\<Leader>fmt") == '<Plug>FocusModeToggle'
        unmap <Leader>fmt
    endif
else
    echoerr 'g:focus_use_default_mapping set to invalid value'
endif
noremap <unique> <script> <Plug>FocusModeToggle <SID>ToggleFocusMode
noremap <silent> <SID>ToggleFocusMode :call <SID>ToggleFocusMode()<CR>

" Resetting the 'compatible' guard
let &cpo = s:save_cpo
