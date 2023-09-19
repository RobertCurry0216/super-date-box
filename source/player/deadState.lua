class("DeadState").extends(BaseState)

function DeadState:init(actor)
  DeadState.super.init(self, actor, _image_player_die)
end

function DeadState:onenter(...)
  DeadState.super.onenter(self, ...)
  self.actor.dx = 0
  self.actor.dy = 0
  playdate.timer.performAfterDelay(2000, function()
    Signal:dispatch("game_over")
  end)
end

