local sheetInfo = require('sprites.player')
local myImageSheet = graphics.newImageSheet('sprites/player.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'stopped-f', start = 1, count = 8, time = 2000},
  {name = 'stopped-b', start = 9, count = 7, time = 1000},
  {name = 'stopped-s', start = 23, count = 7, time = 1000},
  {name = 'running-f', start = 20, count = 3, time = 300},
  {name = 'running-b', start = 17, count = 3, time = 300},
  {name = 'running-s', start = 31, count = 3, time = 300},
  {name = 'attacking-f', start = 35, count = 4, time = 300, loopCount = 1},
  {name = 'attacking-s', start = 40, count = 4, time = 200, loopCount = 1},
  {name = 'attacking-b', start = 45, count = 4, time = 250, loopCount = 1},
  {name = 'death', start = 50, count = 9, time = 800, loopCount = 1}
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
