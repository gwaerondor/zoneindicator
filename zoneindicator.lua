_addon.name = 'zoneindicator'
_addon.author = 'gwaeron'
_addon.version = '0.0.1'
_addon.language = 'English'
_addon.command = 'zonename'
_addon.commands = {'zoneindicator', 'zi'}

config = require('config')
texts = require('texts')
resources = require('resources')

local debug = false

defaults = {}
defaults.zone = {}
defaults.zone.pos = {}
defaults.zone.pos.x = 100
defaults.zone.pos.y = 100
defaults.zone.bg = {}
defaults.zone.bg.alpha = 0
defaults.zone.bg.visible = false
defaults.zone.text = {}
defaults.zone.text.size = 20
defaults.zone.text.font = "Arial"
defaults.zone.text.alpha = 255
defaults.zone.text.red = 255
defaults.zone.text.green = 255
defaults.zone.text.blue = 200
defaults.zone.text.stroke = {}
defaults.zone.text.stroke.width = 3
defaults.zone.text.stroke.alpha = 0
defaults.zone.text.stroke.red = 0
defaults.zone.text.stroke.green = 0
defaults.zone.text.stroke.blue = 0
defaults.zone.text.visible = true
defaults.hidden = false

local settings = config.load(defaults)
config.save(settings)
settings.zone.text.draggable = true
local zoneText = texts.new(settings.zone)

zoneText:text("")

show = function()
   zoneText:show()
   settings.draggable = true
   settings:save()
end

hide = function()
   zoneText:hide()
   settings.draggable = false
   settings:save()
end

toggleDebug = function() debug = not debug end
commandEvent = function(command)
   if command == "show" then
      debugLog("Displaying zone name")
      show()
   elseif command == "hide" then
      debugLog("Hiding zone name")
      hide()
   elseif command == "debug" then
      toggleDebug()
      putLog("Debug mode " .. boolToToggle(debug))
   else
      putLog("Unknown command: " .. command ..
                ", I only know about show, hide, debug")
   end
end

function boolToToggle(b)
   if b then return "on" else return "off" end
end

function updateText()
   local info = windower.ffxi.get_info()
   local zoneId = info.zone
   local zoneName = resources.zones[zoneId].en
   zoneName = replaceAbbreviations(zoneName)
   zoneText:text(zoneName)
end

local LOGIN_ZONE_PACKET = 0x0A
loginEvent = function(id, _, _, _, _)
   if(id == LOGIN_ZONE_PACKET) then updateText() end
end

function replaceAbbreviations(zone)
   zone = string.gsub(zone, "%[S]", "(Shadowreign)")
   zone = string.gsub(zone, "%[U]", "(Otherworldly)")
   return string.gsub(zone, "%[D]", "(Divergence)")
end

loadEvent = function()
   updateText()
   if not hidden then show() end
end

RELEASE_LEFT_BUTTON_TYPE = 2
SCROLL_TYPE = 10
mouseEvent = function(type, x, y, scrollDelta, blocked)
   if type == RELEASE_LEFT_BUTTON_TYPE then
      settings.zone.pos.x = zoneText:pos_x()
      settings.zone.pos.y = zoneText:pos_y()
      settings:save()
      debugLog("Saved new position (" .. settings.zone.pos.x .. ", " .. settings.zone.pos.y .. ")")
   elseif type == SCROLL_TYPE then
      if zoneText:hover(x, y) then
         local updatedSize = math.max(5, settings.zone.text.size + scrollDelta)
         settings.zone.text.size = updatedSize
         settings:save()
         zoneText:size(updatedSize)
         debugLog("Font size changed to " .. updatedSize)
      end
   end
end

windower.register_event("addon command", commandEvent)
windower.register_event("incoming chunk", loginEvent)
windower.register_event("load", loadEvent)
windower.register_event("mouse", mouseEvent)

function putLog(message)
   windower.add_to_chat("8", "Zone Indicator: " .. message)
end

function debugLog(message)
   if debug then putLog(message) end
end
