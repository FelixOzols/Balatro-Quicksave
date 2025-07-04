-- Copyright (C) 2025 Felix Ozols
-- 
-- This file is part of Balatro-Quicksave.
-- 
-- Balatro-Quicksave is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- Balatro-Quicksave is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with quicksave.  If not, see <https://www.gnu.org/licenses/>.

-- hardcoding is lame but the alternative is regex or using stdio which has its own caveats
local relative_dir = '/Mods/Balatro-Quicksave-main'

G.FUNCS.QS_Save = function(e)
    save_run()

    if not G.ARGS.save_run then return end
    local save_string = STR_PACK(G.ARGS.save_run)
    save_string = love.data.compress('string', 'deflate', save_string, 1)
    love.filesystem.write(relative_dir..'/'..'quicksave.jkr', save_string)
end

G.FUNCS.QS_Load = function(e)
    if not love.filesystem.getInfo(relative_dir..'/'..'quicksave.jkr', 'file') then return end

    G:delete_run()
    
    G.SAVED_GAME = get_compressed(relative_dir..'/'..'quicksave.jkr')
    if G.SAVED_GAME ~= nil then G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME) end

    G:start_run({savetext = G.SAVED_GAME})
end

local createHUDRef = create_UIBox_HUD
function create_UIBox_HUD()
    local contents = createHUDRef()

    local saveUI = {n=G.UIT.R, config={align = "cm", id = 'save_manager', colour=G.C.CLEAR, padding=0.1}, nodes={
        UIBox_button{ label = {"Save"}, button = "QS_Save", minw = 2.3, col = true, colour = G.C.PURPLE},
        UIBox_button{ label = {"Load"}, button = "QS_Load", minw = 2.3, col = true, colour = G.C.GREEN}
    }}

    for i, v in ipairs(contents.nodes[1].nodes[1].nodes) do
        if v.config.id == "hand_text_area" then
            table.insert(contents.nodes[1].nodes[1].nodes, i+1, saveUI)
            break
        end
    end

    return contents
end

SMODS.Keybind({key_pressed='f5', action=G.FUNCS.QS_Save})
SMODS.Keybind({key_pressed='f9', action=G.FUNCS.QS_Load})
