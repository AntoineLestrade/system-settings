let deoplete#enable_at_startup = 1

" <TAB>: Completion.
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#manual_complete()
function! s:check_back_space() abort " {{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction " }}}

let g:deoplete#enable_camel_case = 1
