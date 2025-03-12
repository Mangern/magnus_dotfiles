require("before")

vim.keymap.set("n", "<leader>r", function ()
        vim.cmd ( "execute '!python3 " .. vim.fn.expand('%') .. "'" )
    end
)
