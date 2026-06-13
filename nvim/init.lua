------------------------------ Autocmd ------------------------------

local group = vim.api.nvim_create_augroup('OoO', {})
local function au(typ, pattern, cmdOrFn)
	if type(cmdOrFn) == 'function' then
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
	else
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
	end
end

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    -- \x1b[4 q is the standard escape sequence for a steady underline
    io.write("\x1b[4 q")
  end,
})

------------------------------ Bootstrap lazy.nvim ------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

------------------------------ Keymaps ------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"+d")
vim.keymap.set("v", "<leader>d", "\"+d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<leader><C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader><C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><Tab>", ":NvimTreeFocus<cr>")
vim.keymap.set("n", "<leader><S-Tab>", ":NvimTreeToggle<cr>")

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end)
vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end)
vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end)
vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
vim.keymap.set("n", "<leader>th", function() vim.lsp.buf.typehierarchy("supertypes") end)

vim.api.nvim_create_user_command("W", function()
    -- disable that bitch
end, {})

------------------------------ OPT ------------------------------

-- TODO: Reset when neovim fixes #38987
-- vim.opt.guicursor = ""
vim.opt.guicursor = "n-v-c-sm:hor20,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
--vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

vim.o.winborder = 'rounded'

------------------------------ lazy.nvim ------------------------------

plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true
        })

        vim.cmd.colorscheme "catppuccin"
    end },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            -- Snippet engine (choose one)
            -- {'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'},
            -- Or
            {'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'},
        }

    }
}

require("lazy").setup({
  spec = plugins,
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false },
})

------------------------------ LSP ------------------------------

au({ 'CursorHold', 'InsertLeave' }, nil, function()
    local opts = {
        focusable = false,
        scope = 'cursor',
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
    }
    vim.diagnostic.open_float(nil, opts)
end)

vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    float = {
        border = 'rounded',
        source = 'if_many',
    },
    underline = true,
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.INFO] = 'I',
            [vim.diagnostic.severity.HINT] = 'H',
        },
    },
})

vim.lsp.config['clangd'] = {
    cmd = { 'clangd-22', '--background-index', '--clang-tidy' },
    filetypes = { 'c', 'cpp' }
}
vim.lsp.enable('clangd')

vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                library = {
                    '/usr/local/share/nvim/runtime/lua',
                    '/usr/local/share/nvim/runtime/lua/vim',
                    '/usr/local/share/nvim/runtime/lua/vim/lsp',
                }
            }
        }
    }
}
vim.lsp.enable('lua_ls')

vim.lsp.config("jdtls", {
    cmd = {
        "/opt/jdk-21.0.6/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-Xms1G",
        "-Xmx8G",
        "-XX:MaxMetaspaceSize=512M",
        "-jar", "/home/magnus/tooling/jdtls/plugins/org.eclipse.equinox.launcher_1.6.800.v20240304-1850.jar",
        "-configuration", "/home/magnus/tooling/jdtls/config_linux",
        "-data", vim.fn.expand('~/.local/share/jdtls/workspaces/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
    },
    filetypes = { 'java' },
    settings = {
        java = {
        },
    },
})
vim.lsp.enable("jdtls")

vim.lsp.config['rust-analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' }
}

vim.lsp.enable('rust-analyzer')

vim.lsp.config('ty', {
    settings = {
        ty = {
            -- ty LS settings
        }
    }
})

vim.lsp.enable('ty')

------------------------------ CMP ------------------------------

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    -- Key mappings (required)
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),

    -- Completion sources (required, in order of priority)
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})
