return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    opts = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = [[ 
         /\\\\\_____/\\\_______________________________/\\\________/\\\___________________________         
         \/\\\\\\___\/\\\______________________________\/\\\_______\/\\\__________________________         
         _\/\\\/\\\__\/\\\______________________________\//\\\______/\\\___/\\\_____________________       
          _\/\\\//\\\_\/\\\_____/\\\\\\\\______/\\\\\_____\//\\\____/\\\___\///_____/\\\\\__/\\\\\__       
           _\/\\\\//\\\\/\\\___/\\\/////\\\___/\\\///\\\____\//\\\__/\\\_____/\\\__/\\\///\\\\\///\\\_     
            _\/\\\_\//\\\/\\\__/\\\\\\\\\\\___/\\\__\//\\\____\//\\\/\\\_____\/\\\_\/\\\_\//\\\__\/\\\     
             _\/\\\__\//\\\\\\_\//\\///////___\//\\\__/\\\______\//\\\\\______\/\\\_\/\\\__\/\\\__\/\\\_   
              _\/\\\___\//\\\\\__\//\\\\\\\\\\__\///\\\\\/________\//\\\_______\/\\\_\/\\\__\/\\\__\/\\\   
               _\///_____\/////____\//////////_____\/////___________\///________\///__\///___\///___\///__ 
	                                                                                                   
        ]]

        dashboard.section.buttons.val = {
          dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
          dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
          dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
          dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
          dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
          dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
        }
        for _, button in ipairs(dashboard.section.buttons.val) do
          button.opts.hl = "AlphaButtons"
          button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 8

        return dashboard
    end,
    config = function(_, dashboard)
        if vim.o.filetype == "lazy" then
          vim.cmd.close()
          vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "AlphaReady",
            callback = function()
              require("lazy").show()
            end,
          })
        end
        require("alpha").setup(dashboard.opts)
    end
}
