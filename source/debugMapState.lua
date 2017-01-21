vector = require "hump.vector"
DepthMap = require "seaDepthMap"
Rudder = require "rudder"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"
Rendering = require "rendering.rendering"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

ship = Ship.new()
radar = Radar.new()
local rudderGauge = Gauge(vector(1920 - 200, 100), 100, 0.5)
local rollGauge = Gauge(vector(0, 300), 150)
local pitchGauge = Gauge(vector(0, 200), 100)
local rudder = Rudder(0,0)

function debugMapState:enter()
    Sounds.ambient:play()
    DepthMap:debugDrawUpdate(0, 0, canvas_w, canvas_h)
    rudder:init(canvas_w/2, canvas_h*0.82)
    pitchGauge.pos = vector(canvas_w/8, canvas_h*0.82)
    rollGauge.pos = vector(canvas_w*2/8, canvas_h*0.82)
end

function debugMapState.draw()
    love.graphics.scale(1, 1)

    radar:prerender()

    Rendering.scale()

    -- Draws the map covering the entire window
    DepthMap:debugDraw()

    -- draw Ship location
    ship:draw()

    -- draw the radar
    radar:draw()
    rudderGauge:draw()
    rollGauge:draw()
    pitchGauge:draw()
    rudder:draw()

    -- draw Goal location
end

function debugMapState.update(self, dt)
    -- Draws the map covering the entire window
    radar:update(dt, ship)
    rudder:update(dt)
    ship.turnspeed = ship.maxturnspeed * (rudder.angle / rudder.maxangle)
    ship:update(dt)
    
    rollGauge.val = ship:getRoll()
    pitchGauge.val = ship:getPitch()

    rollGauge:update(dt)
    pitchGauge:update(dt)

    rudderGauge.val = (ship.turnspeed * 5) + 0.5
    rudderGauge:update(dt)

    Sounds.misc:update(dt)
end

function debugMapState:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
    end
end

return debugMapState
