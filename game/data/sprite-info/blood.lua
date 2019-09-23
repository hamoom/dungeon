local sheetInfo = require('sprites.blood')
local myImageSheet = graphics.newImageSheet('sprites/blood.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'blood', frames = {1, 2, 3}, time = 600, loopCount= 1},
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
