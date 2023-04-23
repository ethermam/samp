script_name('MoonHUD');
script_author('THERION/SK1DGARD');
script_version(1.1);
script_description('Multifunctional HUD based on MoonAdditions library');
script_dependencies('MoonAdditions', 'SAMP.lua', 'imGui', 'FontAwesome 5');
script_url('https://t.me/flugegeheiman666');

--LIB
local ffi = require'ffi';
local memory = require'memory';
local mad = require'MoonAdditions';
local sampev = require'samp.events';
--LIB

--SETTINGS
local inicfg = require'inicfg';

local res_x, res_y = getScreenResolution(); --RESOLUTION

ini = inicfg.load({
  MONEY = {
    b_on =  true,
    i_pos_x = math.floor(res_x *  0.950520833),
    i_pos_y = math.floor(res_y * 0.1722222222),
    i_style = 4,
    f_scale_x = 0.00088645833 * res_x,
    f_scale_y = 0.0023638888 * res_y,
    i_align = 3,
    c_text_positive = 0xFF246A24,
    c_text_negative = 0xFF6A2424,
    c_shadow = 0xFF000000,
    b_zeros = true
  },
  WEAPON = {
    b_on =  true,

    b_icon = true,
    i_icon_pos_x = math.floor(res_x * 0.7765625),
    i_icon_pos_y = math.floor(res_y * 0.0444444),
    i_icon_size_x = math.floor(res_x * 0.075),
    i_icon_size_y = math.floor(res_y * 0.13),
    c_icon = 0xFFFFFFFF,

    b_text = true,
    i_pos_x = math.floor(res_x * 0.811979166),
    i_pos_y = math.floor(res_y * 0.137962962),
    i_style = 1,
    f_scale_x = 0.00046354166 * res_x,
    f_scale_y = 0.00157592592 * res_y,
    i_align = 2,
    c_text = 0xFFB5CBFF,
    c_shadow = 0xFF000000
  },
  WANTED = {
    b_on =  true,
    b_zero_disable = true,
    i_pos_x = math.floor(0.91979166666 * res_x),
    i_pos_y = math.floor(0.2324074074 * res_y),
    i_icon_size_x = math.floor(0.03 * res_x),
    i_icon_size_y = math.floor(0.05 * res_y),
    i_indent = 0,
    c_icon = 0xFFFFFFFF
  },
  HEALTH = {
    b_on =  true,

    b_bar = true,
    i_bar_pos_x = math.floor(0.85364583333 * res_x),
    i_bar_pos_y = math.floor(0.15 * res_y),
    i_bar_size_x = math.floor(0.096875 * res_x),
    i_bar_size_y = math.floor(0.01041666666 * res_x),
    i_border_size = math.floor(0.00260416666 * res_x),
    
    b_copy_clist = false,
    c_main = 0xFFB52121,
    c_border = 0xFF000000,
    c_background = 0xF3720909,

    b_text = false,
    i_pos_x = 306,
    i_pos_y = 501,
    i_style = 4,
    f_scale_x = 0.666,
    f_scale_y = 0.885,
    i_align = 2,
    c_text = 0xFFFFFFFF,
    c_shadow = 0xFF000000
  },
  ARMOR = {
    b_on =  true,
    b_zero_disable = true,

    b_bar = true,
    i_bar_pos_x = math.floor(0.85364583333 * res_x),
    i_bar_pos_y = math.floor(0.10185185185 * res_y),
    i_bar_size_x = math.floor(0.096875 * res_x),
    i_bar_size_y = math.floor(0.01041666666 * res_x),
    i_border_size = math.floor(0.00260416666 * res_x),
    c_main = 0xFFFFFFFF,
    c_border = 0xFF000000,
    c_background = 0xC88D8D8D,

    b_text = false,
    i_pos_x = 353,
    i_pos_y = 459,
    i_style = 4,
    f_scale_x = 0.666,
    f_scale_y = 0.885,
    i_align = 2,
    c_text = 0xFFFFFFFF,
    c_shadow = 0xFF000000
  },
  SPRINT = {
    b_on =  false,
    b_disable_in_water = true,

    b_bar = true,
    i_bar_pos_x = 300,
    i_bar_pos_y = 481,
    i_bar_size_x = 106,
    i_bar_size_y = 16,
    i_border_size = 2,
    c_main = 0xFF13FF36,
    c_border = 0xFF000000,
    c_background = 0x68000000,

    b_text = false,
    i_pos_x = 353,
    i_pos_y = 481,
    i_style = 4,
    f_scale_x = 0.666,
    f_scale_y = 0.885,
    i_align = 2,
    c_text = 0xFFFFFFFF,
    c_shadow = 0xFF000000
  },
  BREATHE = {
    b_on =  true,
    b_disable_on_foot = true,

    b_bar = true,
    i_bar_pos_x = math.floor(0.85364583333 * res_x),
    i_bar_pos_y = math.floor(0.12685185185 * res_y),
    i_bar_size_x = math.floor(0.096875 * res_x),
    i_bar_size_y = math.floor(0.01041666666 * res_x),
    i_border_size = math.floor(0.00260416666 * res_x),
    c_main = 0xFFB5CBFF,
    c_border = 0xFF000000,
    c_background = 0xFF464E61,

    b_text = false,
    i_pos_x = 353,
    i_pos_y = 479,
    i_style = 4,
    f_scale_x = 0.666,
    f_scale_y = 0.885,
    i_align = 2,
    c_text = 0xFFFFFFFF,
    c_shadow = 0xFF000000
  },
  RADAR = {
    i_pos_x = 35,
    i_pos_y = 125,
    i_size_x = 100,
    i_size_y = 100
  },
  KILLLIST = {
    b_on =  true,
    b_show_id = true,
    i_reverse = 0,
    i_pos_x = math.floor(0.95 * res_x),
    i_pos_y = math.floor(0.370370 * res_y),
    i_indent_x = math.floor(0.00260416666 * res_x),
    i_indent_y = math.floor(0.0074074074 * res_y),
		i_alignment = 2,
		i_icon_pos = 1,
		i_icon_size = math.floor(0.0185185 * res_y),
    i_lines = 5,
    str_font = 'Arial',
    i_font_size = math.floor(0.005 * res_x),
    i_font_flag = 13
  },
  GENERAL = {
    on =  true
  }
},
thisScript().name .. '\\' .. thisScript().name .. '.ini');
--SETTINGS

--IMGUI

local encoding = require 'encoding';
encoding.default = 'CP1251';
local u8 = encoding.UTF8;

local fa = require 'fAwesome5';
local imgui = require'imgui';
local window_state = imgui.ImBool(false);

local selected = 1;

--IMGUI

--RESOURCES
local kill_list_font = nil;
local textures = {}; 
--RESOURCES

--TEMP DATA
local kill_list_icons = {};
local kill_lines = {};
local player_id = 0;
--TEMP DATA

ffi.cdef
[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
  	int 					iOffsetX;
  	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
    void 		    		*pAuxFont1; // ID3DXFont
    void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]

