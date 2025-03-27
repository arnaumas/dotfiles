superduper = hs.hotkey.modal.new({}, nil)
superduper.pressed = function() superduper:enter() end
superduper.released = function() superduper:exit() end
hs.hotkey.bind({}, 'F19', superduper.pressed, superduper.released)

-- vim navigation bindings
superduperMotions = {
	{ 'j', 'down' },
	{ 'k', 'up' },
	{ 'h', 'left' },
	{ 'l', 'right' },
}

for i, mapping in ipairs(superduperMotions) do
	local key = mapping[1]
	local motion = mapping[2]
	keyDown = hs.eventtap.event.newKeyEvent({}, motion, true)
	keyUp = hs.eventtap.event.newKeyEvent({}, motion, false)
	superduper:bind({}, key, function()
		hs.eventtap.event.newKeyEvent({}, motion, true):post()
	end,
	function()
		hs.eventtap.event.newKeyEvent({}, motion, false):post()
	end, nil)
end
