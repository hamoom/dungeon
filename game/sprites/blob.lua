--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9ffd904ff11d788ed83308c431590b4c:db6b842dd8716347db4e76536f8ee95a:89e2aed1b7b7c496e4cca688c27d0ad4$
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
            x=95,
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
            x=69,
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
            x=93,
            y=19,
            width=24,
            height=14,

            sourceX = 18,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob4
            x=39,
            y=21,
            width=26,
            height=14,

            sourceX = 16,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob5
            x=63,
            y=37,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob6
            x=69,
            y=19,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob7
            x=87,
            y=37,
            width=22,
            height=16,

            sourceX = 20,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob8
            x=37,
            y=37,
            width=24,
            height=16,

            sourceX = 18,
            sourceY = 31,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob9
            x=39,
            y=1,
            width=28,
            height=18,

            sourceX = 16,
            sourceY = 33,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob10
            x=1,
            y=33,
            width=34,
            height=18,

            sourceX = 11,
            sourceY = 34,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- blob11
            x=1,
            y=1,
            width=36,
            height=30,

            sourceX = 10,
            sourceY = 28,
            sourceWidth = 60,
            sourceHeight = 66
        },
    },
    
    sheetContentWidth = 118,
    sheetContentHeight = 54
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
    ["blob11"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
