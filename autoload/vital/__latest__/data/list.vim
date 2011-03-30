" Utilities for list.

let s:save_cpo = &cpo
set cpo&vim

" Remove duplicates from a list.
" FIXME: string only.
function! s:uniq(list)  " {{{
  let i = 0
  let seen = {}
  while i < len(a:list)
    if has_key(seen, '_' . a:list[i])
      call remove(a:list, i)
    else
      " Avoid empty string for key of dictionary.
      let seen['_' . a:list[i]] = 1
      let i += 1
    endif
  endwhile
  return a:list
endfunction  " }}}

" Concatenate a list of lists.
" XXX: Should we verify the input?
function! s:concat(list)  " {{{
  let list = []
  for i in a:list
    let list += i
  endfor
  return list
endfunction  " }}}

" Flatten a list.
function! s:flatten(list)  " {{{
  let list = []
  for i in a:list
    if type(i) == type([])
      let list += s:flatten(i)
    else
      call add(list, i)
    endif
    unlet! i
  endfor
  return list
endfunction  " }}}

" Sort a list with expression.
" a:a and a:b can be used in {expr}.
function! s:sort(list, expr)  " {{{2
  if type(a:expr) == type(function('function'))
    return sort(a:list, a:expr)
  endif
  let s:expr = a:expr
  return sort(a:list, 's:_compare')
endfunction

function! s:_compare(a, b)  " {{{2
  return eval(s:expr)
endfunction


let &cpo = s:save_cpo