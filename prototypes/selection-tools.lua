-- Author: k1ng440 (Asaduzzaman pavel) <contact@iampavel.dev>
data:extend({
    {
        name = "issm",
        type = "selection-tool",
        flags = { "hidden", "not-stackable", "spawnable", "only-in-cursor" },
        stackable = false,
        stack_size = 1,
        show_in_library = false,
        icon = "__inserter-stack-size-modifier__/graphics/icons/shortcut.png",
        icon_size = 64,
        selection_color = { b = 210, g = 210, r = 210 },
        alt_selection_color = { b = 210, g = 210, r = 210 },
        selection_mode = { "entity-with-health" },
        alt_selection_mode = { "entity-with-health" },
        selection_cursor_box_type = "entity",
        alt_selection_cursor_box_type = "entity",
        entity_filters = { "stack-filter-inserter", "stack-inserter" },
        alt_entity_filters = { "stack-filter-inserter", "stack-inserter" },
        entity_filter_mode = "whitelist",
        alt_entity_filter_mode = "whitelist",
    }
})
