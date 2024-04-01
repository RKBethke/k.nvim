# k.nvim

A [k](<https://en.wikipedia.org/wiki/K_(programming_language)>) repl for Neovim.

## Features

- Buffer and visual selection evaluation
- Customizable output window

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

<!-- setup:start -->

```lua
{
	"RKBethke/k.nvim",
	ft = "k",
	keys = {
		{
			"<CR>",
			mode = { "n", "x", "o" },
			function()
				require("k").eval()
			end,
			desc = "Evaluate k buffer",
		},
		{
			"<CR>",
			mode = { "v" },
			function()
				require("k").eval_selection()
			end,
			desc = "Evaluate selected k lines",
		},
		{
			"<M-L>",
			mode = { "i", "n", "x", "o", "v" },
			function()
				require("k").outbuf_clear()
			end,
			desc = "Clear k output buffer",
		},
		{
			"<M-CR>",
			mode = { "n", "x", "o", "v" },
			function()
				require("k").outbuf_toggle()
			end,
			desc = "Show/hide the output buffer",
		},
	},
	opts = {},
}
```

<!-- setup:end -->

## Configuration

<!-- config:start -->

Default Settings

```lua
{
    -- Path to the k executable.
    path = "k",
    -- Clear output after every evaluation.
    overwrite = false,
	outbuf = {
        -- Display output in a floating window.
        float = false,
        -- Map defining the floating window configuration. See `:h nvim_open_win`
        -- Values may be functions which are evaluated at window open.
		float_opts = {
			relative = "editor",
			anchor = "NE",
			row = 0,
			col = function()
				return vim.o.columns
			end,
			width = 64,
			height = function()
				return vim.fn.winheight(0)
			end,
			border = "single",
			style = "minimal",
		},
    },
}
```

<!-- config:end -->

## Syntax Highlighting

Syntax, indent, and filetype support for k can be found in the
[ngn/k](https://codeberg.org/ngn/k/src/branch/master/vim-k) repository.
