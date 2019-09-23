--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:05aaadb4dcc8401297e0124139edd710:cd606ad60fd783315e65abfd4119fabc:79f473df54eccae23aed645bc4192b15$
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
            -- spark1
            x=83,
            y=1,
            width=18,
            height=18,

            sourceX = 5,
            sourceY = 7,
            sourceWidth = 28,
            sourceHeight = 28
        },
        {
            -- spark2
            x=59,
            y=1,
            width=22,
            height=22,

            sourceX = 3,
            sourceY = 5,
            sourceWidth = 28,
            sourceHeight = 28
        },
        {
            -- spark3
            x=31,
            y=1,
            width=26,
            height=28,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 28,
            sourceHeight = 28
        },
        {
            -- spark4
            x=1,
            y=1,
            width=28,
            height=28,

        },
    },
    
    sheetContentWidth = 102,
    sheetContentHeight = 30
}

SheetInfo.frameIndex =
{

    ["spark1"] = 1,
    ["spark2"] = 2,
    ["spark3"] = 3,
    ["spark4"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
