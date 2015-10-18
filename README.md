Quilt
===

Quilt is a simple coroutine scheduler which lets many threads run simultaneously.
Threads can be easily started, stopped, paused, or delayed by a time period.
In games this will generally simplify code involving timers, state machines, or AI.

Example
---

```lua
local quilt = require 'quilt'

function love.load()
  quilt.init()

  thread = quilt.add(function()
    while true do
      print('printing a message every second until the spacebar is pressed...')
      coroutine.yield(1)
    end
  end)
end

function love.update(dt)
  quilt.update(dt)
end

function love.keypressed(key)
  if key == ' ' then
    quilt.remove(thread)
  end
end
```

Documentation
---

A thread is just a function.
Internally, quilt will convert this into a coroutine.
Within a thread you can call `coroutine.yield` to give control back to other parts of your program.
A number can optionally be passed to `coroutine.yield`.
In this case, quilt will wait this many seconds before resuming the thread.
If the return value of a thread is another thread, quilt will resume this thread after the first one completes.

### `quilt.init()`

Initializes quilt.

### `quilt.update(dt)`

Should be called on update with the delta time of the current frame.

### `quilt.add(thread, ...)`

Starts the specified threads and returns them.

### `quilt.remove(thread, ...)`

Stops the specified threads.

### `quilt.resume(thread, ...)`

Immediately resumes the specified threads.

License
---

MIT, see [`LICENSE`](LICENSE) for details.
