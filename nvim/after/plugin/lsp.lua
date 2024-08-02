local lsp = require("lsp-zero")
local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"


if not configs.schemals then
    configs.schemals = {
        default_config = {
            filetypes = { 'sd' },
            cmd = { 'java', '-jar', '/Users/magnus/repos/vespa/integration/schema-language-server/language-server/target/schema-language-server-jar-with-dependencies.jar' },
            root_dir = lspconfig.util.root_pattern('.')
        },
    }
end


vim.filetype.add {
  extension = {
    profile = 'sd',
    sd = 'sd'
  }
}

lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'eslint',
	'rust_analyzer',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

lsp.set_preferences({
	sign_icons = { }
})

local on_attach = function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}
	
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>th", function() vim.lsp.buf.typehierarchy() end, opts)
end
lsp.on_attach(on_attach)

lsp.setup()
-- for some reason the custom client doesn't work with lsp-zero
lspconfig.schemals.setup{
    on_attach = on_attach
}
