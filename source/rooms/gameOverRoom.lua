local gfx <const> = playdate.graphics

local bold_font <const> = gfx.getFont(gfx.font.kVariantBold)
local bold_spacing <const> = bold_font:getHeight() + 3
local small_spacing <const> = small_font:getHeight() + 3

class("GameOverRoom").extends(PauseRoom)

function GameOverRoom:enter(_, score)
  GameOverRoom.super.enter(self)
  local data = playdate.datastore.read()
  local pos, data = self:updateHighScores(score, data)
  self:createSprite(pos, score)
  self._enter = playdate.getCurrentTimeMilliseconds()
end

function GameOverRoom:update()
  local time = playdate.getCurrentTimeMilliseconds()
  if time - self._enter < 500 then return end
  if playdate.buttonJustPressed("a") then
    manager:enter(GameRoom())
  elseif playdate.buttonJustPressed("b") then
    manager:pop()
  end
end

function GameOverRoom:updateHighScores(score, data)
  for i=1, 10 do
    if score > data.highscores[i] then
      table.insert(data.highscores, i, score)
      table.remove(data.highscores)
      playdate.datastore.write(data)
      return i, data
    end
  end
  return nil, data
end

function GameOverRoom:createSprite(pos, score)
  local img <const> = gfx.image.new(400, 240, gfx.kColorBlack)
  local heading = "YOU DIED"
  if pos then
    heading = "HIGH SCORE"
  end

  gfx.pushContext(img)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    bold_font:drawTextAligned(heading, 200, 30, kTextAlignment.center)
    local prefix = pos and tostring(pos)..". " or " . "
    local score = tostring(score)
    small_font:drawTextAligned(prefix..score, 200, 60, kTextAlignment.center)

    small_font:drawTextAligned("A - PLAY AGAIN", 200, 160, kTextAlignment.center)
    small_font:drawTextAligned("B - EXIT", 200, 160+small_spacing, kTextAlignment.center)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.popContext()


  local spr = gfx.sprite.new(img)
  spr:setIgnoresDrawOffset(true)
  spr:setUpdatesEnabled(false)
  spr:setCenter(0,0)
  spr:moveTo(0,0)
  spr:setZIndex(ZIndex.ui)
  spr:add()
end