function main()
  --CONFIG
  if not doesDirectoryExist('moonloader\\config') then createDirectory('moonloader\\config'); end
  if not doesFileExist('moonloader\\config\\' .. thisScript().name) then createDirectory('moonloader\\config\\' .. thisScript().name); end
  if not doesFileExist('moonloader\\config\\' .. thisScript().name ..'\\fa5.ttf') then 
    downloadUrlToFile('https://www.dropbox.com/s/zcevp4ryna0obvy/fa%205.ttf?dl=1', 'moonloader\\config\\' .. thisScript().name ..'\\fa5.ttf'); 
  end
  if not doesFileExist(thisScript().name .. '\\' .. thisScript().name .. '.ini') then 
    inicfg.save(ini, thisScript().name .. '\\' .. thisScript().name .. '.ini'); 
  end
  --CONFIG

  repeat wait(0); until isSampAvailable()
  
  to_imgui();
  load_textures();
  kill_list_font = renderCreateFont(u8:decode(ini.KILLLIST.str_font.v), ini.KILLLIST.i_font_size.v, ini.KILLLIST.i_font_flag.v);
    

  renderFontDrawText(kill_list_font, 'êîñòûëü', 9999, 9999, -1);  --ÊÎÑÒÛËÜ MOON 0.26

  displayHud(true);                                                                                      --TOGGLE HUD
  setStructElement(sampGetKillInfoPtr(), 0, 4, ((ini.GENERAL.on and ini.KILLLIST.b_on.v) and 0 or 1));    --TOGGLE KILLLIST

  sampRegisterChatCommand('hud', function() window_state.v = not window_state.v end);
  log('Loaded successfully: {FB4343}/hud');

  --ID HOOK
  sampev.onSendSpawn = function() update_id(); end   
  --ID HOOK
  do
    function get_id_by_nick(nick)
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED);
      if tostring(nick) == sampGetPlayerNickname(myid) then return myid; end
      for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i; end end
      return 0;
    end

    local kill_info = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr());

    for i = 0, 4 do
      if ffi.string(kill_info.killEntry[i].szKiller) ~= nil and ffi.string(kill_info.killEntry[i].szKiller) ~= "" and kill_info.killEntry[i].byteType > -1 and kill_info.killEntry[i].byteType < 47 then
        local killer_nick = ffi.string(kill_info.killEntry[i].szKiller);
        local killer_id = get_id_by_nick(killer_nick);
        local killed_nick = ffi.string(kill_info.killEntry[i].szVictim);
        local killed_id = get_id_by_nick(killed_nick);

        local line = {
          killer = (not ini.KILLLIST.b_show_id.v) and killer_nick or string.format('%s[%d]', killer_nick, killer_id), 
          killerColor = sampGetPlayerColor(killer_id), 
          killed = (not ini.KILLLIST.b_show_id.v) and killed_nick or string.format('%s[%d]', killed_nick, killed_id), 
          killedColor = sampGetPlayerColor(killed_id), 
          reason = kill_info.killEntry[i].byteType
        } 
        table.insert(kill_lines, line)
      end
    end
  end
  --KILLLIST HOOK
  sampev.onPlayerDeathNotification =   
    function (killerId, killedId, reason)
      if reason < 0 or reason > 46 or killerId > 1000 or killedId > 1000 then return false; end
      lua_thread.create(
        function()
          while isGamePaused() do wait(0); end
          local line = {
            killer = (not ini.KILLLIST.b_show_id.v) and sampGetPlayerNickname(killerId) or string.format('%s[%d]', sampGetPlayerNickname(killerId), killerId), 
            killerColor = sampGetPlayerColor(killerId), 
            killed = (not ini.KILLLIST.b_show_id.v) and sampGetPlayerNickname(killedId) or string.format('%s[%d]', sampGetPlayerNickname(killedId), killedId), 
            killedColor = sampGetPlayerColor(killedId), 
            reason = reason
          };
          if (#kill_lines >= ini.KILLLIST.i_lines.v) then
            kill_lines[#kill_lines + 1] = line;
            for i = 1, #kill_lines - 1 do kill_lines[i] = kill_lines[i + 1]; end
            table.remove(kill_lines);
          else
            table.insert(kill_lines, line);
          end
        end)
    end
  --KILLLIST HOOK
  while not sampIsLocalPlayerSpawned() do wait(0); end

  update_id();

  --PLAYER COLOR HOOK
  if ini.HEALTH.b_copy_clist.v then
    local _, R, G, B = hex_to_argb(sampGetPlayerColor(player_id));
    ini.HEALTH.c_main = imgui.ImFloat4(imgui.ImColor(R, G, B, math.floor(ini.HEALTH.c_main.v[4] * 255)):GetFloat4());
    ini.HEALTH.c_background = imgui.ImFloat4(imgui.ImColor(math.floor(R / 4), math.floor(G / 4), math.floor(B / 4), math.floor(ini.HEALTH.c_background.v[4] * 255)):GetFloat4());
    
    sampev.onSetPlayerColor = 
    function(id, color)
      if id == player_id and ini.HEALTH.b_copy_clist.v then
        local r, g, b, _ = hex_to_argb(color);
        ini.HEALTH.c_main = imgui.ImFloat4(imgui.ImColor(r, g, b, math.floor(ini.HEALTH.c_main.v[4] * 255)):GetFloat4());
        ini.HEALTH.c_background = imgui.ImFloat4(imgui.ImColor(math.floor(r / 4), math.floor(g / 4), math.floor(b / 4), math.floor(ini.HEALTH.c_background.v[4] * 255)):GetFloat4());
      end
    end
  end
  --PLAYER COLOR HOOK

  --RENDERING
  while true do wait(0)
    imgui.Process = window_state.v;
    if ini.GENERAL.on then
      if ini.KILLLIST.b_on.v then render_kill_list(); end
    end
  end
  --RENDERING
end

--RENDER FUNCTIONS
function draw_bar(info, value, max_value)
  if info.b_bar.v then
    --TOP BORDER
    mad.draw_rect(
      info.i_bar_pos_x.v, 
      info.i_bar_pos_y.v, 
      info.i_bar_pos_x.v + info.i_bar_size_x.v, 
      info.i_bar_pos_y.v + info.i_border_size.v, 
      math.floor(info.c_border.v[1] * 255), 
      math.floor(info.c_border.v[2] * 255), 
      math.floor(info.c_border.v[3] * 255), 
      math.floor(info.c_border.v[4] * 255),
      0);
    --BOTTOM BORDER
    mad.draw_rect(
      info.i_bar_pos_x.v, 
      info.i_bar_pos_y.v + info.i_bar_size_y.v - info.i_border_size.v, 
      info.i_bar_pos_x.v + info.i_bar_size_x.v, 
      info.i_bar_pos_y.v + info.i_bar_size_y.v, 
      math.floor(info.c_border.v[1] * 255), 
      math.floor(info.c_border.v[2] * 255), 
      math.floor(info.c_border.v[3] * 255), 
      math.floor(info.c_border.v[4] * 255),
      0);
    --LEFT BORDER
    mad.draw_rect(
      info.i_bar_pos_x.v, 
      info.i_bar_pos_y.v + info.i_border_size.v, 
      info.i_bar_pos_x.v + info.i_border_size.v, 
      info.i_bar_pos_y.v + info.i_bar_size_y.v - info.i_border_size.v, 
      math.floor(info.c_border.v[1] * 255), 
      math.floor(info.c_border.v[2] * 255), 
      math.floor(info.c_border.v[3] * 255), 
      math.floor(info.c_border.v[4] * 255),
      0);
    --RIGHT BORDER
    mad.draw_rect(
      info.i_bar_pos_x.v + info.i_bar_size_x.v - info.i_border_size.v, 
      info.i_bar_pos_y.v + info.i_border_size.v, 
      info.i_bar_pos_x.v + info.i_bar_size_x.v, 
      info.i_bar_pos_y.v + info.i_bar_size_y.v - info.i_border_size.v, 
      math.floor(info.c_border.v[1] * 255), 
      math.floor(info.c_border.v[2] * 255), 
      math.floor(info.c_border.v[3] * 255), 
      math.floor(info.c_border.v[4] * 255),
      0);
    --MAIN BAR
    if value > 0 then
      mad.draw_rect(
        info.i_bar_pos_x.v + info.i_border_size.v, 
        info.i_bar_pos_y.v + info.i_border_size.v, 
        info.i_bar_pos_x.v - info.i_border_size.v + info.i_bar_size_x.v * limit_input(value, 0, 100) / max_value, 
        info.i_bar_pos_y.v + info.i_bar_size_y.v - info.i_border_size.v, 
        math.floor(info.c_main.v[1] * 255), 
        math.floor(info.c_main.v[2] * 255), 
        math.floor(info.c_main.v[3] * 255), 
        math.floor(info.c_main.v[4] * 255),
        0);
    end
    --BACKGROUND
    mad.draw_rect(
      value <= 0 and (info.i_bar_pos_x.v + info.i_border_size.v) or (info.i_bar_pos_x.v - info.i_border_size.v + info.i_bar_size_x.v * limit_input(value, 0, 100) / max_value), 
      info.i_bar_pos_y.v + info.i_border_size.v, 
      info.i_bar_pos_x.v - info.i_border_size.v + info.i_bar_size_x.v, 
      info.i_bar_pos_y.v + info.i_bar_size_y.v - info.i_border_size.v, 
      math.floor(info.c_background.v[1] * 255), 
      math.floor(info.c_background.v[2] * 255), 
      math.floor(info.c_background.v[3] * 255), 
      math.floor(info.c_background.v[4] * 255),
      0);
  end
  if info.b_text.v then
    --TEXT
    mad_draw_text(
      value, 
      info.i_pos_x.v, 
      info.i_pos_y.v,
      info.f_scale_x.v, 
      info.f_scale_y.v,
      math.floor(info.c_text.v[1] * 255), 
      math.floor(info.c_text.v[2] * 255), 
      math.floor(info.c_text.v[3] * 255), 
      math.floor(info.c_text.v[4] * 255),
      math.floor(info.c_shadow.v[1] * 255), 
      math.floor(info.c_shadow.v[2] * 255), 
      math.floor(info.c_shadow.v[3] * 255), 
      math.floor(info.c_shadow.v[4] * 255),
      mad.font_style[get_style(info.i_style.v)], 
      mad.font_align[get_align(info.i_align.v)]);
  end
end

function draw_money()
  local money = getPlayerMoney(PLAYER_HANDLE);
  local text_r, text_g, text_b, text_a;
  if money >= 0 then
    text_r = math.floor(ini.MONEY.c_text_positive.v[1] * 255);
    text_g = math.floor(ini.MONEY.c_text_positive.v[2] * 255);
    text_b = math.floor(ini.MONEY.c_text_positive.v[3] * 255);
    text_a = math.floor(ini.MONEY.c_text_positive.v[4] * 255);
  else
    text_r = math.floor(ini.MONEY.c_text_negative.v[1] * 255);
    text_g = math.floor(ini.MONEY.c_text_negative.v[2] * 255); 
    text_b = math.floor(ini.MONEY.c_text_negative.v[3] * 255); 
    text_a = math.floor(ini.MONEY.c_text_negative.v[4] * 255);
  end
  money = string.format(ini.MONEY.b_zeros.v and '%s$%09d' or '%s$%d', (money >= 0) and '' or '-', money);
  mad_draw_text(
    money, 
    ini.MONEY.i_pos_x.v, 
    ini.MONEY.i_pos_y.v,
    ini.MONEY.f_scale_x.v, 
    ini.MONEY.f_scale_y.v,
    text_r,
    text_g,
    text_b,
    text_a,
    math.floor(ini.MONEY.c_shadow.v[1] * 255), 
    math.floor(ini.MONEY.c_shadow.v[2] * 255), 
    math.floor(ini.MONEY.c_shadow.v[3] * 255), 
    math.floor(ini.MONEY.c_shadow.v[4] * 255),
    mad.font_style[get_style(ini.MONEY.i_style.v)], 
    mad.font_align[get_align(ini.MONEY.i_align.v)]    
    );
end

function draw_weapon()
  local weapon = getCurrentCharWeapon(PLAYER_PED);
  if ini.WEAPON.b_icon.v and textures[weapon] then
    textures[weapon]:draw(
      ini.WEAPON.i_icon_pos_x.v, 
      ini.WEAPON.i_icon_pos_y.v, 
      ini.WEAPON.i_icon_pos_x.v + ini.WEAPON.i_icon_size_x.v, 
      ini.WEAPON.i_icon_pos_y.v + ini.WEAPON.i_icon_size_y.v,
      math.floor(ini.WEAPON.c_icon.v[1] * 255), 
      math.floor(ini.WEAPON.c_icon.v[2] * 255), 
      math.floor(ini.WEAPON.c_icon.v[3] * 255), 
      math.floor(ini.WEAPON.c_icon.v[4] * 255),
      0);
  end
  if ini.WEAPON.b_text.v then
  	local slot = getWeapontypeSlot(weapon);
   	local pointer = getCharPointer(PLAYER_PED);
  	local cweapon = pointer + 0x5A0;
  	local current_cweapon = cweapon + slot * 0x1C;
  	local ammo_in_clip = memory.getuint32(current_cweapon + 0x8);
  	local ammo_count = getAmmoInCharWeapon(PLAYER_PED, weapon);
    if weapon > 15 and weapon < 40 or weapon > 40 and weapon < 44 then 
      mad_draw_text(
        string.format('%d-%d', ammo_count - ammo_in_clip, ammo_in_clip), 
        ini.WEAPON.i_pos_x.v, 
        ini.WEAPON.i_pos_y.v,
        ini.WEAPON.f_scale_x.v, 
        ini.WEAPON.f_scale_y.v,
        math.floor(ini.WEAPON.c_text.v[1] * 255),
        math.floor(ini.WEAPON.c_text.v[2] * 255),
        math.floor(ini.WEAPON.c_text.v[3] * 255),
        math.floor(ini.WEAPON.c_text.v[4] * 255),
        math.floor(ini.WEAPON.c_shadow.v[1] * 255), 
        math.floor(ini.WEAPON.c_shadow.v[2] * 255), 
        math.floor(ini.WEAPON.c_shadow.v[3] * 255), 
        math.floor(ini.WEAPON.c_shadow.v[4] * 255),
        mad.font_style[get_style(ini.WEAPON.i_style.v)], 
        mad.font_align[get_align(ini.WEAPON.i_align.v)]);
    end
  end
end

function draw_wanted()
  local wanted = memory.getuint8(5823328);
  if ini.WANTED.b_zero_disable.v and (wanted < 1 or wanted > 6) then return; end
  for i = 1, 6 do
    if i > wanted then
      textures['star_inactive']:draw(
        ini.WANTED.i_pos_x.v - (i - 1) * (ini.WANTED.i_icon_size_x.v + ini.WANTED.i_indent.v), 
        ini.WANTED.i_pos_y.v, 
        ini.WANTED.i_pos_x.v - (i - 1) * (ini.WANTED.i_icon_size_x.v + ini.WANTED.i_indent.v) + ini.WANTED.i_icon_size_x.v, 
        ini.WANTED.i_pos_y.v + ini.WANTED.i_icon_size_y.v, 
        255,
        255,
        255,
        math.floor(ini.WANTED.c_icon.v[4] * 255),
        0);
		else
			textures['star_active']:draw(
        ini.WANTED.i_pos_x.v - (i - 1) * (ini.WANTED.i_icon_size_x.v + ini.WANTED.i_indent.v), 
        ini.WANTED.i_pos_y.v, 
        ini.WANTED.i_pos_x.v - (i - 1) * (ini.WANTED.i_icon_size_x.v + ini.WANTED.i_indent.v) + ini.WANTED.i_icon_size_x.v, 
        ini.WANTED.i_pos_y.v + ini.WANTED.i_icon_size_y.v, 
        math.floor(ini.WANTED.c_icon.v[1] * 255),
        math.floor(ini.WANTED.c_icon.v[2] * 255),
        math.floor(ini.WANTED.c_icon.v[3] * 255),
        math.floor(ini.WANTED.c_icon.v[4] * 255),
        0);
		end
  end
end

function mad_draw_text(text, i_pos_x, i_pos_y, f_scale_x, f_scale_y, text_r, text_g, text_b, text_a, shadow_r, shadow_g, shadow_b, shadow_a, mad_style, mad_align)
  mad.draw_text(text, i_pos_x, i_pos_y, mad_style, f_scale_x, f_scale_y, mad_align, 60000 * (mad_align == mad.font_align.RIGHT and -1 or 1), true, false, text_r, text_g, text_b, text_a, 1, 0, shadow_r, shadow_g, shadow_b, shadow_a, false);
end

function render_kill_list()
	for i = 1, #kill_lines do
    local i_pos_y = ini.KILLLIST.i_pos_y.v + math.pow(-1, ini.KILLLIST.i_reverse.v) * (i - 1) * (ini.KILLLIST.i_indent_y.v + renderGetFontDrawHeight(kill_list_font));
    
    if ini.KILLLIST.i_alignment.v == 0 then
      if ini.KILLLIST.i_icon_pos.v == 0 then
        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
        
        renderFontDrawText(
          kill_list_font,
          string.format('{%06X}%s {ffffff}» {%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer, argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
          ini.KILLLIST.i_pos_x.v + ini.KILLLIST.i_indent_x.v + ini.KILLLIST.i_icon_size.v,
          i_pos_y,
          -1);
      elseif ini.KILLLIST.i_icon_pos.v == 1 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer),
        ini.KILLLIST.i_pos_x.v,
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v + renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) + ini.KILLLIST.i_indent_x.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);

        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v + renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) + 2 * ini.KILLLIST.i_indent_x.v + ini.KILLLIST.i_icon_size.v,
        i_pos_y,
        -1);

      elseif ini.KILLLIST.i_icon_pos.v == 2 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s {ffffff}» {%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer, argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v,
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v + ini.KILLLIST.i_indent_x.v + renderGetFontDrawTextLength(kill_list_font, string.format('%s » %s', kill_lines[i].killer, kill_lines[i].killed)),
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      end
    elseif ini.KILLLIST.i_alignment.v == 1 then
      if ini.KILLLIST.i_icon_pos.v == 0 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s {ffffff}»', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) - renderGetFontDrawTextLength(kill_list_font, ' »') / 2,
        i_pos_y,
        -1);

        renderFontDrawText(
        kill_list_font,
        string.format(' {%06X}%s', argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v + renderGetFontDrawTextLength(kill_list_font, '»') / 2,
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) - renderGetFontDrawTextLength(kill_list_font, ' »') / 2 - ini.KILLLIST.i_indent_x.v - ini.KILLLIST.i_icon_size.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      elseif ini.KILLLIST.i_icon_pos.v == 1 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) - ini.KILLLIST.i_icon_size.v / 2 - ini.KILLLIST.i_indent_x.v,
        i_pos_y,
        -1);
  
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v + ini.KILLLIST.i_icon_size.v / 2 + ini.KILLLIST.i_indent_x.v,
        i_pos_y,
        -1);
    
        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v - ini.KILLLIST.i_icon_size.v / 2,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      elseif ini.KILLLIST.i_icon_pos.v == 2 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s {ffffff}»', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer) - renderGetFontDrawTextLength(kill_list_font, ' »') / 2,
        i_pos_y,
        -1);

        renderFontDrawText(
        kill_list_font,
        string.format(' {%06X}%s', argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v + renderGetFontDrawTextLength(kill_list_font, '»') / 2,
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v + renderGetFontDrawTextLength(kill_list_font, '»') / 2 + renderGetFontDrawTextLength(kill_list_font, string.format(' %s', kill_lines[i].killed)) + ini.KILLLIST.i_indent_x.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      end
    elseif ini.KILLLIST.i_alignment.v == 2 then
      if ini.KILLLIST.i_icon_pos.v == 0 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s {ffffff}» {%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer, argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, string.format('%s » %s', kill_lines[i].killer, kill_lines[i].killed)),
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, string.format('%s » %s', kill_lines[i].killer, kill_lines[i].killed)) - ini.KILLLIST.i_indent_x.v - ini.KILLLIST.i_icon_size.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      elseif ini.KILLLIST.i_icon_pos.v == 1 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer),
        ini.KILLLIST.i_pos_x.v - ini.KILLLIST.i_icon_size.v - 2 * ini.KILLLIST.i_indent_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killed) - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killer),
        i_pos_y,
        -1);

        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v - ini.KILLLIST.i_icon_size.v - ini.KILLLIST.i_indent_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killed),
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);

        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s', argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, kill_lines[i].killed),
        i_pos_y,
        -1);
      elseif ini.KILLLIST.i_icon_pos.v == 2 then
        renderFontDrawText(
        kill_list_font,
        string.format('{%06X}%s {ffffff}» {%06X}%s', argb_to_rgb_bare(kill_lines[i].killerColor), kill_lines[i].killer, argb_to_rgb_bare(kill_lines[i].killedColor), kill_lines[i].killed),
        ini.KILLLIST.i_pos_x.v - renderGetFontDrawTextLength(kill_list_font, string.format('%s » %s', kill_lines[i].killer, kill_lines[i].killed)) - ini.KILLLIST.i_indent_x.v - ini.KILLLIST.i_icon_size.v,
        i_pos_y,
        -1);
  
        renderDrawTexture(
        kill_list_icons[kill_lines[i].reason],
        ini.KILLLIST.i_pos_x.v - ini.KILLLIST.i_icon_size.v,
        i_pos_y - (ini.KILLLIST.i_icon_size.v - renderGetFontDrawHeight(kill_list_font)) / 2.0,
        ini.KILLLIST.i_icon_size.v,
        ini.KILLLIST.i_icon_size.v,
        0,
        4294967295.0);
      end
    end
  end
