require('prototypes.inputs');
require('prototypes.shortcuts');
require('prototypes.selection-tools');


local styles = data.raw["gui-style"].default

styles["issm_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on",
    bottom_margin = 4,
}

styles["issm_titlebar_drag_handle"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    height = 24,
    horizontally_stretchable = "on",
    right_margin = 4,
}

styles["issm_control_flow_drag_handle"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    height = 32,
    horizontally_stretchable = "on",
    right_margin = 4,
}

styles["issm_textfield"] = {
    type = "textbox_style",
    width = 36
}

styles["issm_slider"] = {
    type = "slider_style",
    parent = "slider",
    horizontally_stretchable = "on",
    top_margin = 6,
}
