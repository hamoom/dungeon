local h = require('lib.helper')
local MyApp = {}

MyApp.dt = 0
MyApp.paused = false
MyApp.timers = {}

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


return MyApp