end
--RENDER FUNCTIONS

--SOME USEFUL STUFF

function update_id()
  _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED);
end

function set_radar_size(x, y)
	writeMemory(8809332, 4, representFloatAsInt(x), true);
	writeMemory(8809336, 4, representFloatAsInt(y), true);
end

function set_radar_pos(x, y)
  writeMemory(8751632, 4, representFloatAsInt(x), true);
  writeMemory(8809328, 4, representFloatAsInt(y), true);
end

function limit_input(var, min, max)
  if var < min then var = min; end
  if var > max then var = max; end
  return var;
end

function get_style(integer)
  return (integer == 1 and 'SUBTITLES' or (integer == 2 and 'MENU' or (integer == 3 and 'GOTHIC' or 'PRICEDOWN')));
end

function get_align(integer)
  return (integer == 1 and 'LEFT' or (integer == 2 and 'CENTER' or 'RIGHT'));
end
--SOME USEFUL STUFF

--COLOR WORKS
function rgba_to_argb(rgba)
  local r, g, b, a = hex_to_argb(rgba);
  return argb_to_hex(ini.CHAT_BUBBLE.opacity.v, r, g, b);
end

function argb_to_rgb_bare(argb)
	return bit.band(argb, 16777215);
end

function argb_to_rgb(argb, new_a)
  local a, r, g, b = hex_to_argb(argb);
	return argb_to_hex(new_a, r, g, b);
