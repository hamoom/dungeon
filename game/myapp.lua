local h = require('lib.helper')
local MyApp = {}

MyApp.dt = 0
MyApp.paused = false
MyApp.timers = {}
MyApp.map = nil
MyApp.currentLevel = 3

MyApp.enterFrameFunctions = nil

function MyApp.cancelTimer(t)
  timer.cancel(t)
  table.remove(MyApp.timers, t.id)
end

function MyApp.cancelAllTimers()
  for _, v in pairs(MyApp.timers) do
    timer.cancel(v)
  end
  MyApp.timers = {}
end

function MyApp.addTimer(delay, fn, iterations)
  local thisTimer = timer.performWithDelay(delay, function(event)
    fn()
    for k, v in pairs(MyApp.timers) do
      if v == event.source then
        table.remove(MyApp.timers, k)
      else
        k = k + 1
      end
    end
  end, iterations or 1)

  local id = #MyApp.timers + 1

  thisTimer.id = id
  MyApp.timers[id] = thisTimer

  return thisTimer
end

function MyApp.pause()
  if not MyApp.paused then

    MyApp.paused = true
    -- audio.pause(1)
    -- audio.setVolume(0)
    physics.pause()

    for _, v in pairs(MyApp.timers) do
      timer.pause(v)
    end
    transition.pause()
  else
    MyApp.paused = false
    -- audio.resume(1)
    -- audio.setVolume(1)
    physics.start()
    for _, v in pairs(MyApp.timers) do
      timer.resume(v)
    end
    transition.resume()
  end
end

function MyApp._enterFrame()
  if MyApp.paused then do return end end
  if MyApp.enterFrameFunctions then
    for i = 1, #MyApp.enterFrameFunctions do
      if MyApp.enterFrameFunctions[i] then MyApp.enterFrameFunctions[i]() end
    end
  end
end

function MyApp.eachFrame(fn)
  if not MyApp.enterFrameFunctions then
    MyApp.enterFrameFunctions = {}
    Runtime:addEventListener("enterFrame", MyApp._enterFrame)
  end
  table.insert(MyApp.enterFrameFunctions, fn)
end

function MyApp.eachFrameRemove(fn)
  local ind = table.indexOf(MyApp.enterFrameFunctions, fn)
  if ind then
    table.remove(MyApp.enterFrameFunctions, ind)
    if #MyApp.enterFrameFunctions == 0 then
      Runtime:removeEventListener("enterFrame", MyApp._enterFrame)
      MyApp.enterFrameFunctions = nil
    end
  end
end

function MyApp.eachFrameRemoveAll()
  Runtime:removeEventListener("enterFrame", MyApp._enterFrame)
  MyApp.enterFrameFunctions = nil
end

return MyApp
