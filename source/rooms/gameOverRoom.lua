local gfx <const> = playdate.graphics

local bold_font <const> = gfx.getFont(gfx.font.kVariantBold)
local bold_size <const> = bold_font:getHeight()
local small_size <const> = small_font:getHeight()

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
  if playdate.buttonJustReleased("a") then
    manager:enter(GameRoom())
  elseif playdate.buttonJustReleased("b") then
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
  local img <const> = gfx.image.new(400, 240)
  local heading = "YOU DIED"
  if pos then
    heading = "#"..tostring(pos).." HIGH SCORE"
  end

  gfx.pushContext(img)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    -- heading
    local w = bold_font:getTextWidth(heading)+20
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRoundRect(200-w/2, 58, w, bold_size, 2)
    bold_font:drawTextAligned(heading, 200, 60, kTextAlignment.center)

    --subheading
    local subheading = tostring(score).."  CRATE"..(score == 1 and "" or "S")
    w = bold_font:getTextWidth(subheading)+20
    gfx.fillRoundRect(200-w/2, 88, w, bold_size, 2)
    bold_font:drawTextAligned(subheading, 200, 90, kTextAlignment.center)

    -- lower text
    local text_a = "A - PLAY AGAIN"
    w = small_font:getTextWidth(text_a)+20
    gfx.fillRoundRect(200-w/2, 120, w, small_size, 2)
    small_font:drawTextAligned(text_a, 200, 120, kTextAlignment.center)

    local text_b = "B - EXIT"
    w = small_font:getTextWidth(text_b)+20
    gfx.fillRoundRect(200-w/2, 140, w, small_size, 2)
    small_font:drawTextAligned(text_b, 200, 140, kTextAlignment.center)

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