end

function argb_to_hex(a, r, g, b)
  local argb = b;
  argb = bit.bor(argb, bit.lshift(g, 8));
  argb = bit.bor(argb, bit.lshift(r, 16));
  argb = bit.bor(argb, bit.lshift(a, 24));
  return argb;
end

function hex_to_argb(hex)
  return 
    bit.band(bit.rshift(hex, 24), 255),
    bit.band(bit.rshift(hex, 16), 255), 
    bit.band(bit.rshift(hex, 8), 255), 
    bit.band(hex, 255);
end
--COLOR WORKS

--LOADING RESOURCES
function load_textures()
  textures['star_inactive'] = mad.load_png_texture('moonloader\\config\\' .. thisScript().name ..'\\Star2.png');
  textures['star_active'] = mad.load_png_texture('moonloader\\config\\' .. thisScript().name .. '\\Star1.png');

  for i = 0, 46 do
    textures[i] = mad.load_png_texture(string.format('moonloader\\config\\%s\\Weapons\\%d.png', thisScript().name, i));
  end

  for i = 0, 225 do
		if i >= 0 and i <= 18 or i >= 22 and i <= 47 or i >= 49 and i <= 51 or i == 53 or i == 54 or i == 200 or i == 201 or i == 225 then
			if doesFileExist(string.format('moonloader\\config\\%s\\KillList\\%d.png', thisScript().name, i)) then
        kill_list_icons[i] = renderLoadTextureFromFile(string.format('moonloader\\config\\%s\\KillList\\%d.png', thisScript().name, i));
      end
    end
  end
