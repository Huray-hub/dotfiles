local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  vim.notify('dap ' .. dap .. ' not found!')
  return
end

local icons = require('huray.icons')

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Bug, texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = icons.ui.Bug, texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })

local home = os.getenv('HOME')

-- adapter definitions
dap.adapters.cppdbg = { -- requires vscode's C/C++ extension
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.glob(home .. '/.vscode-server/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7'),
}

dap.adapters.lldb = { -- requires llvm package
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = 'lldb',
}

-- adapter configurations
dap.configurations.cpp = {
  -- {
  --   name = 'Launch gdb',
  --   type = 'cppdbg',
  --   request = 'launch',
  --   program = '${fileDirname}/a.out',
  --   cwd = '${workspaceFolder}',
  --   args = { '<', 'input1.txt' },
  --   stopOnEntry = true,
  --   setupCommands = {
  --     {
  --       text = '-enable-pretty-printing',
  --       description = 'enable pretty printing',
  --       ignoreFailures = false,
  --     },
  --   },
  --   MIMode = 'gdb',
  --   externalConsole = false,
  -- },
  -- {
  -- 	name = "Attach to gdbserver :1234",
  -- 	type = "cppdbg",
  -- 	request = "launch",
  -- 	MIMode = "gdb",
  -- 	miDebuggerServerAddress = "localhost:1234",
  --  program = '${relativeFileDirname}/a.out',
  -- 	cwd = "${workspaceFolder}",
  -- },
  {
    name = 'Launch lldb',
    type = 'lldb',
    request = 'launch',
    program = '${relativeFileDirname}/a.out',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    MIMode = 'lldb',

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
    -- 💀
    -- If you use `runInTerminal = true` and resize the terminal window,
    -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
    -- To avoid that uncomment the following option
    -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
    postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' },
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require('nvim-dap-virtual-text').setup()
require('dapui').setup()

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', '<F5>', "<cmd>lua require('dap').continue()<CR>", opts) --it also starts the execution in debug mode
keymap('n', '<F17>', "<cmd>lua require('dap').terminate()<CR>", opts) --F17 = S-F5
--TODO: map  F29 (= C-F5 to either 'run without debugger'  or 'restart debugger')
keymap('n', '<F10>', "<cmd>lua require('dap').step_over()<CR>", opts)
keymap('n', '<F11>', "<cmd>lua require('dap').step_into()<CR>", opts)
keymap('n', '<F22>', "<cmd>lua require('dap').step_out()<CR>", opts) --F22 -> S-F11
keymap('n', '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
keymap('n', '<leader>B', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap(
  'n',
  '<leader>lp',
  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  opts
)
keymap('n', '<leader>dr', "<cmd>lua require('dap').repl.open()<CR>", opts)
keymap('n', '<leader>dl', "<cmd>lua require('dap').run_last()<CR>", opts)
