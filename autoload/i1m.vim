let s:bx_im_code_fn = 'dict.txt'
let s:path = expand("<sfile>:p:h") . "/../"
let s:alpha = "abcdefghijklmnopqrstuvwxyz"
let s:punc = ",.:?\\/!@^_#%$`~{}<>()'\""
let s:mem_dict = {}

function i1m#Toggle()
    if !exists('b:chineseMode')
        let b:chineseMode = 0
    endif
    if b:chineseMode
        call s:Exit()
    else
        call s:Init()
    endif
    silent!exe 'silent!return "\<SPACE>\<BS>\<C-O>:redraws\<CR>"'
endfunction

function i1m#ShowOption(findstart, keyboard)
if a:findstart
    let columnNum = col('.') - 1
    let start = columnNum - s:typeLen
    return start
else
    if len(s:matchFrom) == 0
        return ''
    else
        let res = []
        for index in s:matchFrom
            let res += [split(g:bx_im_table[index])[1]]
        endfor
        return res
    endif
endif
endfunction

function s:Init()
    call s:InitSettings()
    if !exists('g:bx_im_table')
        let g:bx_im_table = s:GetTable()
    endif
    if !exists('b:chinesePunc')
        let b:chinesePunc = 1
    endif
    if b:chinesePunc
        call s:MapChinesePunc()
    else
        call s:MapEnglishPunc()
    endif
    let s:typeLen = 0
    let b:chineseMode = 1
endfunction

function s:Exit()
    call s:ExitSettings()
    let s:typeLen = 0
    let b:chineseMode = 0
endfunction

function s:InitSettings()
    " backup
    let b:save_completefunc = &completefunc
    let b:save_completeopt = &completeopt
    let b:save_iminsert = &iminsert
    let b:save_pumheight = &pumheight
    let b:save_cpo = &cpo
    let b:save_lazyredraw = &lazyredraw
    let b:save_paste = &paste
    " vimconfig
    let &l:completefunc = 'i1m#ShowOption'
    let &l:completeopt = 'menuone'
    let &l:iminsert = 1
    let &l:pumheight = 5
    let &l:cpo = 'aABceFsz'
    let &l:lazyredraw = 0
    let &l:paste = 0
    " imap
    call s:MapAnyKeys()
    inoremap<buffer> <Space> <C-R>=<SID>SmartSpace()<CR>
    inoremap<buffer> ; <C-R>=<SID>SmartSem()<CR>
    inoremap<buffer> <CR> <C-R>=<SID>SmartEnter()<CR>
    inoremap<buffer> <BS> <C-R>=<SID>SmartBack()<CR>
    inoremap<buffer> <C-\> <C-R>=<SID>ToggleChinesePunc()<CR>
    inoremap<buffer> <ESC> <C-R>=<SID>Reset()<CR><ESC>
    inoremap<buffer> <C-W> <C-R>=<SID>Reset()<CR><C-W>
    " hl
    highlight! lCursor guifg=bg guibg=green
    highlight! link PmenuSel MatchParen
    highlight! link Pmenu StatusLine
    highlight! link PmenuThumb DiffAdd
endfunction

function s:ExitSettings()
    " vimconfig
    let &l:completeopt = b:save_completeopt
    let &l:completefunc = b:save_completefunc
    let &l:iminsert = b:save_iminsert
    let &l:pumheight = b:save_pumheight
    let &l:cpo = b:save_cpo
    let &l:lazyredraw = b:save_lazyredraw
    let &l:paste = b:save_paste
    " map
    call s:UnmapAnyKeys()
    iunmap<buffer> <Space>
    iunmap<buffer> ;
    iunmap<buffer> <CR>
    iunmap<buffer> <BS>
    iunmap<buffer> <C-\>
    iunmap<buffer> <ESC>
    iunmap<buffer> <C-W>
    " hl
    highlight! lCursor None
    highlight! link PmenuSel PmenuSel
    highlight! link Pmenu Pmenu
    highlight! link PmenuThumb PmenuThumb
endfunction

function s:Reset()
    let s:typeLen = 0
    let s:matchFrom = []
    return ''
endfunction

function s:GetTable()
    let tableFile = s:path . s:bx_im_code_fn
    try
        let table = readfile(tableFile)
    catch /E484:/
        echo 'Counld not open the table file `' . tableFile . '`'
    endtry
    return table
endfunction

function s:ToggleChinesePunc()
    if b:chinesePunc
        call s:MapEnglishPunc()
    else
        call s:MapChinesePunc()
    endif
    return ''
endfunction

