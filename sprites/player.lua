--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ec4a8e7161ee767f796dfc6aeaa07958:d7123193364aa30cc6b8a94e4603fcc5:b2f580ea7c37465eac371f095cbaf8c7$
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
            -- player1
            x=1,
            y=1,
            width=28,
            height=38,

        },
        {
            -- player2
            x=1,
            y=41,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player3
            x=1,
            y=79,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player4
            x=1,
            y=117,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player5
            x=1,
            y=155,
            width=28,
            height=38,

        },
        {
            -- player6
            x=1,
            y=195,
            width=28,
            height=38,

        },
        {
            -- player7
            x=1,
            y=235,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player8
            x=1,
            y=273,
            width=28,
            height=38,

        },
        {
            -- player9
            x=1,
            y=313,
            width=28,
            height=38,

        },
        {
            -- player10
            x=1,
            y=353,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player11
            x=1,
            y=391,
            width=28,
            height=38,

        },
        {
            -- player12
            x=1,
            y=431,
            width=28,
            height=38,

        },
        {
            -- player13
            x=1,
            y=471,
            width=28,
            height=36,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 28,
            sourceHeight = 38
        },
        {
            -- player14
            x=1,
            y=509,
            width=28,
            height=38,

        },
        {
            -- player15
            x=1,
            y=549,
            width=28,
            height=38,

        },
        {
            -- player16
            x=1,
            y=589,
            width=28,
            height=38,

        },
    },
    
    sheetContentWidth = 30,
    sheetContentHeight = 628
}

SheetInfo.frameIndex =
{

    ["player1"] = 1,
    ["player2"] = 2,
    ["player3"] = 3,
    ["player4"] = 4,
    ["player5"] = 5,
    ["player6"] = 6,
    ["player7"] = 7,
    ["player8"] = 8,
    ["player9"] = 9,
    ["player10"] = 10,
    ["player11"] = 11,
    ["player12"] = 12,
    ["player13"] = 13,
    ["player14"] = 14,
    ["player15"] = 15,
    ["player16"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
