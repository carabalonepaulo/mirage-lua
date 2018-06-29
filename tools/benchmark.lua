-- Benchmarking support.
do
  local function runbenchmark(name, code, count, ob)
    local f = loadstring([[
        local count,ob = ...
        local clock = os.clock
        local start = clock()
        for i=1,count do ]] .. code .. [[ end
        return clock() - start
    ]])
    io.write(f(count, ob), "\t", name, "\n")    
  end

  local nameof = {}
  local codeof = {}
  local tests  = {}
  function addbenchmark(name, code, ob)
    nameof[ob] = name
    codeof[ob] = code
    tests[#tests+1] = ob
  end
  function runbenchmarks(count)
    for _,ob in ipairs(tests) do
      runbenchmark(nameof[ob], codeof[ob], count, ob)
    end
  end
end

return runbenchmarks