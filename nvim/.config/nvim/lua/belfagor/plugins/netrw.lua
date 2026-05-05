return {
    "prichrd/netrw.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons" -- This is the standard engine for Neovim icons
    },
    config = function()
        require("netrw").setup({
            -- 'true' tells it to pull from the nvim-web-devicons library
            use_devicons = true,

            -- Fallback icons if a specific file type isn't recognized
            icons = {
                symlink = '',
                directory = '',
                file = '',
            },
        })
    end
}
