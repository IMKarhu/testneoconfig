vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.g.mapleader = ' '

--General keymaps
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<S-j>', ":m .+1<CR>==")
vim.keymap.set('n', '<S-k>', ":m .-2<CR>==")

--LSP keymaps
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

--File Exploring
vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set('n', '<C-n>', ":Oil<CR>")

--Terminal stuff
vim.keymap.set('n', '<leader>t', ':lua toggleTerminal(20)<CR>')
vim.keymap.set('t', '<leader>t', 'Exit<CR>:quit<CR>')

vim.pack.add({
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.pairs" },
    { src = "https://github.com/Bekaboo/dropbar.nvim" },
})

require "mini.pick".setup()
require "mini.pairs".setup()
require "oil".setup()


vim.cmd.colorscheme "rose-pine-moon"

vim.lsp.enable({ "lua_ls", "clangd", "glsl_analyzer", "slangd" })

vim.opt.completeopt = {"menuone", "noselect", "popup"}
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('testDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
                convert = function (item)
                    return {abbr = item.label:gsub('%b()', '')}
                end,
            })
            vim.keymap.set("i", "<C-space>", vim.lsp.completion.get)
        end
    end,
})


local termbuf = nil
local termwin = nil

function toggleTerminal(height)
    if termwin and vim.api.nvim_win_is_valid(termwin) then
        vim.cmd("hide")
    else
        vim.cmd("botright new")
        local newbuf = vim.api.nvim_get_current_buf()
        vim.cmd("resize " .. height)
        if termbuf and vim.api.nvim_buf_is_valid(termbuf) then
            vim.cmd("buffer " .. termbuf)
            vim.cmd("bd " .. newbuf)
        else
            vim.cmd("terminal")
            termbuf = vim.api.nvim_get_current_buf()
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.signcolumn = "no"
        end
    vim.cmd("startinsert!")
    termwin = vim.api.nvim_get_current_win()
    end
end
