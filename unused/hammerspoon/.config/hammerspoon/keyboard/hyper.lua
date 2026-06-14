-- bind F18 to hyper mode
hyper = hs.hotkey.modal.new({}, nil)
hyper.pressed = function() hyper:enter() end
hyper.released = function() hyper:exit() end
hs.hotkey.bind({}, 'F18', hyper.pressed, hyper.released)

-- Hyper mode app launches
hyperModeAppMappings = {
	{ 'a', 'Music' },             -- "A" for "Apple Music"
	{ 'b', 'Safari' },            -- "B" for "Browser"
	{ 'f', 'Finder' },            -- "F" for "Finder"
	{ 't', 'iTerm' },             -- "T" for "Terminal"
}

for i, mapping in ipairs(hyperModeAppMappings) do
  local key = mapping[1]
  local app = mapping[2]
  hyper:bind({}, key, function()
    if (type(app) == 'string') then
      hs.application.open(app)
    elseif (type(app) == 'function') then
      app()
		end
  end)
end

-- other bindings
hyper:bind({}, 'r', function()
  hs.reload()
end)

