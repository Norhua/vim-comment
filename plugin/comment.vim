" 快速注释
    nnoremap <silent> ?? :<c-u>call <SID>setComment(line("."), line("."))<CR>
    xnoremap <silent> /  :<c-u>call <SID>setComment(line("'<"), line("'>"))<CR>
    snoremap <silent> /  <c-g>:<c-u>call <SID>setComment(line("'<"), line("'>"))<CR>

    func! s:setComment(num1, num2)
        let com = s:getComment()
        let [commented, col] = s:checkComment(a:num1, a:num2, com)
        let com = com . '  '
        for num in range(a:num1, a:num2)
            let line = getline(num)
            if line =~ '^\s*$'
                continue
            endif
            let left = col > 0 ? line[:col-1] : ''
            let right = commented ? line[col+len(com):] : line[col:]
            let center = commented ? '' : com
            call setline(num, left . center . right)
        endfor
    endf

    func! s:getComment()
        if &filetype == 'vim'
            return '"'
        elseif &filetype == 'conf'
            return '#'
        endif
        return '//'
    endf

    func! s:checkComment(num1, num2, com)
        let commented = 1
        let col = 999
        for num in range(a:num1, a:num2)
            let line = getline(num)
            if line =~ '^\s*$'
                continue
            endif
            let line2 = substitute(line, '^\s*', '', 'g')
            let col = min([col, len(line) - len(line2)])
            let commented = commented && line2[:len(a:com) - 1] ==# a:com
        endfor
        return [commented, col]
    endf
