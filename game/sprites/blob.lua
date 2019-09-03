--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:75384ed434fccf4272149ca99c9ea0c9:a3f9292c6e07dead3f85f53e221b79d1:89e2aed1b7b7c496e4cca688c27d0ad4$
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
            -- blob1
            x=1,
            y=1,
            width=22,
            height=16,

            sourceX = 19,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob2
            x=25,
            y=1,
            width=24,
            height=16,

            sourceX = 17,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob3
            x=51,
            y=1,
            width=24,
            height=14,

            sourceX = 18,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob4
            x=77,
            y=1,
            width=26,
            height=14,

            sourceX = 16,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob5
            x=105,
            y=1,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob6
            x=129,
            y=1,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob7
            x=153,
            y=1,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob8
            x=177,
            y=1,
            width=24,
            height=16,

            sourceX = 18,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob9
            x=203,
            y=1,
            width=24,
            height=14,

            sourceX = 18,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob10
            x=229,
            y=1,
            width=24,
            height=14,

            sourceX = 18,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
    },
    
    sheetContentWidth = 254,
    sheetContentHeight = 18
}

SheetInfo.frameIndex =
{

    ["blob1"] = 1,
    ["blob2"] = 2,
    ["blob3"] = 3,
    ["blob4"] = 4,
    ["blob5"] = 5,
    ["blob6"] = 6,
    ["blob7"] = 7,
    ["blob8"] = 8,
    ["blob9"] = 9,
    ["blob10"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
