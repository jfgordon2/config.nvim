return {
    {
        'rubiin/fortune.nvim',
        opts = {
            content_type = 'tips',
            display_format = 'mixed',
            custom_tips = {
                short = {
                    {
                        '<number>G goes to the line with that number',
                        '',
                        '- Neovim',
                    },
                    {
                        '`:%s/./&/gn` counts characters in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        '`:%s/\\i\\+/&/gn` counts characters in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        '`:%s/^//n` counts lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Mapping caps-lock to escape is a common practice for vim users',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use "_ to yank into the black hole register',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:help g` to learn about the powerful uses of the g command',
                        '',
                        '- Neovim',
                    },
                    {
                        'If text is wrapping use gk and gj to move up and down',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use CTRL-A and CTRL-X to increment and decrement numbers',
                        '',
                        '- Neovim',
                    },
                    {
                        'You can use a vimscript function to replace text `%s/replace/\\=1+1`',
                        '',
                        '- Neovim',
                    },
                    {
                        'q: opens the recent command history',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort` to sort lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:grep` to search for patterns in multiple files',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:w !sudo tee %` to save a file that requires root permission',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort u` to remove duplicate lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g/pattern/d` to delete lines containing a specific pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:%!xxd` to convert a file to hexadecimal',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g/^/m0` to reverse the order of lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set list` to display whitespace characters in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set spell` to enable spell checking',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set number` to display line numbers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabnew` to open a new tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabnext` or `gt` to switch to the next tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabprevious` or `gT` to switch to the previous tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabclose` to close the current tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vsp filename` to open a file in a vertical split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sp filename` to open a file in a horizontal split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W h/j/k/l` to navigate between splits',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:resize +/-n` to adjust the height of the current split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vertical resize +/-n` to adjust the width of the current split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sview` to open a file in readonly mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:setlocal spell` to enable spell checking for the current buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` to run the make command and display errors in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cnext` and `:cprev` to navigate through quickfix list items',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cw` to open the quickfix list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:colder` and `:cnewer` to navigate through older and newer quickfix lists',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:marks` to list all the current marks',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:delmarks a b c` to delete marks a, b, and c',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make!` to force make command execution',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:noautocmd w` to write a file without triggering autocmd events',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checktime` to check if the file has been modified outside of Neovim',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:e!` to reload the current file from disk, discarding changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:registers` to display the contents of all registers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"*y` to yank text into the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"*p` to paste from the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:TOhtml` to convert the current buffer to HTML',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:TOhtml` followed by a filename to save the HTML output to a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:registers` followed by a register name to display the contents of a specific register',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"+yy` to yank a line into the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"+p` to paste from the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:write` or `:w` to save changes to a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:edit` or `:e` to open a file for editing',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:q` to quit Neovim',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:q!` to forcefully quit Neovim without saving changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:wq` to save changes and quit',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ls` to list all open buffers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bnext` or `:bn` to switch to the next buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bprevious` or `:bp` to switch to the previous buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bdelete` or `:bd` to delete a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cd` followed by a directory path to change the current directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:pwd` to display the current working directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:r` followed by a filename to insert the contents of a file at the current cursor position',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:read` followed by a shell command to insert the output of a command at the current cursor position',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:source` followed by a file path to execute a Vimscript file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:history` to display command-line history',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ju` or `:jumps` to display a list of jump locations',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:changes` to display a list of recent changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checkhealth` to diagnose common issues with your Neovim setup',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:scriptnames` to display a list of sourced scripts',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set option?` to display the current value of an option',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo &option` to display the current value of an option',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:verbose set option?` to find out where an option was last set',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent set option? | redir END` to copy the output of `:set option?` to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent echo &option | redir END` to copy the value of an option to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent verbose set option? | redir END` to copy the verbose output of `:set option?` to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:terminal` to open a terminal window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:term` as an alias for `:terminal`',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `N` to switch to normal mode in terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `C` to exit terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sp term://$SHELL` to open a terminal in a horizontal split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vsp term://$SHELL` to open a terminal in a vertical split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termedit` to open a terminal buffer with the contents of a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termfind` to open a terminal buffer with the contents of a file and position the cursor at the first match of a pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:grep` followed by a search pattern and file pattern to search for text in files',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lgrep` to perform a search using the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vimgrep` to perform a search using the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lvimgrep` to perform a search using the location list and the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a program name to compile a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a command to run a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:compiler` followed by a compiler name to set the compiler',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lmake` to run make and populate the location list with errors',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` to open the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lclose` to close the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lfirst` to move to the first error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:llast` to move to the last error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lnext` to move to the next error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lprevious` to move to the previous error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` followed by a number to open the location list window and jump to the specified error',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ldo` to execute a command on each error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter` to filter the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cfdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter!` to clear the quickfix list filter',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort` followed by a range to sort lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort u` followed by a range to remove duplicate lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g` followed by a pattern and a command to execute the command on lines that match the pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:g!` followed by a pattern and a command to execute the command on lines that don't match the pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g//m$` to move all lines matching a pattern to the end of the file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:global` as an alias for `:g`',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:vglobal` to execute a command on lines that don't match a pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:normal` followed by a sequence of keys to execute normal mode commands',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:helpgrep` to search for help topics containing a specific keyword',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set listchars` to configure the characters used to represent invisible characters',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIMRUNTIME` to display the location of the Vim runtime directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIM` to display the location of the Vim configuration directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checkhealth` to diagnose common issues with your Neovim setup',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:terminal` to open a terminal window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:term` as an alias for `:terminal`',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `N` to switch to normal mode in terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `C` to exit terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sp term://$SHELL` to open a terminal in a horizontal split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vsp term://$SHELL` to open a terminal in a vertical split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termedit` to open a terminal buffer with the contents of a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termfind` to open a terminal buffer with the contents of a file and position the cursor at the first match of a pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:grep` followed by a search pattern and file pattern to search for text in files',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lgrep` to perform a search using the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vimgrep` to perform a search using the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lvimgrep` to perform a search using the location list and the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a program name to compile a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a command to run a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:compiler` followed by a compiler name to set the compiler',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lmake` to run make and populate the location list with errors',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` to open the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lclose` to close the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lfirst` to move to the first error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:llast` to move to the last error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lnext` to move to the next error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lprevious` to move to the previous error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` followed by a number to open the location list window and jump to the specified error',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ldo` to execute a command on each error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter` to filter the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cfdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter!` to clear the quickfix list filter',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort` followed by a range to sort lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort u` followed by a range to remove duplicate lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g` followed by a pattern and a command to execute the command on lines that match the pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:g!` followed by a pattern and a command to execute the command on lines that don't match the pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g//m$` to move all lines matching a pattern to the end of the file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:global` as an alias for `:g`',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:vglobal` to execute a command on lines that don't match a pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:normal` followed by a sequence of keys to execute normal mode commands',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:helpgrep` to search for help topics containing a specific keyword',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set listchars` to configure the characters used to represent invisible characters',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIMRUNTIME` to display the location of the Vim runtime directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIM` to display the location of the Vim configuration directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checkhealth` to diagnose common issues with your Neovim setup',
                        '',
                        '- Neovim',
                    },
                },
                long = {
                    {
                        'Mapping caps-lock to escape is a common practice for vim users',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use "_ to yank into the black hole register',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:help g` to learn about the powerful uses of the g command',
                        '',
                        '- Neovim',
                    },
                    {
                        'If text is wrapping use gk and gj to move up and down',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use CTRL-A and CTRL-X to increment and decrement numbers',
                        '',
                        '- Neovim',
                    },
                    {
                        'You can use a vimscript function to replace text `%s/replace/\\=1+1`',
                        '',
                        '- Neovim',
                    },
                    {
                        'q: opens the recent command history',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort` to sort lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:grep` to search for patterns in multiple files',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:w !sudo tee %` to save a file that requires root permission',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort u` to remove duplicate lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g/pattern/d` to delete lines containing a specific pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:%!xxd` to convert a file to hexadecimal',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g/^/m0` to reverse the order of lines in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set list` to display whitespace characters in a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set spell` to enable spell checking',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set number` to display line numbers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabnew` to open a new tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabnext` or `gt` to switch to the next tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabprevious` or `gT` to switch to the previous tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:tabclose` to close the current tab',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vsp filename` to open a file in a vertical split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sp filename` to open a file in a horizontal split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W h/j/k/l` to navigate between splits',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:resize +/-n` to adjust the height of the current split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vertical resize +/-n` to adjust the width of the current split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sview` to open a file in readonly mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:setlocal spell` to enable spell checking for the current buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` to run the make command and display errors in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cnext` and `:cprev` to navigate through quickfix list items',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cw` to open the quickfix list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:colder` and `:cnewer` to navigate through older and newer quickfix lists',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:marks` to list all the current marks',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:delmarks a b c` to delete marks a, b, and c',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make!` to force make command execution',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:noautocmd w` to write a file without triggering autocmd events',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checktime` to check if the file has been modified outside of Neovim',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:e!` to reload the current file from disk, discarding changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:registers` to display the contents of all registers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"*y` to yank text into the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"*p` to paste from the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:TOhtml` to convert the current buffer to HTML',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:TOhtml` followed by a filename to save the HTML output to a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:registers` followed by a register name to display the contents of a specific register',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"+yy` to yank a line into the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `"+p` to paste from the system clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:write` or `:w` to save changes to a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:edit` or `:e` to open a file for editing',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:q` to quit Neovim',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:q!` to forcefully quit Neovim without saving changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:wq` to save changes and quit',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ls` to list all open buffers',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bnext` or `:bn` to switch to the next buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bprevious` or `:bp` to switch to the previous buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:bdelete` or `:bd` to delete a buffer',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cd` followed by a directory path to change the current directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:pwd` to display the current working directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:r` followed by a filename to insert the contents of a file at the current cursor position',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:read` followed by a shell command to insert the output of a command at the current cursor position',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:source` followed by a file path to execute a Vimscript file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:history` to display command-line history',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ju` or `:jumps` to display a list of jump locations',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:changes` to display a list of recent changes',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checkhealth` to diagnose common issues with your Neovim setup',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:scriptnames` to display a list of sourced scripts',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set option?` to display the current value of an option',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo &option` to display the current value of an option',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:verbose set option?` to find out where an option was last set',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent set option? | redir END` to copy the output of `:set option?` to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent echo &option | redir END` to copy the value of an option to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:redir @* | silent verbose set option? | redir END` to copy the verbose output of `:set option?` to the clipboard',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:terminal` to open a terminal window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:term` as an alias for `:terminal`',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `N` to switch to normal mode in terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `Ctrl-W` followed by `C` to exit terminal mode',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sp term://$SHELL` to open a terminal in a horizontal split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vsp term://$SHELL` to open a terminal in a vertical split',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termedit` to open a terminal buffer with the contents of a file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:termfind` to open a terminal buffer with the contents of a file and position the cursor at the first match of a pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:grep` followed by a search pattern and file pattern to search for text in files',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lgrep` to perform a search using the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:vimgrep` to perform a search using the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lvimgrep` to perform a search using the location list and the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a program name to compile a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:make` followed by a command to run a program',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:compiler` followed by a compiler name to set the compiler',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lmake` to run make and populate the location list with errors',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` to open the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lclose` to close the location list window',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lfirst` to move to the first error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:llast` to move to the last error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lnext` to move to the next error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lprevious` to move to the previous error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:lopen` followed by a number to open the location list window and jump to the specified error',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:ldo` to execute a command on each error in the location list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter` to filter the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:cfdo` to execute a command on each error in the quickfix list',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:Cfilter!` to clear the quickfix list filter',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort` followed by a range to sort lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:sort u` followed by a range to remove duplicate lines in the specified range',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g` followed by a pattern and a command to execute the command on lines that match the pattern',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:g!` followed by a pattern and a command to execute the command on lines that don't match the pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:g//m$` to move all lines matching a pattern to the end of the file',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:global` as an alias for `:g`',
                        '',
                        '- Neovim',
                    },
                    {
                        "Use `:vglobal` to execute a command on lines that don't match a pattern",
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:normal` followed by a sequence of keys to execute normal mode commands',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:helpgrep` to search for help topics containing a specific keyword',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:set listchars` to configure the characters used to represent invisible characters',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIMRUNTIME` to display the location of the Vim runtime directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:echo $VIM` to display the location of the Vim configuration directory',
                        '',
                        '- Neovim',
                    },
                    {
                        'Use `:checkhealth` to diagnose common issues with your Neovim setup',
                        '',
                        '- Neovim',
                    },
                    -- https://github.com/openuado/vimtips-fortune/blob/master/fortunes/vimtips
                    {
                        'After performing an undo, you can navigate through the changes using g- and g+. Also, try :undolist to list the changes.',
                        '',
                        '- Vim',
                    },
                    { 'g; will cycle through your recent changes (or g, to go in reverse).', '', '- Vim' },
                    { '"2p will put the second to last thing yanked, "3p will put the third to last, etc.', '', '- Vim' },
                    { ':%s/^\n\\+/\r/ will compress multiple empty lines into one.', '', '- Vim' },
                    { ":%s/~/sue/igc substitute your last replacement string with 'sue'.", '', '- Vim' },
                    { 'To search for a URL without backslashing, search backwards! Example: ?http://somestuff.com', '', '- Vim' },
                    { "Basic commands 'f' and 't' (like first and 'til) are very powerful. See :help t or :help f.", '', '- Vim' },
                    { 'In insert mode do Ctrl+r=53+17<Enter>. This way you can do some calcs with vim.', '', '- Vim' },
                    { 'ci" inside a " " will erase everything between "" and place you in insertion mode.', '', '- Vim' },
                    { 'guu converts entire line to lowercase. gUU converts entire line to uppercase. ~ inverts case of current character.', '', '- Vim' },
                    { '<CTRL-o> : trace your movements backwards in a file. <CTRL-i> trace your movements forwards in a file.', '', '- Vim' },
                    { '@: to repeat the last executed command.', '', '- Vim' },
                    { ':e $MYVIMRC to directly edit your vimrc.  :source $MYVIMRC to reload.  Mappings may make it even easier.', '', '- Vim' },
                    { 'g<CTRL-G> to see technical information about the file, such as how many words are in it, or how many bytes it is.', '', '- Vim' },
                    { 'gq{movement} to wrap text, or just gq while in visual mode. gqap will format the current paragraph.', '', '- Vim' },
                    { 'gf will open the file under the cursor.  (Killer feature.)', '', '- Vim' },
                    { ':tabdo [some command] will execute the command in all tabs.  Also see windo, bufdo, argdo.', '', '- Vim' },
                    { "qa starts a recording in register 'a'. q stops it. @a repeats the recording. 5@a repeats it 5 times.", '', '- Vim' },
                    { ':%s/\v(.*\n){5}/&\r will insert a blank line every 5 lines', '', '- Vim' },
                    { "Use '\v' in your regex to set the mode to 'very magic', and avoid confusion. (:h \v for more info.)", '', '- Vim' },
                    { "; is a motion to repeat last find with f. f' would find next quote. c; would change up to the next '", '', '- Vim' },
                    { 'ga will display the ASCII, hex, and octal value of the character under the cursor.', '', '- Vim' },
                },
            },
        },
    },
    {
        vim.keymap.set('n', '<leader>nf', function()
            local fortune_table = require('fortune').get_fortune()
            local text = ''
            for _, fortune in ipairs(fortune_table) do
                if fortune == '' then
                    text = text .. '\n'
                else
                    text = text .. fortune .. '\n'
                end
            end
            vim.notify(text, vim.log.levels.INFO, { title = 'Fortune', icon = '󰮥 ' })
        end, { desc = 'Show a fortune' }),
    },
}
