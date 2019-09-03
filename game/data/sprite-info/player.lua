local sheetInfo = require('sprites.player')
local myImageSheet = graphics.newImageSheet('sprites/player.png', sheetInfo:getSheet())
local sequenceData = {
  { name='stopped-f', frames={ 1,2,1,2,1,2,3 }, time=2000 },
  { name='stopped-b', frames={ 4,5 }, time=1000 },
  { name='stopped-s', frames={ 12,13 }, time=1000 },
  { name='running-f', frames={ 9,10,11 }, time=300 },
  { name='running-b', frames={ 6,7,8 }, time=300 },
  { name='running-s', frames={ 14,15,16 }, time=300 },
  { name='attacking-f', frames={ 17,18,19,20,21 }, time=300, loopCount=1 },
  { name='attacking-s', frames={ 22,23,24 }, time=200, loopCount=1 },
  { name='attacking-b', frames={ 25,26,27,28 }, time=250, loopCount=1 },
  { name='death', frames={ 29,29,30,30,31,32,33,34,35,35,36,36,37 }, time=800, loopCount=1 },
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
