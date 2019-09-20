--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:958168a59ba8751dfed11b577ba2f186:0f18f97637f64d357628df64ecc13dbc:0cd2e56b2826ccabf498f9136415676c$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- torch1
            x=0,
            y=0,
            width=40,
            height=40,

        },
        {
            -- torch2
            x=40,
            y=0,
            width=40,
            height=40,

        },
        {
            -- torch3
            x=80,
            y=0,
            width=40,
            height=40,

        },
    },
    
    sheetContentWidth = 120,
    sheetContentHeight = 40
}

SheetInfo.frameIndex =
{

    ["torch1"] = 1,
    ["torch2"] = 2,
    ["torch3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
