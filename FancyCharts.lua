script_name("FancyCharts")
script_authors("THERION")
script_dependencies("SAMPFUNCS", "mimgui", "encoding")

-- const
local GALAXY_IP = { "176.32.39.200", "176.32.39.199", "176.32.39.198" }
local CFG_PATH = script.this.name .. ".ini"
local CMD = "fcharts"
local BUFFER_SIZE = 32

local DRAW_INFO_CONDITIONAL_JMP = 0x58EE3F
local STAMINA_PTR = 0xB7CDB4
local BREATH_PTR = 0xB7CDE0

local SERVER_LIMITS = {
   food = 7, 
   pills = 5
}
--

-- libs
require("sampfuncs")
local memory = require("memory")
local ffi = require("ffi")
local inicfg = require("inicfg")
local imgui = require("mimgui")
local new = imgui.new
local encoding = require("encoding")

encoding.default = "CP1251"
local u8 = encoding.UTF8
--

-- data
local ini = {}
local font = nil
local win_state = new.bool(false)

---
local galaxy = false
local server = {
   food = 0,
   pills = 0
}
local function parse_textdraws()
   for i = 2049, 2062 do
      if sampTextdrawIsExists(i) then
         local tdx, tdy = sampTextdrawGetPos(i)
         if math.floor(tdy) == 45 then
            server.food = tonumber(sampTextdrawGetString(i))
            sampTextdrawSetPos(i, tdx + 10000, tdy)
            sampTextdrawSetPos(i - 1, tdx + 10000, tdy + 3)
         end
         if math.floor(tdy) == 27 then
            server.pills = tonumber(sampTextdrawGetString(i))
            sampTextdrawSetPos(i, tdx + 10000, tdy)
            sampTextdrawSetPos(i - 1, tdx + 10000, tdy + 3)
         end
      end
   end
end
--

local function copy(value)
   local result = nil
   if type(value) == "table" then
      result = {}
      for k, v in next, value, nil do 
         result[copy(k)] = copy(v)
      end
      setmetatable(result, copy(getmetatable(value)))
   else 
      result = value
   end
   return result
end

local function convert_cfg(tbl, to_x, to_y)
   local res = copy(tbl)
   local font, chart = res.font, res.main

   font.size = to_y(font.size)

   chart.x = to_x(chart.x)
   chart.y = to_y(chart.y)
   chart.indent = to_y(chart.indent)
   chart.width = to_x(chart.width)
   chart.height = to_y(chart.height)
   chart.text_offset = to_y(chart.text_offset)

   return res
end

local function load(tbl, path)
   local res_x, res_y = getScreenResolution()
   local res = inicfg.load(tbl, path)
   res = convert_cfg(res,
      function(v) return v * res_x end, 
      function(v) return v * res_y end
   )
   return res
end

local function save(tbl, path)
   local res_x, res_y = getScreenResolution()
   tbl = convert_cfg(tbl, 
      function(v) return v / res_x end, 
      function(v) return v / res_y end
   )
   inicfg.save(tbl, path)
end

local function join_argb(a, r, g, b)
   local argb = b
   argb = bit.bor(argb, bit.lshift(g, 8))
   argb = bit.bor(argb, bit.lshift(r, 16))
   argb = bit.bor(argb, bit.lshift(a, 24))
   return argb
end

local function split_argb(hex)
   return
      bit.band(bit.rshift(hex, 24), 0xFF),
      bit.band(bit.rshift(hex, 16), 0xFF),
      bit.band(bit.rshift(hex, 8), 0xFF),
      bit.band(hex, 0xFF)
end

local function sync_color_with_samp(r, g, b)
   ini.main_colors.health[0] = join_argb(bit.band(bit.rshift(ini.main_colors.health[0], 24), 0xFF), r, g, b)
   ini.bg_colors.health[0] = join_argb(bit.band(bit.rshift(ini.bg_colors.health[0], 24), 0xFF), r / 4, g / 4, b / 4)
end

local function update_color()
   local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
   local _, r, g, b = split_argb(sampGetPlayerColor(id))
   sync_color_with_samp(r, g, b)
end

local function lim(val, max)
	if val < 0 then return 0 end
	if val > max then return max end
	return val
end

local function draw_bar(x, y, width, info_type, get_data)
   local text, k = get_data(arg)
   text = tostring(text)
   local height = ini.main.height[0]
   renderDrawBoxWithBorder(x, y, width, height, ini.bg_colors[info_type][0], ini.main.border[0], ini.main_colors.border[0])
   renderDrawBox(x + ini.main.border[0], y + ini.main.border[0], width * k - ini.main.border[0] * 2, height - 2 * ini.main.border[0], ini.main_colors[info_type][0])
   renderFontDrawText(font, text, x + width / 2 - renderGetFontDrawTextLength(font, text) / 2, y + ini.main.text_offset[0], 0xFFFFFFFF)
end

