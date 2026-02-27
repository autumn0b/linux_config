"dawn = {
"		_nc = "#f8f0e7",
"		base = "#faf4ed",
"		surface = "#fffaf3",
"		overlay = "#f2e9e1",
"		muted = "#9893a5",
"		subtle = "#797593",
"		text = "#464261",
"		love = "#b4637a",
"		gold = "#ea9d34",
"		rose = "#d7827e",
"		pine = "#286983",
"		foam = "#56949f",
"		iris = "#907aa9",
"		leaf = "#6d8f89",
"		highlight_low = "#f4ede8",
"		highlight_med = "#dfdad9",
"		highlight_high = "#cecacd",
"		none = "NONE",
"	},
set background=light
colorscheme rose-pine-dawn

hi clear
if exists("syntax_on")
	syntax reset
endif
let colors_name = "petl"

set t_Co=256,

-- highlight Normal guibg=none
-- highlight Normal guibg=clear
-- highlight NonText guibg=none
-- highlight NormalFloat guibg=none
-- highlight FloatShadow guibg=none
-- highlight FloatShadowThrough guibg=none
-- 
-- highlight vimHighlight gui=bold
-- 
-- highlight cStatement gui=bold
-- 
-- highlight Comment gui=italic guifg=#317256
