return {
  "nosduco/remote-sshfs.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = { "RemoteSSHFSConnect", "RemoteSSHFSDisconnect", "RemoteSSHFSEdit" },
  opts = {
    connections = {
      ssh_configs = {
        os.getenv("HOME") .. "/.ssh/config",
      },
      -- Custom arguments for better stability
      sshfs_args = {
        "-o reconnect",
        "-o ConnectTimeout=5",
        "-o CheckHostIP=no",
      },
    },
    mounts = {
      base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
      unmount_on_exit = true,
    },
    handlers = {
      on_connect = {
        change_dir = true, -- Auto-CD into the remote project
      },
      on_disconnect = {
        clean_mount_folders = true, -- Keep your ~/.sshfs/ folder tidy
      },
    },
    ui = {
      confirm = {
        connect = false, -- NO more "y/n" prompts!
        change_dir = false, -- Just do it automatically
      },
    },
  },
  config = function(_, opts)
    require("remote-sshfs").setup(opts)
    require("telescope").load_extension("remote-sshfs")

    local api = require("remote-sshfs.api")
    local connections = require("remote-sshfs.connections")
    local builtin = require("telescope.builtin")

    -- --- SMART KEYBINDS ---
    -- If connected to a node, <leader>ff searches remote files.
    -- If not connected, it searches your local files.

    vim.keymap.set("n", "<leader>rc", api.connect, { desc = "Remote: Connect" })
    vim.keymap.set("n", "<leader>rd", api.disconnect, { desc = "Remote: Disconnect" })
    vim.keymap.set("n", "<leader>re", api.edit, { desc = "Remote: Edit Config" })

    -- Find Files (Smart)
    vim.keymap.set("n", "<leader>ff", function()
      if connections.is_connected() then
        api.find_files()
      else
        builtin.find_files()
      end
    end, { desc = "Find Files (Remote/Local)" })

    -- Live Grep (Smart)
    vim.keymap.set("n", "<leader>fg", function()
      if connections.is_connected() then
        api.live_grep()
      else
        builtin.live_grep()
      end
    end, { desc = "Live Grep (Remote/Local)" })
  end,
}
