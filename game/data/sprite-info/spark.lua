local sheetInfo = require('sprites.spark')
local myImageSheet = graphics.newImageSheet('sprites/spark.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'spark', frames = {1, 2, 3, 4}, time = 250, loopCount= 1},
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
