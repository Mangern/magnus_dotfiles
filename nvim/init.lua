require("before")

function startSD() 
    vim.lsp.start({
        name = 'schema-language-server',
        cmd = {'java', '-jar', '/Users/magnus/repos/vespa/integration/schema-language-server/language-server/target/schema-language-server-jar-with-dependencies.jar'},
        root_dir = vim.fn.getcwd()
    })
end

vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = {'*.sd', '*.profile'},
    callback = function(args)
        startSD()
    end
})



vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = {buffer = args.buf, remap = false}
        
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})
