local sheetInfo = require('sprites.blob')
local myImageSheet = graphics.newImageSheet('sprites/blob.png', sheetInfo:getSheet())
local sequenceData = {
  { name='wandering', frames={ 1,2,3,4 }, time=600 },
  { name='attacking', frames={ 1,2,3,4 }, time=300, loopCount=1 },
  { name='charging', frames={ 5,6 }, time=200, loopCount=6 },
  { name='death', frames={ 7,8,9,10 }, time=1000, loopCount=1 },
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
