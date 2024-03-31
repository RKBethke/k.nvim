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
    postwin = {
        -- Display output in a floating window.
        float = true,
    },
}
```

<!-- config:end -->

## Syntax Highlighting

Syntax, indent, and filetype support for k can be found in the [ngn/k](https://codeberg.org/ngn/k)
repository.
