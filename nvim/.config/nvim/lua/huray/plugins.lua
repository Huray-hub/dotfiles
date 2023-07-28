local my_utils = require('huray.my-utils')
local command = my_utils.command

-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    print('Installing packer close and reopen Neovim...')
    command('packadd packer.nvim')
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    -- General
    use('wbthomason/packer.nvim') -- Have packer manage itself
    use('nvim-lua/popup.nvim') -- An implementation of the Popup API from vim in Neovim
    use('nvim-lua/plenary.nvim') -- Useful lua functions used ny lots of plugins
    use('kyazdani42/nvim-web-devicons')
    use('kyazdani42/nvim-tree.lua')
    use('moll/vim-bbye')
    use('nvim-lualine/lualine.nvim')
    use('akinsho/toggleterm.nvim')
    use('ahmedkhalf/project.nvim')
    use('lewis6991/impatient.nvim')
    use('folke/which-key.nvim')
    use('kosayoda/nvim-lightbulb')

    -- Convenience
    use('kylechui/nvim-surround') -- Surround text-objects with letters
    use('voldikss/vim-browser-search') -- Open Urls to Browser
    use('norcalli/nvim-colorizer.lua') -- Colors on hex codes
    use('Shatur/neovim-session-manager') -- Session support
    use('windwp/nvim-autopairs') -- Autopairs, integrates with both cmp and treesitter
    use('numToStr/Comment.nvim') -- Easily comment stuff
    use('lukas-reineke/indent-blankline.nvim')
    use('RRethy/vim-illuminate')
    use('filipdutescu/renamer.nvim')
    use('stevearc/dressing.nvim')
    use({ 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }) -- Modern looks for folding
    --[[ use({ 'kevinhwang91/nvim-bqf', ft = 'qf' }) ]]
    use('windwp/nvim-ts-autotag')
    use('uga-rosa/translate.nvim')
    use('b0o/incline.nvim')
    use({ 'folke/trouble.nvim', requires = 'nvim-tree/nvim-web-devicons' })
    use({
        'lukas-reineke/headlines.nvim',
        after = 'nvim-treesitter',
    })
    -- Colorschemes
    use('folke/tokyonight.nvim')
    use('Mofiqul/dracula.nvim')
    use('ellisonleao/gruvbox.nvim')
    use({ 'EdenEast/nightfox.nvim', tag = 'v1.0.0' })
    use('xiyaowong/nvim-transparent')

    -- Cmp plugins
    use('hrsh7th/nvim-cmp') -- The completion plugin
    use('hrsh7th/cmp-buffer') -- buffer completions
    use('hrsh7th/cmp-path') -- path completions
    use('hrsh7th/cmp-cmdline') -- cmdline completions
    use('saadparwaiz1/cmp_luasnip') -- snippet completions
    use('hrsh7th/cmp-nvim-lsp')
    use('rcarriga/cmp-dap') -- completion for dap buffers

    -- Snippets
    use('L3MON4D3/LuaSnip') --snippet engine
    use('rafamadriz/friendly-snippets') -- a bunch of snippets to use

    -- LSP
    use('neovim/nvim-lspconfig') -- enable LSP
    use('williamboman/mason.nvim') -- simple to use language server installer
    use('williamboman/mason-lspconfig.nvim')
    use('tamago324/nlsp-settings.nvim') -- language server settings defined in json for
    use('jose-elias-alvarez/null-ls.nvim') -- for formatters and linters
    use('ray-x/lsp_signature.nvim')
    -- Programming languages
    use('mfussenegger/nvim-jdtls') -- Java
    use('simrat39/rust-tools.nvim') -- Rust
    use('ray-x/go.nvim') -- Golang
    use('ray-x/guihua.lua') -- recommended if need floating window support

    -- Debugging
    use('mfussenegger/nvim-dap') -- debug adapter protocol
    use('theHamsta/nvim-dap-virtual-text')
    use('rcarriga/nvim-dap-ui')
    use('mfussenegger/nvim-dap-python')
    use('leoluz/nvim-dap-go') -- delve go debugger
    use('mxsdev/nvim-dap-vscode-js')

    -- Testing
    use({
        'nvim-neotest/neotest',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim',
            'nvim-neotest/neotest-go',
            -- Your other test adapters here
        },
        config = function()
            -- get neotest namespace (api call creates or returns namespace)
            local neotest_ns = vim.api.nvim_create_namespace('neotest')
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message =
                            diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
                        return message
                    end,
                },
            }, neotest_ns)
            require('neotest').setup({
                -- your neotest config here
                adapters = {
                    require('neotest-go'),
                },
            })
        end,
    })

    -- Telescope
    use('nvim-telescope/telescope.nvim')

    -- Treesitter
    use({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    })
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('JoosepAlviste/nvim-ts-context-commentstring')

    -- Git
    use('lewis6991/gitsigns.nvim')
    use({ 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim' })
    use({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })

    -- Discord presence
    use('andweeb/presence.nvim')

    -- Org mode
    use('nvim-orgmode/orgmode')

    -- SchemaStore
    use('b0o/schemastore.nvim')

    -- Database
    use('tpope/vim-dadbod')
    use('kristijanhusak/vim-dadbod-ui')
    use('kristijanhusak/vim-dadbod-completion')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
