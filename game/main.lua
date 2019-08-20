_G.m = require("myapp")
_G.p = require('lib.point')
_G.h = require('lib.helper')


-- display.setDefault("magTextureFilter", "nearest")
-- display.setDefault("minTextureFilter", "nearest")
system.activate('multitouch')
display.setStatusBar(display.HiddenStatusBar)

-- include the Corona "composer" module
local composer = require('composer')

-- load menu screen
composer.gotoScene('game')
