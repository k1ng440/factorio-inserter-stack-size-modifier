-- Author: k1ng440 (Asaduzzaman pavel) <contact@iampavel.dev>
-- description: Change maximum stack size of inserter.

local M = {
    selected_inserters = {},
    gui = {
        elements = {},
        names = {
            frame = "issm",
            titlebar_flow = "issm-titlebar-flow",
            inner_frame = "issm-inner-frame",
            slider = "issm-slider",
            textfield = "issm-textfield",
            button = "issm-button",
            close_button = "issm-close-button",
        }
    }
}

function M.show_gui(player, event)
    local gui = {}

    gui.window = player.gui.screen.add({
        type = "frame",
        name = M.gui.names.frame,
        style = "quick_bar_window_frame",
        direction = "vertical"
    })

    gui.window.style.size = { 400, 140 }
    gui.window.auto_center = true

    -- Title bar
    gui.titlebar_flow = gui.window.add({
        type = "flow",
        name = M.gui.names.titlebar_flow,
        direction = "horizontal",
        horizontal_spacing = 8,
    })

    gui.titlebar_flow.add({
        type = "label",
        name = "titlebar_label",
        style = "frame_title",
        caption = { "gui.issm-caption" },
        ignored_by_interaction = true,
    })

    gui.titlebar_flow.add({
        type = "empty-widget",
        name = "drag-handle",
        style = "issm_titlebar_drag_handle",
        ignored_by_interaction = true,
    })

    gui.titlebar_flow.add({
        type = "sprite-button",
        name = M.gui.names.close_button,
        style = "frame_action_button",
        sprite = "utility/close_white",
    })

    -- Main content
    gui.content_frame = gui.window.add({
        type = "frame",
        name = M.gui.names.inner_frame,
        direction = "vertical",
        style = "issm_content_frame",
    })

    gui.slider_flow = gui.content_frame.add {
        type = "flow",
        name = "slider_panel",
        direction = "horizontal"
    }

    gui.slider_flow.add({
        type = "label",
        caption = { "gui.override-inserter-stack-size" },
        style = "caption_label"
    })

    gui.slider = gui.slider_flow.add({
        type = "slider",
        name = M.gui.names.slider,
        minimum_value = 1,
        maximum_value = 12,
        value_step = 1,
        value = 10,
        style = "issm_slider"
    })

    gui.textfield = gui.slider_flow.add({
        type = "textfield",
        name = M.gui.names.textfield,
        text = "10",
        numeric = true,
        allow_decimal = false,
        allow_negative = false,
        allow_sign = false,
        allow_characters = false,
        style = "issm_textfield"
    })

    -- Controls flow
    gui.controls_flow = gui.window.add { type = "flow", name = "controls_flow", direction = "horizontal" }

    gui.close_button = gui.controls_flow.add {
        type = "button",
        name = M.gui.names.close_button,
        caption = { "gui.issm-cancel-button" },
        style = "back_button",
    }

    gui.controls_flow.add({
        type = "empty-widget",
        name = "drag-handle",
        style = "issm_control_flow_drag_handle",
        ignored_by_interaction = true,
    })

    gui.submit_button = gui.controls_flow.add {
        type = "button",
        name = M.gui.names.button,
        caption = { "gui.issm-submit-button" },
        style = "confirm_button",
    }

    M.gui.elements = gui
    player.opened = gui.window
end

function M.on_gui_value_changed(event)
    local player = game.players[event.player_index]
    local element = event.element

    if not player or not player.valid or not element or not element.valid then
        return
    end

    if element.name == M.gui.names.slider then
        M.gui.elements.textfield.text = tostring(element.slider_value)
    end
end

function M.on_gui_text_changed(event)
    local player = game.players[event.player_index]
    local element = event.element

    if not player or not player.valid or not element or not element.valid then
        return
    end

    if element.name == M.gui.names.textfield then
        if tonumber(element.text) == nil then
            return
        elseif tonumber(element.text) > 12 then
            element.text = "12"
        else
            M.gui.elements.slider.slider_value = tonumber(element.text)
        end
    end
end

function M.on_gui_click(event)
    local player = game.players[event.player_index]
    local element = event.element

    if not player or not player.valid or not element or not element.valid or not M.gui.elements.window then
        return
    end

    if element.name == M.gui.names.close_button then
        M.gui.elements.window.destroy()
        M.gui.elements = {}
        return
    end

    if element.name == M.gui.names.button then
        local value = tonumber(M.gui.elements.textfield.text)
        if value == nil then
            game.print("Invalid value provided for inserter stack size override.")
            return
        end

        for _, entity in pairs(M.selected_inserters) do
            if entity and entity.valid then
                entity.inserter_stack_size_override = value
            end
        end

        M.gui.elements.window.destroy()
        M.gui.elements = {}
        return
    end
end

function M.on_gui_closed(event) 
    local player = game.players[event.player_index]
    local element = event.element

    if not player or not player.valid or not element or not element.valid or not M.gui.elements.window then
        return
    end

    if element.name == M.gui.names.frame then
        M.gui.elements.window.destroy()
        M.gui.elements = {}
        return
    end
end

function M.provide_selectiontool(event)
    local player = game.players[event.player_index]

    if not player or not player.valid then
        return
    end

    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read and player.cursor_stack.name == "issm" then
        return
    end

    if not player.clear_cursor() then
        return
    end

    player.cursor_stack.set_stack({
        name = "issm",
        count = 1
    })
end

function M.on_shortcut(event)
    local player = game.players[event.player_index]

    if not player or not player.valid or not event.prototype_name or event.prototype_name ~= "issm" then
        return
    end

    M.provide_selectiontool(event)
end

function M.on_custom_input(event)
    local player = game.players[event.player_index]

    if not player or not player.valid or not event.input_name or event.input_name ~= "issm" then
        return
    end

    M.provide_selectiontool(event)
end

function M.on_selection_tool(event)
    local player = game.players[event.player_index]

    if not player or not player.valid or event.item ~= "issm" then
        return
    end

    M.selected_inserters = {}
    for _, entity in pairs(event.entities) do
        if entity.valid then
            table.insert(M.selected_inserters, entity)
        end
    end

    if #M.selected_inserters == 0 then
        return
    end

    M.show_gui(player, event)
end

script.on_event(defines.events.on_lua_shortcut, M.on_shortcut)
script.on_event(defines.events.on_player_selected_area, M.on_selection_tool)
script.on_event(defines.events.on_player_alt_selected_area, M.on_selection_tool)
script.on_event("issm", M.on_custom_input)
script.on_event(defines.events.on_gui_click, M.on_gui_click)
script.on_event(defines.events.on_gui_text_changed, M.on_gui_text_changed)
script.on_event(defines.events.on_gui_value_changed, M.on_gui_value_changed)
script.on_event(defines.events.on_gui_closed, M.on_gui_closed)
