local sheetInfo = require('sprites.orc')
local myImageSheet = graphics.newImageSheet('sprites/orc.png', sheetInfo:getSheet())
local sequenceData = {
  { name='running-f', frames={ 1,2,3 }, time=500 },
  { name='running-f-chasing', frames={ 1,2,3 }, time=200 },
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
