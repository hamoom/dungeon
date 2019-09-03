--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b7ed44e96c2307a9bbbc049d2adb6dda:967d72c6cda0596c868361cd1a74904a:081054e524172d87a1f61a8d13ca77d3$
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
            -- orc1
            x=1,
            y=1,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc2
            x=29,
            y=1,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc3
            x=57,
            y=1,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc4
            x=85,
            y=1,
            width=22,
            height=42,

            sourceX = 16,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc5
            x=109,
            y=1,
            width=22,
            height=42,

            sourceX = 17,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc6
            x=133,
            y=1,
            width=22,
            height=42,

            sourceX = 16,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc7
            x=157,
            y=1,
            width=26,
            height=38,

            sourceX = 17,
            sourceY = 8,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc8
            x=185,
            y=1,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc9
            x=213,
            y=1,
            width=26,
            height=38,

            sourceX = 16,
            sourceY = 8,
            sourceWidth = 60,
            sourceHeight = 66
        },
    },
    
    sheetContentWidth = 240,
    sheetContentHeight = 44
}

SheetInfo.frameIndex =
{

    ["orc1"] = 1,
    ["orc2"] = 2,
    ["orc3"] = 3,
    ["orc4"] = 4,
    ["orc5"] = 5,
    ["orc6"] = 6,
    ["orc7"] = 7,
    ["orc8"] = 8,
    ["orc9"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
