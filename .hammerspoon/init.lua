local wf=hs.window.filter

local function unbind()
    hs.fnutils.map(hs.hotkey.getHotkeys(), function(hotkey)
        hotkey:delete()
    end)
end

local function keyStroke(mods, key)
    hs.eventtap.keyStroke(mods, key, 1)
end

local function bind()
    hs.hotkey.bind('ctrl', 'p', function() keyStroke('', 'up')    end, nil, function() keyStroke('', 'up')    end)
    hs.hotkey.bind('ctrl', 'n', function() keyStroke('', 'down')  end, nil, function() keyStroke('', 'down')  end)
    hs.hotkey.bind('ctrl', 'b', function() keyStroke('', 'left')  end, nil, function() keyStroke('', 'left')  end)
    hs.hotkey.bind('ctrl', 'f', function() keyStroke('', 'right') end, nil, function() keyStroke('', 'right') end)
end

wf_terminal = wf.new{'Terminal'}
wf_terminal:subscribe(wf.windowFocused,   function() unbind() end)
           :subscribe(wf.windowUnfocused, function() bind()   end)

-- auto reload
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", function() hs.reload() end):start()
hs.alert.show("Config loaded")
