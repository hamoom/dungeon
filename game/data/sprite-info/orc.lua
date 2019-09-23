local sheetInfo = require('sprites.orc')
local myImageSheet = graphics.newImageSheet('sprites/orc.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'running-f', start = 1, count = 3, time = 400},
  {name = 'running-f-chasing', start = 1, count = 3, time = 300},
  {name = 'attacking-f', start = 4, count = 5, time = 300, loopCount = 1},
  {name = 'running-s', start = 9, count = 3, time = 400},
  {name = 'running-s-chasing', start = 9, count = 3, time = 300},
  {name = 'attacking-s', start = 13, count = 5, time = 300, loopCount = 1},
  {name = 'running-b', start = 18, count = 3, time = 400},
  {name = 'running-b-chasing', start = 18, count = 3, time = 300},
  {name = 'attacking-b', start = 21, count = 5, time = 300, loopCount = 1},
  {name = 'death', start = 26, count = 5, time = 800, loopCount = 1},
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
