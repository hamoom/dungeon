local sheetInfo = require('sprites.orc')
local myImageSheet = graphics.newImageSheet('sprites/orc.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'running-f', start = 1, count = 3, time = 400},
  {name = 'running-f-chasing', start = 1, count = 3, time = 300},
  {name = 'attacking-f', start = 4, count = 5, time = 300, loopCount = 1},
  {name = 'block-f', start = 9, count = 4, time = 300, loopCount = 1},
  {name = 'running-s', start = 13, count = 3, time = 400},
  {name = 'running-s-chasing', start = 13, count = 3, time = 300},
  {name = 'attacking-s', start = 17, count = 5, time = 300, loopCount = 1},
  {name = 'block-s', start = 22, count = 4, time = 300, loopCount = 1},
  {name = 'running-b', start = 26, count = 3, time = 400},
  {name = 'running-b-chasing', start = 26, count = 3, time = 300},
  {name = 'attacking-b', start = 29, count = 5, time = 300, loopCount = 1},
  {name = 'block-b', start = 34, count = 4, time = 300, loopCount = 1},
  {name = 'death', start = 38, count = 7, time = 800, loopCount = 1},
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
