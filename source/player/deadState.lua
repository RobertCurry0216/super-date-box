class("DeadState").extends(BaseState)

function DeadState:init(actor)
  DeadState.super.init(self, actor, _image_player_die)
end

function DeadState:onenter(...)
  DeadState.super.onenter(self, ...)
  self.actor.dx = 0
  self.actor.dy = 0
end

function DeadState:update()
  DeadState.super.update(self)
  if playdate.buttonJustPressed(playdate.kButtonB) then
    Signal:dispatch("restart_level")
  end
end