end
--LOADING RESOURCES

--IMGUI
local fa_font = nil;
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range });

function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig();
    font_config.MergeMode = true;
		font_config.SizePixels = 15.0;
		font_config.GlyphExtraSpacing.x = 0.1;
    fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader\\config\\'.. thisScript().name .. '\\fa5.ttf', font_config.SizePixels, font_config, fa_glyph_ranges);
  end
end

function imgui.OnDrawFrame()
  if window_state.v then
    imgui.Begin(fa.ICON_COGS .. u8('  Moon HUD | Author: SK1DGARD\\THERION'), window_state, imgui.WindowFlags.AlwaysAutoResize);
      imgui.BeginChild(1, imgui.ImVec2(814, 84), true);

		    imgui.SetCursorPos(imgui.ImVec2(5, 5));
    
        if imgui.CustomButton(
          fa.ICON_POWER_OFF .. u8(ini.GENERAL.on and '  ON' or '  OFF'), 
          ini.GENERAL.on and imgui.ImVec4(0.14, 0.5, 0.14, 1.00) or imgui.ImVec4(0.5, 0.14, 0.14, 1.00), 
          ini.GENERAL.on and imgui.ImVec4(0.15, 0.59, 0.18, 0.5) or imgui.ImVec4(1, 0.19, 0.19, 0.3), 
          ini.GENERAL.on and imgui.ImVec4(0.15, 0.59, 0.18, 0.4) or imgui.ImVec4(1, 0.19, 0.19, 0.2), 
          imgui.ImVec2(161, 75)) then

          ini.GENERAL.on =  not ini.GENERAL.on;
          
          displayHud(not ini.GENERAL.on);
          setStructElement(sampGetKillInfoPtr(), 0, 4, ((ini.GENERAL.on and ini.KILLLIST.b_on.v) and 0 or 1));
          log(string.format('I am %s.', ini.GENERAL.on and '{5BFF83}alive{FFFFFF} now' or '{FB4343}sleeping{FFFFFF} for now'));
        end
    
		    imgui.SameLine();
        imgui.SetCursorPosX(167);
    
	    	if imgui.CustomButton(
          fa.ICON_SAVE .. u8('  Save'),
          imgui.ImVec4(0.24, 0.24, 0.24, 1),
          imgui.ImVec4(0.5, 0.14, 0.14, 1.00), 
          imgui.ImVec4(0.25, 0.07, 0.07, 1), 
          imgui.ImVec2(161, 75)) then

          from_imgui();
          log(string.format('Settings are %s', 
          inicfg.save(ini, thisScript().name .. '\\' .. thisScript().name .. '.ini') and '{5BFF83}successfully{FFFFFF} saved.' or 'cannot be saved {FB4343}:('));
          to_imgui();
        end
    
		    imgui.SameLine();
        imgui.SetCursorPosX(329);
    
	    	if imgui.CustomButton(
            fa.ICON_REDO_ALT .. u8('  Default'), 
            imgui.ImVec4(0.24, 0.24, 0.24, 1),
            imgui.ImVec4(0.5, 0.14, 0.14, 1.00), 
            imgui.ImVec4(0.25, 0.07, 0.07, 1), 
            imgui.ImVec2(161, 75)) then
            
            ini = {
              MONEY = {
                b_on =  true,
                i_pos_x = math.floor(res_x *  0.950520833),
                i_pos_y = math.floor(res_y * 0.1722222222),
                i_style = 4,
                f_scale_x = 0.00088645833 * res_x,
                f_scale_y = 0.0023638888 * res_y,
                i_align = 3,
                c_text_positive = 0xFF246A24,
                c_text_negative = 0xFF6A2424,
                c_shadow = 0xFF000000,
                b_zeros = true
              },
              WEAPON = {
                b_on =  true,
            
                b_icon = true,
                i_icon_pos_x = math.floor(res_x * 0.7765625),
                i_icon_pos_y = math.floor(res_y * 0.0444444),
                i_icon_size_x = math.floor(res_x * 0.075),
                i_icon_size_y = math.floor(res_y * 0.13),
                c_icon = 0xFFFFFFFF,
            
                b_text = true,
                i_pos_x = math.floor(res_x * 0.811979166),
                i_pos_y = math.floor(res_y * 0.137962962),
                i_style = 1,
                f_scale_x = 0.00046354166 * res_x,
                f_scale_y = 0.00157592592 * res_y,
                i_align = 2,
                c_text = 0xFFB5CBFF,
                c_shadow = 0xFF000000
              },
              WANTED = {
                b_on =  true,
                b_zero_disable = true,
                i_pos_x = math.floor(0.91979166666 * res_x),
                i_pos_y = math.floor(0.2324074074 * res_y),
                i_icon_size_x = math.floor(0.03 * res_x),
                i_icon_size_y = math.floor(0.05 * res_y),
                i_indent = 0,
                c_icon = 0xFFFFFFFF
              },
              HEALTH = {
                b_on =  true,
            
                b_bar = true,
                i_bar_pos_x = math.floor(0.85364583333 * res_x),
                i_bar_pos_y = math.floor(0.15 * res_y),
                i_bar_size_x = math.floor(0.096875 * res_x),
                i_bar_size_y = math.floor(0.01041666666 * res_x),
                i_border_size = math.floor(0.00260416666 * res_x),
                
                b_copy_clist = false,
                c_main = 0xFFB52121,
                c_border = 0xFF000000,
                c_background = 0xF3720909,
            
                b_text = false,
                i_pos_x = 306,
                i_pos_y = 501,
                i_style = 4,
                f_scale_x = 0.666,
                f_scale_y = 0.885,
                i_align = 2,
                c_text = 0xFFFFFFFF,
                c_shadow = 0xFF000000
              },
              ARMOR = {
                b_on =  true,
                b_zero_disable = true,
            
                b_bar = true,
                i_bar_pos_x = math.floor(0.85364583333 * res_x),
                i_bar_pos_y = math.floor(0.10185185185 * res_y),
                i_bar_size_x = math.floor(0.096875 * res_x),
                i_bar_size_y = math.floor(0.01041666666 * res_x),
                i_border_size = math.floor(0.00260416666 * res_x),
                c_main = 0xFFFFFFFF,
                c_border = 0xFF000000,
                c_background = 0xC88D8D8D,
            
                b_text = false,
                i_pos_x = 353,
                i_pos_y = 459,
                i_style = 4,
                f_scale_x = 0.666,
                f_scale_y = 0.885,
                i_align = 2,
                c_text = 0xFFFFFFFF,
                c_shadow = 0xFF000000
              },
              SPRINT = {
                b_on =  false,
                b_disable_in_water = true,
            
                b_bar = true,
                i_bar_pos_x = 300,
                i_bar_pos_y = 481,
                i_bar_size_x = 106,
                i_bar_size_y = 16,
                i_border_size = 2,
                c_main = 0xFF13FF36,
                c_border = 0xFF000000,
                c_background = 0x68000000,
            
                b_text = false,
                i_pos_x = 353,
                i_pos_y = 481,
                i_style = 4,
                f_scale_x = 0.666,
                f_scale_y = 0.885,
                i_align = 2,
                c_text = 0xFFFFFFFF,
                c_shadow = 0xFF000000
              },
              BREATHE = {
                b_on =  true,
                b_disable_on_foot = true,
            
                b_bar = true,
                i_bar_pos_x = math.floor(0.85364583333 * res_x),
                i_bar_pos_y = math.floor(0.12685185185 * res_y),
                i_bar_size_x = math.floor(0.096875 * res_x),
                i_bar_size_y = math.floor(0.01041666666 * res_x),
                i_border_size = math.floor(0.00260416666 * res_x),
                c_main = 0xFFB5CBFF,
                c_border = 0xFF000000,
                c_background = 0xFF464E61,
            
                b_text = false,
                i_pos_x = 353,
                i_pos_y = 479,
                i_style = 4,
                f_scale_x = 0.666,
                f_scale_y = 0.885,
                i_align = 2,
                c_text = 0xFFFFFFFF,
                c_shadow = 0xFF000000
              },
              RADAR = {
                i_pos_x = 35,
                i_pos_y = 125,
                i_size_x = 100,
                i_size_y = 100
              },
              KILLLIST = {
                b_on =  true,
                b_show_id = true,
                i_reverse = 0,
                i_pos_x = math.floor(0.95 * res_x),
                i_pos_y = math.floor(0.370370 * res_y),
                i_indent_x = math.floor(0.00260416666 * res_x),
                i_indent_y = math.floor(0.0074074074 * res_y),
                i_alignment = 2,
                i_icon_pos = 1,
                i_icon_size = math.floor(0.0185185 * res_y),
                i_lines = 5,
                str_font = 'Arial',
                i_font_size = math.floor(0.005 * res_x),
                i_font_flag = 13
              },
              GENERAL = {
                on =  true
              }
            };
            to_imgui();

            displayHud(not ini.GENERAL.on);
            setStructElement(sampGetKillInfoPtr(), 0, 4, ((ini.GENERAL.on and ini.KILLLIST.b_on.v) and 0 or 1));
            set_radar_pos(ini.RADAR.i_pos_x.v, ini.RADAR.i_pos_y.v);
            set_radar_size(ini.RADAR.i_size_x.v, ini.RADAR.i_size_y.v); 
            
            log('Settings were reset to default');
        end

        imgui.SameLine();
        imgui.SetCursorPosX(491);

        if imgui.CustomButton(
          fa.ICON_PAPER_PLANE .. u8('  Telegram'), 
          imgui.ImVec4(0.207, 0.674, 0.878, 0.7), 
          imgui.ImVec4(0.207, 0.674, 0.878, 0.5), 
          imgui.ImVec4(0.207, 0.674, 0.878, 0.4), 
          imgui.ImVec2(161, 75)) then

          os.execute('explorer \"https://t.me/flugegeheiman666\"');
        end
        
        imgui.SameLine();
        imgui.SetCursorPosX(653);
    
	    	if imgui.CustomButton(
          fa.ICON_LIST .. u8('  Kill-List'), 
          selected == 0 and imgui.ImVec4(1.00, 0.28, 0.28, 1.00) or imgui.ImVec4(0.24, 0.24, 0.24, 1), 
          imgui.ImVec4(0.5, 0.14, 0.14, 1.00), 
          imgui.ImVec4(0.25, 0.07, 0.07, 1),
          imgui.ImVec2(161, 75)) then

          selected = 0;
        end

      imgui.EndChild();
      imgui.BeginChild(2, imgui.ImVec2(814, 439), true);
        if selected == 1 then
          imgui.Checkbox('Display money', ini.MONEY.b_on);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position', ini.MONEY.i_pos_x);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position', ini.MONEY.i_pos_y);
          if imgui.Button(fa.ICON_RETWEET .. '  Choose position', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function ()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
	    			  	while true do wait(0);
                
                  ini.MONEY.i_pos_x.v, ini.MONEY.i_pos_y.v = getCursorPos();
                
                 sampSetCursorMode(3);
   
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return;
    						  end
     					  end
    				  end)
          end
          imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  X scale', ini.MONEY.f_scale_x, 0, 20);
          imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  Y scale', ini.MONEY.f_scale_y, 0, 20);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Font color', ini.MONEY.c_text_positive);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Font color when in debt', ini.MONEY.c_text_negative);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Shadow color', ini.MONEY.c_shadow);
          imgui.Text('  Font style:');
          imgui.RadioButton('Subtitles', ini.MONEY.i_style, 1);
          imgui.SameLine();
          imgui.RadioButton('Menu', ini.MONEY.i_style, 2);
          imgui.SameLine();
          imgui.RadioButton('Gothic', ini.MONEY.i_style, 3);
          imgui.SameLine();
          imgui.RadioButton('Pricedown', ini.MONEY.i_style, 4);

          imgui.Text('  Alignment:');
          imgui.RadioButton('Left side', ini.MONEY.i_align, 1);
          imgui.SameLine();
          imgui.RadioButton('Middle', ini.MONEY.i_align, 2);
          imgui.SameLine();
          imgui.RadioButton('Right side', ini.MONEY.i_align, 3)
          imgui.Checkbox('Add zeros', ini.MONEY.b_zeros);
        end
        if selected == 2 then
          imgui.Checkbox('Display current weapon', ini.WEAPON.b_on);
          imgui.Checkbox('Display icon', ini.WEAPON.b_icon);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position', ini.WEAPON.i_icon_pos_x);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position', ini.WEAPON.i_icon_pos_y);
          if imgui.Button(fa.ICON_RETWEET ..  '  Choose position', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
	    			  	while true do wait(0)
                
                  ini.WEAPON.i_icon_pos_x.v, ini.WEAPON.i_icon_pos_y.v = getCursorPos();
                
                 sampSetCursorMode(3);
   
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return;
    						  end
     					  end
    				  end)
          end
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Icon width', ini.WEAPON.i_icon_size_x, 0, 600);
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Icon height', ini.WEAPON.i_icon_size_y, 0, 600);
          imgui.ColorEdit4(fa.ICON_SPINNER ..  '  Icon color', ini.WEAPON.c_icon);

          imgui.Checkbox('Display ammo', ini.WEAPON.b_text);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position##text', ini.WEAPON.i_pos_x);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position##text', ini.WEAPON.i_pos_y);
          if imgui.Button(fa.ICON_RETWEET ..  '  Choose position##text', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function ()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
	    			  	while true do wait(0);
                
                  ini.WEAPON.i_pos_x.v, ini.WEAPON.i_pos_y.v = getCursorPos();
                
                 sampSetCursorMode(3);
   
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return;
    						  end
     					  end
    				  end)
          end
          imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  X scale', ini.WEAPON.f_scale_x, 0, 20);
          imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  Y scale', ini.WEAPON.f_scale_y, 0, 20);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Font color', ini.WEAPON.c_text);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Shadow color', ini.WEAPON.c_shadow);
          imgui.Text('  Font style:');
          imgui.RadioButton('Subtitles', ini.WEAPON.i_style, 1);
          imgui.SameLine();
          imgui.RadioButton('Menu', ini.WEAPON.i_style, 2);
          imgui.SameLine();
          imgui.RadioButton('Gothic', ini.WEAPON.i_style, 3);
          imgui.SameLine();
          imgui.RadioButton('Pricedown', ini.WEAPON.i_style, 4);

          imgui.Text('  Alignment:');
          imgui.RadioButton('Left side', ini.WEAPON.i_align, 1);
          imgui.SameLine();
          imgui.RadioButton('Middle', ini.WEAPON.i_align, 2);
          imgui.SameLine();
          imgui.RadioButton('Right side', ini.WEAPON.i_align, 3);
        end
        if selected == 3 then
          imgui.Checkbox('Display wanted level', ini.WANTED.b_on);
          imgui.Checkbox('Stop displaying when "unwanted" :) ', ini.WANTED.b_zero_disable);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position', ini.WANTED.i_pos_x);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position', ini.WANTED.i_pos_y);
          if imgui.Button(fa.ICON_RETWEET .. '  Choose position', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function ()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
	    			  	while true do wait(0);
                
                  ini.WANTED.i_pos_x.v, ini.WANTED.i_pos_y.v = getCursorPos();
                
                 sampSetCursorMode(3);
   
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return;
    						  end
     					  end
    				  end)
          end
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Icon width', ini.WANTED.i_icon_size_x, 0, 200);
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Icon height', ini.WANTED.i_icon_size_y, 0, 200);
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Indent between stars', ini.WANTED.i_indent, 0, 100);
          imgui.ColorEdit4(fa.ICON_SPINNER .. '  Star color', ini.WANTED.c_icon);
        end
        if selected == 4 then
          imgui.BarCustomization(ini.HEALTH);
          if imgui.Checkbox('Copy Kill-List color', ini.HEALTH.b_copy_clist) then
            if ini.HEALTH.b_copy_clist.v then
              sampev.onSetPlayerColor = 
                function(id, color)
                  if id == player_id and ini.HEALTH.b_copy_clist.v then
                    local r, g, b, _ = hex_to_argb(color);
                    ini.HEALTH.c_main = imgui.ImFloat4(imgui.ImColor(r, g, b, math.floor(ini.HEALTH.c_main.v[4] * 255)):GetFloat4());
                    ini.HEALTH.c_background = imgui.ImFloat4(imgui.ImColor(math.floor(r / 4), math.floor(g / 4), math.floor(b / 4), math.floor(ini.HEALTH.c_background.v[4] * 255)):GetFloat4());
                  end
                end
            else
              sampev.onSetPlayerColor = 
              function(id, color) return {id, color}; end
            end
          end
        end
        if selected == 5 then
          imgui.BarCustomization(ini.ARMOR);
          imgui.Checkbox('Stop displaying when no armor', ini.ARMOR.b_zero_disable);
        end
        if selected == 6 then
          imgui.BarCustomization(ini.SPRINT);
          imgui.Checkbox('Stop displaying in water', ini.SPRINT.b_disable_in_water);
        end
        if selected == 7 then
          imgui.BarCustomization(ini.BREATHE);
          imgui.Checkbox('Stop displaying on land', ini.BREATHE.b_disable_on_foot);
        end
        if selected == 8 then
          if imgui.InputInt(fa.ICON_SLIDERS_H .. '  Radar X axis position', ini.RADAR.i_pos_x) then
            set_radar_pos(ini.RADAR.i_pos_x.v, ini.RADAR.i_pos_y.v);
          end 
          if imgui.InputInt(fa.ICON_SLIDERS_H .. '  Radar Y axis position', ini.RADAR.i_pos_y) then
            set_radar_pos(ini.RADAR.i_pos_x.v, ini.RADAR.i_pos_y.v);
          end
          if imgui.Button(fa.ICON_RETWEET .. '  Choose position', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function ()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
                local resx, resy = getScreenResolution();
                 while true do wait(0);
                
                  ini.RADAR.i_pos_x.v, ini.RADAR.i_pos_y.v = getCursorPos();
                  ini.RADAR.i_pos_x.v = math.floor(ini.RADAR.i_pos_x.v / resx * 640);
                  ini.RADAR.i_pos_y.v = 480 - math.floor(ini.RADAR.i_pos_y.v / resy * 480);
                  set_radar_pos(ini.RADAR.i_pos_x.v, ini.RADAR.i_pos_y.v);
                  sampSetCursorMode(3);
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return
    						  end
     					  end
    				  end)
          end
          if imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Width', ini.RADAR.i_size_x, 0, 640) then
            set_radar_size(ini.RADAR.i_size_x.v, ini.RADAR.i_size_y.v);
          end
          if imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Height', ini.RADAR.i_size_y, 0, 480) then
            set_radar_size(ini.RADAR.i_size_x.v, ini.RADAR.i_size_y.v);
          end
        end
        if selected == 0 then
          if imgui.Checkbox('Display custom Kill-List', ini.KILLLIST.b_on) then
            setStructElement(sampGetKillInfoPtr(), 0, 4, ((ini.GENERAL.on and ini.KILLLIST.b_on.v) and 0 or 1));
          end
          imgui.Checkbox('Display player ID\'s', ini.KILLLIST.b_show_id);
          imgui.RadioButton('From top to bottom', ini.KILLLIST.i_reverse, 0);
          imgui.RadioButton('From bottom to top', ini.KILLLIST.i_reverse, 1);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position', ini.KILLLIST.i_pos_x);
          imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position', ini.KILLLIST.i_pos_y);
          if imgui.Button(fa.ICON_RETWEET .. '  Choose position', imgui.ImVec2(225, 20)) then
            lua_thread.create(
	  	  		  function ()
	    				  window_state.v = false;
	     				  log('Choose position with your mouse and press the LMB');
	    			  	while true do wait(0);
                
                  ini.KILLLIST.i_pos_x.v, ini.KILLLIST.i_pos_y.v = getCursorPos();
                
                 sampSetCursorMode(3);
   
    						  if isKeyJustPressed(1) then
    							  sampSetCursorMode(0);
    							  log('Position is chosen');
    							  addOneOffSound(0, 0, 0, 1057);
     							  window_state.v = true;
    							  return;
    						  end
     					  end
              end)
          end
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Horizontal indent', ini.KILLLIST.i_indent_x, 0, 100);
          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Vertical indent', ini.KILLLIST.i_indent_y, 0, 100);
          imgui.Text('Alignment:');
          imgui.RadioButton('Left side', ini.KILLLIST.i_alignment, 0);
          imgui.SameLine();
          imgui.RadioButton('Middle', ini.KILLLIST.i_alignment, 1);
          imgui.SameLine();
          imgui.RadioButton('Right side', ini.KILLLIST.i_alignment, 2);
          imgui.Text('Icon position:');
          imgui.RadioButton('On the left', ini.KILLLIST.i_icon_pos, 0);
          imgui.SameLine();
          imgui.RadioButton('In the middle', ini.KILLLIST.i_icon_pos, 1);
          imgui.SameLine();
          imgui.RadioButton('On the right', ini.KILLLIST.i_icon_pos, 2);

          imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Icon size', ini.KILLLIST.i_icon_size, 1, 200);
          if imgui.SliderInt(fa.ICON_TIMES .. '  Maximum lines', ini.KILLLIST.i_lines, 1, 20) then
            if ini.KILLLIST.i_lines.v < #kill_lines then
              for i = ini.KILLLIST.i_lines.v + 1, #kill_lines do
                table.remove(kill_lines, i);
              end
            end
          end

          imgui.Text(fa.ICON_FONT .. string.format('  Font name (%s)', u8:decode(ini.KILLLIST.str_font.v)));

          if imgui.InputText('##font', ini.KILLLIST.str_font) then
            kill_list_font = renderCreateFont(u8:decode(ini.KILLLIST.str_font.v), ini.KILLLIST.i_font_size.v, ini.KILLLIST.i_font_flag.v);
          end

          if imgui.InputInt(fa.ICON_TEXT_WIDTH .. '  Font size', ini.KILLLIST.i_font_size) then
            ini.KILLLIST.i_font_size.v = limit_input(ini.KILLLIST.i_font_size.v, 1, 100);
            kill_list_font = renderCreateFont(ini.KILLLIST.str_font.v, ini.KILLLIST.i_font_size.v, ini.KILLLIST.i_font_flag.v);
          end

          if imgui.InputInt(fa.ICON_FLAG .. '  Font style', ini.KILLLIST.i_font_flag) then
            ini.KILLLIST.i_font_flag.v = limit_input(ini.KILLLIST.i_font_flag.v, 0, 100);
            kill_list_font = renderCreateFont(ini.KILLLIST.str_font.v, ini.KILLLIST.i_font_size.v, ini.KILLLIST.i_font_flag.v);
          end
        end
      imgui.EndChild();
      imgui.BeginChild(3, imgui.ImVec2(814, 84), true);
        imgui.DrawSelectBox({
          fa.ICON_DOLLAR_SIGN .. '  Money',
          fa.ICON_FIST_RAISED .. '  Weapon',
          fa.ICON_STAR ..        '  Wanted',
          fa.ICON_HEART ..       '  Health',
          fa.ICON_SHIELD_ALT ..  '  Armor',
          fa.ICON_RUNNING ..     '  Sprint',
          fa.ICON_MALE ..        '  Breathe',
          fa.ICON_ROUTE ..       '  Radar',
        }, 100, 75, 1, true, 0);
      imgui.EndChild();
    imgui.End();
  end