function s:MapChinesePunc()
    let b:chinesePunc = 1
    inoremap<buffer> , <C-R>=<SID>PuncIn()<CR>，
    inoremap<buffer> . <C-R>=<SID>PuncIn()<CR>。
    inoremap<buffer> : <C-R>=<SID>PuncIn()<CR>：
    inoremap<buffer> ? <C-R>=<SID>PuncIn()<CR>？
    inoremap<buffer> \ <C-R>=<SID>PuncIn()<CR>、
    inoremap<buffer> / <C-R>=<SID>PuncIn()<CR>/
    inoremap<buffer> ! <C-R>=<SID>PuncIn()<CR>!
    inoremap<buffer> @ <C-R>=<SID>PuncIn()<CR>@
    inoremap<buffer> ^ <C-R>=<SID>PuncIn()<CR>^
    inoremap<buffer> _ <C-R>=<SID>PuncIn()<CR>_
    inoremap<buffer> # <C-R>=<SID>PuncIn()<CR>#
    inoremap<buffer> % <C-R>=<SID>PuncIn()<CR>%
    inoremap<buffer> $ <C-R>=<SID>PuncIn()<CR>￥
    inoremap<buffer> ` <C-R>=<SID>PuncIn()<CR>`
    inoremap<buffer> ~ <C-R>=<SID>PuncIn()<CR>~
    inoremap<buffer> < <C-R>=<SID>PuncIn()<CR>《
    inoremap<buffer> > <C-R>=<SID>PuncIn()<CR>》
    inoremap<buffer> ( <C-R>=<SID>PuncIn()<CR>（
    inoremap<buffer> ) <C-R>=<SID>PuncIn()<CR>）
    inoremap<buffer> { <C-R>=<SID>PuncIn()<CR>{
    inoremap<buffer> } <C-R>=<SID>PuncIn()<CR>}
    inoremap<buffer> ' <C-R>=<SID>PuncIn()<CR><C-R>=<SID>ToggleChineseQuote("'")<CR>
    inoremap<buffer> " <C-R>=<SID>PuncIn()<CR><C-R>=<SID>ToggleChineseQuote('"')<CR>
endfunction

function s:MapEnglishPunc()
    let b:chinesePunc = 0
    for key in s:punc
        exec "inoremap<buffer> ".key." <C-R>=<SID>PuncIn()<CR>".key
    endfor
endfunction

function s:ToggleChineseQuote(mark)
    if a:mark == "'"
        if !exists('b:singleMode')
            let b:singleMode = 0
        endif
        let b:singleMode = abs(b:singleMode - 1)
        return b:singleMode == 1 ? "‘" : "’"
    elseif a:mark == '"'
        if !exists('b:doubleMode')
            let b:doubleMode = 0
        endif
        let b:doubleMode = abs(b:doubleMode - 1)
        return b:doubleMode == 1 ? "“" : "”"
    endif
endfunction

function s:PuncIn()
    let s:typeLen = 0
    if pumvisible()
        return puncIn = "\<C-Y>"
    endif
    return ''
endfunction

function s:SmartSpace()
    let s:typeLen = 0
    if pumvisible()
        return "\<C-Y>"
    endif
    return " "
endfunction

function s:SmartSem()
    let s:typeLen = 0
    let temp = ""
    if pumvisible()
        if len(s:matchFrom) >= 2
            return "\<C-N>\<C-Y>"
        endif
        let temp .= "\<C-Y>"
    endif
    let temp .= [";", "；"][b:chinesePunc]
    return temp
endfunction

function s:SmartEnter()
    if s:typeLen != 0
        let s:typeLen = 0
        if pumvisible()
            return "\<C-E>"
        endif
        return ''
    endif
    return "\<CR>"
endfunction

function s:SmartBack()
    let bs = "\<BS>"
    if s:typeLen > 1
        let s:typeLen -= 1
        let p = getpos('.')
        if getline('.')[p[2] - 3] !~# '\l'
            let s:typeLen = 0
            let s:matchFrom = []
            let bs = bs . "\<C-X>\<C-U>"
        else
            call setpos('.', [p[0], p[1], p[2] - 1, p[3]])
            call s:RefreshMatch()
            let bs = "\<Del>\<C-X>\<C-U>\<C-P>\<Down>"
        endif
    else
        let s:typeLen = 0
        let s:matchFrom = []
    endif
    return bs
endfunction

function s:MapAnyKeys()
    for key in s:alpha
        exec "inoremap<buffer><silent> ".key." <C-R>=<SID>PreKey()<CR>".key."<C-R>=<SID>AnyKey()<CR>"
    endfor
endfunction

function s:UnmapAnyKeys()
    for key in s:alpha.s:punc
        exec "iunmap<buffer> ".key
    endfor
endfunction

function s:PreKey()
    if s:typeLen == 4
        if pumvisible()
            return "\<C-Y>"
        else
            return "\<BS>\<BS>\<BS>\<BS>"
        endif
        let s:typeLen = 0
    endif
    return ''
endfunction

function s:AnyKey()
    let s:typeLen += 1
    if s:typeLen > 1
        " after select by <c-n/p>
        let columnNum = col('.')
        let charBefore = getline('.')[columnNum - 3]
        if charBefore !~# '\l'
            let s:typeLen = 1
        endif
    endif
    call s:RefreshMatch()
    let l = len(s:matchFrom)
    if l == 0
        return ""
    endif
    if s:typeLen == 4 && l == 1
        let s:typeLen = 0
        return "\<BS>\<BS>\<BS>\<BS>".split(g:bx_im_table[s:matchFrom[0]])[1]
    endif
    return "\<C-X>\<C-U>\<C-P>\<Down>"
endfunction

function s:RefreshMatch()
    let lineNum = line('.')
    let columnNum = col('.') - 1
    let temstr = getline(lineNum)
    let from = columnNum - s:typeLen
    let to = columnNum - 1
    let s:matchFrom = s:LazyMatch(temstr[from : to])
endfunction

function s:LazyMatch(input)
    if !has_key(s:mem_dict, a:input)
        let patterns = '^'.a:input.' '
        let res = []
        let idx = match(g:bx_im_table, patterns, 0)
        while idx != -1
            call add(res, idx)
            let idx = match(g:bx_im_table, patterns, idx + 1)
        endwhile
        let s:mem_dict[a:input] = res
    endif
    return s:mem_dict[a:input]
endfunction
