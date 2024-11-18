return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "carbonfox",
        },
    },
    {
        "EdenEast/nightfox.nvim",
        opts = {
            transparent = true,
            styles = {
                sidebar = "transparent",
                floats = "transparent",
            },
            palettes = {
                -- Custom duskfox with black background
                carbonfox = {
                    bg1 = "#000000", -- Black background
                },
            },
        },
    },
}
