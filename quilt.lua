local quilt = {}

function quilt.init()
  quilt.threads = {}
  quilt.delays = {}
end

function quilt.add(thread, ...)
  if not thread then return end
  quilt.threads[thread] = type(thread) == 'thread' and thread or coroutine.create(thread)
  quilt.delays[thread] = 0
  return thread, quilt.add(...)
end

function quilt.remove(thread, ...)
  if not thread then return end
  quilt.threads[thread] = nil
  quilt.delays[thread] = nil
  return quilt.remove(...)
end

function quilt.resume(thread, ...)
  if not thread then return end
  quilt.delays[thread] = 0
  return quilt.resume(...)
end

function quilt.update(dt)
  for thread, cr in pairs(quilt.threads) do
    if quilt.delays[thread] <= dt then
      local _, delay = coroutine.resume(cr)
      if coroutine.status(cr) == 'dead' then
        quilt.remove(thread)
        if type(delay) == 'function' or type(delay) == 'thread' then
          quilt.add(delay)
        end
      else
        quilt.delays[thread] = type(delay) == 'number' and delay or 0
      end
    else
      quilt.delays[thread] = quilt.delays[thread] - dt
    end
  end
end

return quilt
