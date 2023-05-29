# Signal for Playdate

[![Lua Version](https://img.shields.io/badge/Lua-5.4-yellowgreen)](https://lua.org) [![Toybox Compatible](https://img.shields.io/badge/toybox.py-compatible-brightgreen)](https://toyboxpy.io) [![Latest Version](https://img.shields.io/github/v/tag/DidierMalenfant/signal)](https://github.com/DidierMalenfant/signal/tags)

**Signal** is a **Lua** class for subscribing to keys and notifying subscribers of that key by [Dustin Mierau](https://github.com/mierau).

You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add Signal
toybox update
```

Then, if your code is in the `source` folder, just import the following:

```lua
import '../toyboxes/toyboxes.lua'
```

This **toybox** contains **Lua** toys for you to play with.

---

In this example we create a global instance of Signal, subscribe to a key, and notify against that key elsewhere. Notice that all of the values passed to Signal:notify are passed on to the subscribed functions.
```
-- ... creating a global variable in main ...
NotificationCenter = Signal()

-- ... in code that needs to know when score has changed ...
NotificationCenter:subscribe("game_score", self, function(new_score, score_delta)
   self:update_score(new_score)
end)

-- ... in code that changes the score ...
NotificationCenter:notify("game_score", new_score, score_delta)
```