function main()
   if not doesFileExist(CFG_PATH) then 
      save(ini, CFG_PATH)
   end

   while not isSampAvailable() do wait(0) end

   do -- check if galaxy
      local function includes(array, value)
         for _, element in ipairs(array) do
            if value == element then
               return true
            end
         end
         return false
      end      

      local ip, _ = sampGetCurrentServerAddress()
      galaxy = includes(GALAXY_IP, ip)
   end

   do -- patch player info render
      local bytes = "\xE9\x71\x03\x00\x00\x90"
      memory.copy(DRAW_INFO_CONDITIONAL_JMP, memory.strptr(bytes), #bytes, true)
      -- je -> jmp
   end

   font = renderCreateFont(ini.font.face, ini.font.size, ini.font.flag)

   imgui.to(ini)

   if ini.main.copy_samp_color[0] then 
      update_color() 
   end

   sampRegisterChatCommand(CMD, function()
      win_state[0] = not win_state[0] 
   end)

   repeat wait(0) until isCharOnScreen(PLAYER_PED)

   local data_source = {
      function() -- Armour
         local armor = lim(getCharArmour(PLAYER_PED), 100)
         return armor, armor / 100
      end,
      function() -- Breath
         local breath = lim(math.floor(memory.getfloat(BREATH_PTR) / 39.97000244), 100)
         return breath, breath / 100
      end
   }

	while true do wait(0)
      if sampIsChatVisible() then
         local x, y = ini.main.x[0], ini.main.y[0]

         draw_bar(x, y, ini.main.width[0], "health", -- health bar
         function()
            local health = lim(getCharHealth(PLAYER_PED), 160)
            return health, lim(health, 100) / 100
         end)
         
         y = y - ini.main.height[0] - ini.main.indent[0]
         
         do -- sprint or something bar
            for i, func in ipairs({
               function() return getCharArmour(PLAYER_PED) > 0 and "armor" end,
               function() return isCharSwimming(PLAYER_PED) and "breath" end
            }) do
               local info_type = func()
               if info_type then
                  draw_bar(x, y, ini.main.width[0], info_type, data_source[i])
                  break
               end
            end
         end
         
         y = y - ini.main.height[0] - ini.main.indent[0]

         if galaxy then -- galaxy food and pills
            server.food, server.pills = 0, 0
            parse_textdraws()

            if server.food > 0 and server.pills > 0 then -- both available => 2 charts
               local size = ini.main.width[0] / 2 - ini.main.indent[0] / 2
               draw_bar(x, y, size, "food", function() return server.food, server.food / SERVER_LIMITS.food end)
               draw_bar(x + size + ini.main.indent[0], y, size, "pills", function() return server.pills, server.pills / SERVER_LIMITS.pills end)
            else -- else 1 chart
               for info_type, mod in pairs(SERVER_LIMITS) do
                  if  server[info_type] > 0 then
                     draw_bar(x, y, ini.main.width[0], info_type, function() return server[info_type], server[info_type] / mod end)
                  end
               end
            end
         end
      end
	end
end

local new_frame = imgui.OnFrame(function() return win_state[0] end,
function(player)
	imgui.Begin(script.this.name, win_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
   do
      if imgui.BeginMenu("Charts") then
         if imgui.Checkbox("Use kill-List colour in health chart", ini.main.copy_samp_color) and ini.main.copy_samp_color[0] then
            update_color()
         end
         imgui.SliderInt("Width", ini.main.width, 50, 200)
         imgui.SliderInt("Height", ini.main.height, 14, 40)
         imgui.SliderInt("Border size", ini.main.border, 0, 5)
         imgui.SliderInt("Text offset", ini.main.text_offset, -30, 30)
         imgui.SliderInt("Indent", ini.main.indent, 0, 30)
         if imgui.Button("Choose position", imgui.ImVec2(225, 20)) then
            win_state[0] = false
            lua_thread.create(function()
               sampSetCursorMode(4)
               while not isKeyJustPressed(1) do wait(0)
                  local x, y = getCursorPos()
                  ini.main.x[0], ini.main.y[0] = x, y
               end
               win_state[0] = true
            end)
         end
         imgui.EndMenu()
      end
      if imgui.BeginMenu("Font") then
         if imgui.InputText("Face", ini.font.face, BUFFER_SIZE) then
            local font_face = u8:decode(ffi.string(ini.font.face))
            font = renderCreateFont(font_face, ini.font.size[0], ini.font.flag[0])
         end
      
         if imgui.InputInt("Size", ini.font.size) then
            local font_face = u8:decode(ffi.string(ini.font.face))
            ini.font.size[0] = ini.font.size[0] % 50
            font = renderCreateFont(font_face, ini.font.size[0], ini.font.flag[0])
         end
      
         if imgui.InputInt("Style", ini.font.flag) then
            local font_face = u8:decode(ffi.string(ini.font.face))
            ini.font.flag[0] = ini.font.flag[0] % 13
            font = renderCreateFont(font_face, ini.font.size[0], ini.font.flag[0])
         end
         imgui.EndMenu()
      end
      local charts = {
         health = "Health",
         armor = "Armour",
         breath = "Breath",
         stamina = "Stamina",
         veh_health = "Vehicle health",
      }
      for key, header in pairs(charts) do
         if imgui.BeginMenu(header) then
            imgui.ColorEdit("Fill##" .. key, ini.main_colors[key])
            imgui.ColorEdit("Background##" .. key, ini.bg_colors[key])
            imgui.EndMenu()
         end
      end
      if galaxy and imgui.BeginMenu("Server") then
         imgui.Text("Food:")
         imgui.ColorEdit("Fill##Food", ini.main_colors.food)
         imgui.ColorEdit("Background##Food", ini.bg_colors.food)
         imgui.Text("Pills:")
         imgui.ColorEdit("Fill##Pills", ini.main_colors.pills)
         imgui.ColorEdit("Background##Pills", ini.bg_colors.pills)
         imgui.EndMenu()
      end
      if imgui.Button("Save", imgui.ImVec2(300, 20)) then
         ini = imgui.from(ini)
         save(ini, CFG_PATH)
         ini = imgui.to(ini)
      end
   end
	imgui.End()
end)

function onReceiveRpc(id, bs, _, _)
   if id == RPC_SCRSETPLAYERCOLOR and (type(ini.main.copy_samp_color) == "cdata" and ini.main.copy_samp_color[0]) then 
      -- additional type check for safety reasons
      local _, local_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
      local ped_id = raknetBitStreamReadInt16(bs)
      if local_id == ped_id then
         local color = raknetBitStreamReadInt32(bs)
         local r, g, b, _ = split_argb(color)
         sync_color_with_samp(r, g, b)
      end
   end
end

function onScriptTerminate(lua_script, _) -- remove patch
   if lua_script == script.this then
      local bytes = "\x0F\x84\x70\x03\00\00"
      memory.copy(DRAW_INFO_CONDITIONAL_JMP, memory.strptr(bytes), #bytes, true)
   end
end

function imgui.ColorEdit(label, value, flags)
   local col
   do -- u32 -> float[4]
      local imvec = imgui.ColorConvertU32ToFloat4(value[0])
      -- @ "Color convert u32 to float[4]"
      -- @ Returns imvec4
      -- ????????????????
      col = new.float[4](imvec.z, imvec.y, imvec.x, imvec.w)
   end

   local result = imgui.ColorEdit4(label, col, flags);

   do -- float[4] - > u32
      local a, r, g, b = col[3] * 0xFF, col[0] * 0xFF, col[1] * 0xFF, col[2] * 0xFF
      value[0] = join_argb(a, r, g, b)
   end
   
   return result
end

-- type conversion functions
function imgui.to(tbl)
   local res = tbl

   local actions = {
      boolean = function(value) return new.bool(value) end,
      string = function(value) return new.char[BUFFER_SIZE](u8(value)) end,
      number = function(value) return new.int(value) end
   }
   for section_name, _ in pairs(res) do
      local settings = res[section_name]
      if section_name:find("colors") then
         for key, value in pairs(settings) do
            settings[key] = new["unsigned int"](value)
         end
      else
         for key, value in pairs(settings) do
            settings[key] = actions[type(value)](value)
         end
      end
      res[section_name] = settings
   end
   return res
end

function imgui.from(tbl)
   local res = tbl
   for section_name, _ in pairs(res) do
      if section_name ~= ignored_section then 
         local settings = res[section_name]
         for key, value in pairs(settings) do
            if type(value) == "cdata" then
               local buf_size = tostring(ffi.typeof(value)):match("ctype<.+%s%[(%d+)%]>")
               if buf_size then
                  -- ctype<T>[uint] matched => string, bool or number
                  if tonumber(buf_size) == BUFFER_SIZE then
                     settings[key] = u8:decode(ffi.string(value))
                  else
                     settings[key] = value[0]
                  end
               end
            else
               assert(false, "Key does not exist or is not cdata")
            end
         end
         res[section_name] = settings
      end
   end
   return res
end

ini = load({
   font = {
      face = "Fira Code",
      size = 0.0092592592592593,
      flag = 5
   },
   main = {
      x = 0.85572916666667,
      y = 0.1462962962963,
      indent = 0.0092592592592593,
      width = 0.09375,
      height = 0.014814814814815,
      border = 2,
      text_offset = -0.0018518518518519,
      copy_samp_color = false,
   },
   main_colors = {
      food = 0xFFFFC100,
      pills = 0xFF8F23B0,
      health = 0xFFFF2E16,
      stamina = 0xFF33FF33,
      breath = 0xFF0FC8d7,
      armor = 0xFFFFFFFF,
      veh_health = 0xFF778899,
      border = 0xFF000000
   },
   bg_colors = {
      food = 0xFF614400,
      pills = 0xFF4E2B59,
      health = 0xFF2A0806,
      stamina = 0xFF114411,
      breath = 0xFF125057,
      armor = 0xFF333333,
      veh_health = 0xFF112233
   }
}, CFG_PATH)