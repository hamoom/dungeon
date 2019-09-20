local sheetInfo = require('sprites.torch')
local myImageSheet = graphics.newImageSheet('sprites/torch.png', sheetInfo:getSheet())
local sequenceData = {
  {name = 'burn', frames = {1, 2, 3}, time = 200},
}

return {
  imageSheet = myImageSheet,
  sequenceData = sequenceData
}
