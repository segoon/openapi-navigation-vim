" ============================================================================
" File:        openapi-navigation
" Maintainer:  Vasily Kulikov <segoon at yandex-team dot ru>
" License:     TODO
" ============================================================================

if exists('g:loaded_openapi_navigation')
  finish
endif
let g:loaded_openapi_navigation = 1


function TrimSymm(path, delimiter) abort
  if a:path[0] == a:delimiter
    if a:path[len(a:path)-1] == a:delimiter
      return a:path[1:len(a:path)-2]
    endif
  endif
  return a:path
endfunction

function ParseLine(line) abort
  let parsed = split(a:line, ':')
  if len(parsed) != 2
    return {}
  endif

  let ref = trim(parsed[0])
  let path = trim(parsed[1])
  let path = TrimSymm(path, '''')
  let path = TrimSymm(path, '"')

  let parts = split(path, '#', 1)
  if len(parts) != 2
    return {}
  endif

  let fname = parts[0]
  let local_reference = parts[1]
  let lr_parts = split(local_reference, '/')
  let name = lr_parts[len(lr_parts)-1]

  return {
	  \ 'file': fname,
  	  \ 'local_reference': local_reference,
  	  \ 'local_name': name,
          \ }
endfunction


function g:JumpToDefinition() abort
  " TODO: substr
  if &ft != 'openapi.yaml'
    return
  endif

  let line_number = line('.')
  let line_contents = getbufline('.', line_number)
  let line_info = ParseLine(line_contents[0])
  if len(line_info) == 0
    return
  endif

  if line_info['file'] != ''
    " TODO
    " relative to current file, not vim's curdir
    let fname = line_info['file']
  else
    " current buffer
    " TODO: escape
    let fname = ''
  endif

  let cmd = '+/^\\s*' . line_info.local_name . ':'
  " goto line
  execute 'edit ' . cmd . ' ' . fname
  " move cursor on the name
  normal! 0w
endfunction



" TODO: debug
nmap <silent> gd :call JumpToDefinition()<CR>
nmap <silent> <C-]> :call JumpToDefinition()<CR>