end

function imgui.BarCustomization(info)
  imgui.Checkbox('Enable', info.b_on);
  imgui.Checkbox('Display bar', info.b_bar);
  imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position', info.i_bar_pos_x);
  imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position', info.i_bar_pos_y);
  if imgui.Button(fa.ICON_RETWEET .. '  Choose position', imgui.ImVec2(225, 20)) then
    lua_thread.create(
      function ()
        window_state.v = false;
        log('Choose position with your mouse and press the LMB');
        while true do wait(0);
        
          info.i_bar_pos_x.v, info.i_bar_pos_y.v = getCursorPos();
        
          sampSetCursorMode(3);

          if isKeyJustPressed(1) then
            sampSetCursorMode(0);
            log('Position is chosen');
            addOneOffSound(0, 0, 0, 1057);
            window_state.v = true;
            return;
          end
         end
      end)
  end
  imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Bar width', info.i_bar_size_x, 0, 400);
  imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Bar height', info.i_bar_size_y, 0, 200);
  imgui.SliderInt(fa.ICON_SLIDERS_H .. '  Border thickness', info.i_border_size, 0, 20);
  imgui.ColorEdit4(fa.ICON_SPINNER .. '  Main color', info.c_main);
  imgui.ColorEdit4(fa.ICON_SPINNER .. '  Background color', info.c_background);
  imgui.ColorEdit4(fa.ICON_SPINNER .. '  Border color', info.c_border);

  imgui.Checkbox('Display text', info.b_text);
  imgui.InputInt(fa.ICON_SLIDERS_H .. '  X axis position##text', info.i_pos_x);
  imgui.InputInt(fa.ICON_SLIDERS_H .. '  Y axis position##text', info.i_pos_y);
  if imgui.Button(fa.ICON_RETWEET .. '  Choose position##text', imgui.ImVec2(225, 20)) then
    lua_thread.create(
      function ()
        window_state.v = false;
        log('Choose position with your mouse and press the LMB');
        while true do wait(0);
        
          info.i_pos_x.v, info.i_pos_y.v = getCursorPos();
        
          sampSetCursorMode(3);

          if isKeyJustPressed(1) then
            sampSetCursorMode(0);
            log('Position is chosen');
            addOneOffSound(0, 0, 0, 1057);
            window_state.v = true;
            return
          end
         end
      end)
  end
  imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  X scale', info.f_scale_x, 0, 20);
  imgui.SliderFloat(fa.ICON_SLIDERS_H .. '  Y scale', info.f_scale_y, 0, 20);
  imgui.ColorEdit4(fa.ICON_SPINNER .. '  Font color', info.c_text);
  imgui.ColorEdit4(fa.ICON_SPINNER .. '  Shadow color', info.c_shadow);
  imgui.Text('  Font style:');
  imgui.RadioButton('Subtitles', info.i_style, 1);
  imgui.SameLine();
  imgui.RadioButton('Menu', info.i_style, 2);
  imgui.SameLine();
  imgui.RadioButton('Gothic', info.i_style, 3);
  imgui.SameLine();
  imgui.RadioButton('Pricedown', info.i_style, 4);

  imgui.Text('  Alignment:');
  imgui.RadioButton('Left side', info.i_align, 1);
  imgui.SameLine();
  imgui.RadioButton('Middle', info.i_align, 2);
  imgui.SameLine();
  imgui.RadioButton('Right side', info.i_align, 3);
