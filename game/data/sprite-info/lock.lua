local sheetInfo = require('sprites.lock')
local myImageSheet = graphics.newImageSheet('sprites/lock.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'open', start = 1, count = 9, time = 800, loopCount = 1}
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
