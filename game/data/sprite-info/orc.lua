local sheetInfo = require('sprites.orc')
local myImageSheet = graphics.newImageSheet('sprites/orc.png', sheetInfo:getSheet())
local sequenceData = {
  { name='running-f', frames={ 1,2,3 }, time=400 },
  { name='running-f-chasing', frames={ 1,2,3 }, time=300 },
  { name='running-s', frames={ 4,5,6 }, time=400 },
  { name='running-s-chasing', frames={ 4,5,6 }, time=300 },
  { name='running-b', frames={ 7,8,9 }, time=400 },
  { name='running-b-chasing', frames={ 7,8,9 }, time=300 },
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
