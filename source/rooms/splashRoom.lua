local gfx <const> = playdate.graphics

local img <const> = gfx.image.new(400, 240, gfx.kColorBlack)
local bold_font <const> = gfx.getFont(gfx.font.kVariantBold)
local bold_spacing <const> = bold_font:getHeight() + 3
local small_spacing <const> = small_font:getHeight() + 3

-- Draw the splash screen image
gfx.pushContext(img)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  bold_font:drawTextAligned("SUPER", 200, 50, kTextAlignment.center)
  bold_font:drawTextAligned("DATE", 200, 50+bold_spacing, kTextAlignment.center)
  bold_font:drawTextAligned("BOX", 200, 50+bold_spacing*2, kTextAlignment.center)

  small_font:drawTextAligned("A - NEW GAME", 200, 160, kTextAlignment.center)
  small_font:drawTextAligned("B - HIGH SCORES", 200, 160+small_spacing, kTextAlignment.center)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
gfx.popContext()

class("SplashRoom").extends(Room)

function SplashRoom:init()
  SplashRoom.super.init(self)

  -- create the splach screen sprite
  local spr = gfx.sprite.new(img)
  spr:setIgnoresDrawOffset(true)
  spr:setUpdatesEnabled(false)
  spr:setCenter(0,0)
  spr:moveTo(0,0)
  spr:setZIndex(ZIndex.ui)
  spr:add()
end

function SplashRoom:update()
  if playdate.buttonJustReleased("a") then
    manager:push(GameRoom())
  elseif playdate.buttonJustReleased("b") then
    manager:push(HighscoreRoom())
  end
end