end

function to_imgui()
  for section_name, _ in pairs(ini) do 
    if section_name ~= 'GENERAL' then
      local settings = ini[section_name];
      for key, value in pairs(settings) do
        if key:find('b_') then settings[key] = imgui.ImBool(value); end
        if key:find('i_') then settings[key] = imgui.ImInt(value); end
        if key:find('f_') then settings[key] = imgui.ImFloat(value); end
        if key:find('str_') then
          local temp_str = value;
          settings[key] = imgui.ImBuffer(256);
          settings[key].v = u8(temp_str);
        end
        if key:find('c_') then
          local a, r, g, b = hex_to_argb(value);
          settings[key] = imgui.ImFloat4(imgui.ImColor(r, g, b, a):GetFloat4());
        end
      end
      ini[section_name] = settings;
    end
  end
end

function from_imgui()
  for section_name, _ in pairs(ini) do 
    if section_name ~= 'GENERAL' then
      settings = ini[section_name];
      for key, value in pairs(settings) do
        if key:find('b_') or key:find('i_') or key:find('f_') then settings[key] = value.v; end
        if key:find('str_') then settings[key] = u8:decode(value.v); end
        if key:find('c_') then
          settings[key] = imgui.ImColor(imgui.ImColor.FromFloat4(value.v[3], value.v[2], value.v[1], value.v[4]):GetVec4()):GetU32();
        end
      end
    end
  end
