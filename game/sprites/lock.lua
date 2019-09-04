--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2a564687c93a2f087b0ecfcf39b6e783:b3503e79a001e79d0bd5b0972e073587:ecbd50231aad74c9202f815602bd0682$
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
            -- lock1
            x=0,
            y=0,
            width=22,
            height=26,

            sourceX = 14,
            sourceY = 4,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock2
            x=22,
            y=0,
            width=22,
            height=30,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock3
            x=44,
            y=0,
            width=22,
            height=30,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock4
            x=66,
            y=0,
            width=22,
            height=30,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock5
            x=88,
            y=0,
            width=22,
            height=30,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock6
            x=110,
            y=0,
            width=22,
            height=30,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock7
            x=132,
            y=0,
            width=26,
            height=30,

            sourceX = 13,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock8
            x=158,
            y=0,
            width=28,
            height=30,

            sourceX = 13,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
        {
            -- lock9
            x=186,
            y=0,
            width=30,
            height=30,

            sourceX = 13,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 30
        },
    },
    
    sheetContentWidth = 216,
    sheetContentHeight = 30
}

SheetInfo.frameIndex =
{

    ["lock1"] = 1,
    ["lock2"] = 2,
    ["lock3"] = 3,
    ["lock4"] = 4,
    ["lock5"] = 5,
    ["lock6"] = 6,
    ["lock7"] = 7,
    ["lock8"] = 8,
    ["lock9"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