end

function imgui.DrawSelectBox(arr, button_size_x, button_size_y, i_indent, horizontal, addition)
  imgui.SetCursorPos(imgui.ImVec2(5,5));
  for i = 1, #arr do
    if imgui.CustomButton(arr[i], selected - addition == i and imgui.ImVec4(1.00, 0.28, 0.28, 1.00) or imgui.ImVec4(0.24, 0.24, 0.24, 1), 
    imgui.ImVec4(0.5, 0.14, 0.14, 1.00), imgui.ImVec4(0.25, 0.07, 0.07, 1), imgui.ImVec2(button_size_x, button_size_y)) then
      
      selected = (i + addition);
    end
    imgui.SetCursorPos(imgui.ImVec2(horizontal and (5 + i * button_size_x + (i - 1) * i_indent) or 5, (not horizontal) and  (5 + i * button_size_y + (i - 1) * i_indent) or 5));
  end
end

function imgui.CustomButton(name, color, colorHovered, colorActive, size)
  local clr = imgui.Col;
  imgui.PushStyleColor(clr.Button, color);
  imgui.PushStyleColor(clr.ButtonHovered, colorHovered);
  imgui.PushStyleColor(clr.ButtonActive, colorActive);
  if not size then size = imgui.ImVec2(0, 0); end
  local result = imgui.Button(name, size);
  imgui.PopStyleColor(3);
  return result;
end

function log(str) 
	sampAddChatMessage(string.format('{FB4343}[%s]{FFFFFF}: %s{FFFFFF}.', thisScript().name, str), -1);
end

function apply_style()
	imgui.SwitchContext();
    local style = imgui.GetStyle();
    local colors = style.Colors;
    local clr = imgui.Col;
    local ImVec4 = imgui.ImVec4;
    local ImVec2 = imgui.ImVec2;

    style.WindowPadding = imgui.ImVec2(8, 8);
    style.WindowRounding = 6;
    style.ChildWindowRounding = 5;
    style.FramePadding = imgui.ImVec2(5, 3);
    style.FrameRounding = 3.0;
    style.ItemSpacing = imgui.ImVec2(5, 4);
    style.ItemInnerSpacing = imgui.ImVec2(4, 4);
    style.IndentSpacing = 21;
    style.ScrollbarSize = 10.0;
    style.ScrollbarRounding = 13;
    style.GrabMinSize = 8;
    style.GrabRounding = 1;
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5);
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5);

    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end
apply_style();