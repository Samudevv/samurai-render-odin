package samurai-render

foreign import "system:samurai-render"

import _c "core:c"


error :: u64;
eglGetPlatformDisplayEXT_t :: #type proc(unamed0 : EGLenum, unamed1 : EGLNativeDisplayType, unamed2 : ^EGLint) -> EGLDisplay;
eglCreatePlatformWindowSurfaceEXT_t :: #type proc(unamed0 : EGLDisplay, unamed1 : EGLConfig, unamed2 : EGLNativeWindowType, unamed3 : ^EGLint) -> EGLSurface;
event_callback :: #type proc(ctx : ^context, event : ^event, user_data : rawptr);
render_callback :: #type proc(ctx : ^context, layer_surface : ^layer_surface, output_geo : rect, user_data : rawptr);
update_callback :: #type proc(ctx : ^context, delta_time : _c.double, user_data : rawptr);
on_layer_surface_configure_t :: #type proc(ctx : ^context, layer_surface : ^layer_surface, width : i32, height : i32);
render_start_t :: #type proc(ctx : ^context, layer_surface : ^layer_surface);
render_end_t :: #type proc(ctx : ^context, layer_surface : ^layer_surface);
destroy_t :: #type proc(ctx : ^context);
associate_layer_surface_t :: #type proc(ctx : ^context, layer_surface : ^layer_surface) -> u64;
unassociate_layer_surface_t :: #type proc(ctx : ^context, layer_surface : ^layer_surface);

event_type :: enum i32 {
    EVENT_LAYER_SURFACE_CONFIGURE,
    EVENT_POINTER_BUTTON,
    EVENT_POINTER_MOTION,
    EVENT_POINTER_ENTER,
    EVENT_POINTER_LEAVE,
    EVENT_KEYBOARD_KEY,
    EVENT_KEYBOARD_ENTER,
    EVENT_KEYBOARD_LEAVE,
    EVENT_TOUCH_DOWN,
    EVENT_TOUCH_UP,
    EVENT_TOUCH_MOTION,
};

screenshot_state :: enum i32 {
    SCREENSHOT_PENDING,
    SCREENSHOT_READY,
    SCREENSHOT_FAILED,
    SCREENSHOT_DONE,
};

backend_type :: enum i32 {
    BACKEND_RAW,
    BACKEND_OPENGL,
    BACKEND_CAIRO,
    BACKEND_NONE,
};

render_state :: enum i32 {
    ALWAYS,
    NONE,
    ONCE,
};

wl_buffer :: struct {};

shared_buffer :: struct {
    buffer : ^wl_buffer,
    data : rawptr,
    fd : _c.int,
    width : i32,
    height : i32,
    format : u32,
};

shared_buffer_result :: struct {
    result : ^shared_buffer,
    error : u64,
};

seat :: struct {
    seat : ^wl_seat,
    pointer : ^wl_pointer,
    keyboard : ^wl_keyboard,
    touch : ^wl_touch,
    pointer_focus : focus,
    keyboard_focus : focus,
    touch_focus : focus,
    name : cstring,
    last_pointer_enter : u32,
};

context :: struct {
    display : ^wl_display,
    shm : ^wl_shm,
    compositor : ^wl_compositor,
    layer_shell : ^zwlr_layer_shell_v1,
    output_manager : ^zxdg_output_manager_v1,
    screencopy_manager : ^zwlr_screencopy_manager_v1,
    cursor_engine : ^cursor_engine,
    seats : ^^seat,
    num_seats : _c.size_t,
    outputs : ^^output,
    num_outputs : _c.size_t,
    events : ^event,
    num_events : _c.size_t,
    cap_events : _c.size_t,
    event_index : _c.size_t,
    running : _c.int,
    render_state : render_state,
    backend : ^backend,
    config : context_config,
    app : app,
    frame_timer : frame_timer,
};

wl_cursor :: struct {};

wl_surface :: struct {};

wl_cursor_image :: struct {};

cursor :: struct {
    seat : ^seat,
    cursor : ^wl_cursor,
    surface : ^wl_surface,
    current_cursor_image : ^wl_cursor_image,
    current_image_index : _c.uint,
    current_time : _c.double,
};

wp_cursor_shape_manager_v1 :: struct {};

wl_cursor_theme :: struct {};

cursor_engine :: struct {
    manager : ^wp_cursor_shape_manager_v1,
    theme : ^wl_cursor_theme,
    cursors : ^cursor,
    num_cursors : _c.size_t,
};

cursor_engine_result :: struct {
    result : ^cursor_engine,
    error : u64,
};

rect :: struct {
    x : i32,
    y : i32,
    w : i32,
    h : i32,
};

output :: struct {
    output : ^wl_output,
    xdg_output : ^zxdg_output_v1,
    sfc : ^^layer_surface,
    num_sfc : _c.size_t,
    geo : rect,
    name : cstring,
    scale : i32,
    refresh_rate : i32,
};

layer_surface :: struct {
    surface : ^wl_surface,
    layer_surface : ^zwlr_layer_surface_v1,
    backend_data : rawptr,
    w : u32,
    h : u32,
    callback_data : ^callback_data,
    not_ready : _c.int,
    dirty : _c.int,
    configured : _c.int,
    frame_start_time : _c.double,
    frame_delta_time : _c.double,
};

focus :: struct {
    output : ^output,
    surface : ^layer_surface,
};

wl_seat :: struct {};

wl_pointer :: struct {};

wl_keyboard :: struct {};

wl_touch :: struct {};

seat_result :: struct {
    result : ^seat,
    error : u64,
};

zwlr_layer_surface_v1 :: struct {};

callback_data :: struct {};

layer_surface_result :: struct {
    result : ^layer_surface,
    error : u64,
};

event :: struct {
    type : _c.int,
    seat : ^seat,
    output : ^output,
    surface : ^layer_surface,
    button : u32,
    state : u32,
    width : u32,
    height : u32,
    x : _c.double,
    y : _c.double,
    touch_id : i32,
};

wl_output :: struct {};

zxdg_output_v1 :: struct {};

screenshot_data :: struct {
    ctx : ^context,
    output : ^output,
    buffer_rs : shared_buffer_result,
    state : screenshot_state,
};

output_result :: struct {
    result : ^output,
    error : u64,
};

frame_timer :: struct {
    max_update_frequency : u32,
    update_frequency : u32,
    delta_time : _c.double,
    start_time : _c.double,
    raw_delta_time : _c.double,
    raw_delta_times : [11]_c.double,
    current_raw_delta_times_index : _c.size_t,
    num_raw_delta_times : _c.size_t,
    mean_delta_time : _c.double,
    smoothed_delta_times : [11]_c.double,
};

cairo_surface :: struct {
    buffer : ^shared_buffer,
    cairo_surface : ^cairo_surface_t,
    cairo : ^cairo_t,
};

backend :: struct {
    on_layer_surface_configure : on_layer_surface_configure_t,
    render_start : render_start_t,
    render_end : render_end_t,
    destroy : destroy_t,
    associate_layer_surface : associate_layer_surface_t,
    unassociate_layer_surface : unassociate_layer_surface_t,
};

backend_cairo :: struct {
    base : backend,
};

backend_cairo_result :: struct {
    result : ^backend_cairo,
    error : u64,
};

raw_surface :: struct {
    buffer : ^shared_buffer,
};

backend_raw :: struct {
    base : backend,
};

backend_raw_result :: struct {
    result : ^backend_raw,
    error : u64,
};

opengl_config :: struct {
    red_size : _c.int,
    green_size : _c.int,
    blue_size : _c.int,
    alpha_size : _c.int,
    samples : _c.int,
    depth_size : _c.int,
    major_version : _c.int,
    minor_version : _c.int,
    profile_mask : _c.int,
    debug : _c.int,
    color_space : _c.int,
    render_buffer : _c.int,
};

wl_egl_window :: struct {};

opengl_surface :: struct {
    surface : EGLSurface,
    egl_window : ^wl_egl_window,
};

backend_opengl :: struct {
    base : backend,
    display : EGLDisplay,
    _context : EGLContext,
    config : EGLConfig,
    cfg : ^opengl_config,
};

backend_opengl_result :: struct {
    result : ^backend_opengl,
    error : u64,
};

app :: struct {
    on_event : event_callback,
    on_render : render_callback,
    on_update : update_callback,
};

context_config :: struct {
    backend : backend_type,
    pointer_interaction : _c.int,
    keyboard_interaction : _c.int,
    touch_interaction : _c.int,
    max_update_frequency : u32,
    gl : ^opengl_config,
    not_create_output_layer_surfaces : _c.int,
    not_request_frame : _c.int,
    on_event : event_callback,
    on_render : render_callback,
    on_update : update_callback,
    user_data : rawptr,
};

wl_display :: struct {};

wl_shm :: struct {};

wl_compositor :: struct {};

zwlr_layer_shell_v1 :: struct {};

zxdg_output_manager_v1 :: struct {};

zwlr_screencopy_manager_v1 :: struct {};

registry_data :: struct {
    seats : ^^wl_seat,
    num_seats : _c.size_t,
    outputs : ^^wl_output,
    num_outputs : _c.size_t,
    cursor_manager : ^wp_cursor_shape_manager_v1,
};

context_result :: struct {
    result : ^context,
    error : u64,
};

backend_result :: struct {
    result : ^backend,
    error : u64,
};

@(default_calling_convention="c")
foreign samurai-render {

    @(link_name="eglGetPlatformDisplayEXT")
    eglGetPlatformDisplayEXT : eglGetPlatformDisplayEXT_t;

    @(link_name="eglCreatePlatformWindowSurfaceEXT")
    eglCreatePlatformWindowSurfaceEXT : eglCreatePlatformWindowSurfaceEXT_t;

    @(link_name="samure_strerror")
    samure_strerror :: proc(error_code : u64) -> cstring ---;

    @(link_name="samure_build_error_string")
    samure_build_error_string :: proc(error_code : u64) -> cstring ---;

    @(link_name="samure_perror")
    samure_perror :: proc(msg : cstring, error_code : u64) -> _c.int ---;

    @(link_name="_samure_shared_buffer_unwrap")
    _samure_shared_buffer_unwrap :: proc(rs : shared_buffer_result) -> ^shared_buffer ---;

    @(link_name="samure_create_shared_buffer")
    samure_create_shared_buffer :: proc(shm : ^wl_shm, format : u32, width : i32, height : i32) -> shared_buffer_result ---;

    @(link_name="samure_destroy_shared_buffer")
    samure_destroy_shared_buffer :: proc(b : ^shared_buffer) ---;

    @(link_name="samure_shared_buffer_copy")
    samure_shared_buffer_copy :: proc(dst : ^shared_buffer, src : ^shared_buffer) -> u64 ---;

    @(link_name="samure_init_cursor")
    samure_init_cursor :: proc(seat : ^seat, theme : ^wl_cursor_theme, compositor : ^wl_compositor) -> cursor ---;

    @(link_name="samure_destroy_cursor")
    samure_destroy_cursor :: proc(cursor : cursor) ---;

    @(link_name="samure_cursor_set_shape")
    samure_cursor_set_shape :: proc(cursor : ^cursor, theme : ^wl_cursor_theme, name : cstring) ---;

    @(link_name="_samure_cursor_engine_unwrap")
    _samure_cursor_engine_unwrap :: proc(rs : cursor_engine_result) -> ^cursor_engine ---;

    @(link_name="samure_create_cursor_engine")
    samure_create_cursor_engine :: proc(ctx : ^context, manager : ^wp_cursor_shape_manager_v1) -> cursor_engine_result ---;

    @(link_name="samure_destroy_cursor_engine")
    samure_destroy_cursor_engine :: proc(engine : ^cursor_engine) ---;

    @(link_name="samure_cursor_engine_set_shape")
    samure_cursor_engine_set_shape :: proc(engine : ^cursor_engine, seat : ^seat, shape : u32) ---;

    @(link_name="samure_cursor_engine_pointer_enter")
    samure_cursor_engine_pointer_enter :: proc(engine : ^cursor_engine, seat : ^seat) ---;

    @(link_name="samure_cursor_engine_update")
    samure_cursor_engine_update :: proc(engine : ^cursor_engine, delta_time : _c.double) ---;

    @(link_name="samure_circle_in_output")
    samure_circle_in_output :: proc(output_geo : rect, circle_x : i32, circle_y : i32, radius : i32) -> _c.int ---;

    @(link_name="samure_rect_in_output")
    samure_rect_in_output :: proc(output_geo : rect, rect_x : i32, rect_y : i32, rect_w : i32, rect_h : i32) -> _c.int ---;

    @(link_name="samure_square_in_output")
    samure_square_in_output :: proc(output_geo : rect, square_x : i32, square_y : i32, square_size : i32) -> _c.int ---;

    @(link_name="samure_point_in_output")
    samure_point_in_output :: proc(output_geo : rect, point_x : i32, point_y : i32) -> _c.int ---;

    @(link_name="samure_triangle_in_output")
    samure_triangle_in_output :: proc(output_geo : rect, tri_x1 : i32, tri_y1 : i32, tri_x2 : i32, tri_y2 : i32, tri_x3 : i32, tri_y3 : i32) -> _c.int ---;

    @(link_name="_samure_seat_unwrap")
    _samure_seat_unwrap :: proc(rs : seat_result) -> ^seat ---;

    @(link_name="samure_create_seat")
    samure_create_seat :: proc(ctx : ^context, seat : ^wl_seat) -> seat_result ---;

    @(link_name="samure_destroy_seat")
    samure_destroy_seat :: proc(seat : ^seat) ---;

    @(link_name="_samure_layer_surface_unwrap")
    _samure_layer_surface_unwrap :: proc(rs : layer_surface_result) -> ^layer_surface ---;

    @(link_name="samure_create_layer_surface")
    samure_create_layer_surface :: proc(ctx : ^context, output : ^output, layer : u32, anchor : u32, keyboard_interaction : _c.int, pointer_interaction : _c.int, backend_association : _c.int) -> layer_surface_result ---;

    @(link_name="samure_destroy_layer_surface")
    samure_destroy_layer_surface :: proc(ctx : ^context, sfc : ^layer_surface) ---;

    @(link_name="samure_layer_surface_draw_buffer")
    samure_layer_surface_draw_buffer :: proc(sfc : ^layer_surface, buf : ^shared_buffer) ---;

    @(link_name="samure_layer_surface_request_frame")
    samure_layer_surface_request_frame :: proc(ctx : ^context, sfc : ^layer_surface, geo : rect) ---;

    @(link_name="_samure_output_unwrap")
    _samure_output_unwrap :: proc(rs : output_result) -> ^output ---;

    @(link_name="samure_create_output")
    samure_create_output :: proc(ctx : ^context, output : ^wl_output) -> output_result ---;

    @(link_name="samure_destroy_output")
    samure_destroy_output :: proc(ctx : ^context, output : ^output) ---;

    @(link_name="samure_output_set_pointer_interaction")
    samure_output_set_pointer_interaction :: proc(ctx : ^context, output : ^output, enable : _c.int) ---;

    @(link_name="samure_output_set_input_regions")
    samure_output_set_input_regions :: proc(ctx : ^context, output : ^output, rects : ^rect, num_rects : _c.size_t) ---;

    @(link_name="samure_output_set_keyboard_interaction")
    samure_output_set_keyboard_interaction :: proc(output : ^output, enable : _c.int) ---;

    @(link_name="samure_output_attach_layer_surface")
    samure_output_attach_layer_surface :: proc(output : ^output, layer_surface : ^layer_surface) ---;

    @(link_name="samure_output_screenshot")
    samure_output_screenshot :: proc(ctx : ^context, output : ^output, capture_cursor : _c.int) -> shared_buffer_result ---;

    @(link_name="samure_init_frame_timer")
    samure_init_frame_timer :: proc(max_fps : u32) -> frame_timer ---;

    @(link_name="samure_frame_timer_start_frame")
    samure_frame_timer_start_frame :: proc(f : ^frame_timer) ---;

    @(link_name="samure_frame_timer_end_frame")
    samure_frame_timer_end_frame :: proc(f : ^frame_timer) ---;

    @(link_name="samure_get_time")
    samure_get_time :: proc() -> _c.double ---;

    @(link_name="_samure_backend_cairo_unwrap")
    _samure_backend_cairo_unwrap :: proc(rs : backend_cairo_result) -> ^backend_cairo ---;

    @(link_name="samure_init_backend_cairo")
    samure_init_backend_cairo :: proc(ctx : ^context) -> backend_cairo_result ---;

    @(link_name="samure_destroy_backend_cairo")
    samure_destroy_backend_cairo :: proc(ctx : ^context) ---;

    @(link_name="samure_backend_cairo_render_end")
    samure_backend_cairo_render_end :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_backend_cairo_associate_layer_surface")
    samure_backend_cairo_associate_layer_surface :: proc(ctx : ^context, layer_surface : ^layer_surface) -> u64 ---;

    @(link_name="samure_backend_cairo_on_layer_surface_configure")
    samure_backend_cairo_on_layer_surface_configure :: proc(ctx : ^context, layer_surface : ^layer_surface, width : i32, height : i32) ---;

    @(link_name="samure_backend_cairo_unassociate_layer_surface")
    samure_backend_cairo_unassociate_layer_surface :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_get_backend_cairo")
    samure_get_backend_cairo :: proc(ctx : ^context) -> ^backend_cairo ---;

    @(link_name="samure_get_cairo_surface")
    samure_get_cairo_surface :: proc(layer_surface : ^layer_surface) -> ^cairo_surface ---;

    @(link_name="_samure_cairo_surface_create_cairo")
    _samure_cairo_surface_create_cairo :: proc(c : ^cairo_surface) -> u64 ---;

    @(link_name="_samure_backend_raw_unwrap")
    _samure_backend_raw_unwrap :: proc(rs : backend_raw_result) -> ^backend_raw ---;

    @(link_name="samure_init_backend_raw")
    samure_init_backend_raw :: proc(ctx : ^context) -> backend_raw_result ---;

    @(link_name="samure_destroy_backend_raw")
    samure_destroy_backend_raw :: proc(ctx : ^context) ---;

    @(link_name="samure_backend_raw_render_end")
    samure_backend_raw_render_end :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_backend_raw_associate_layer_surface")
    samure_backend_raw_associate_layer_surface :: proc(ctx : ^context, sfc : ^layer_surface) -> u64 ---;

    @(link_name="samure_backend_raw_on_layer_surface_configure")
    samure_backend_raw_on_layer_surface_configure :: proc(ctx : ^context, layer_surface : ^layer_surface, width : i32, height : i32) ---;

    @(link_name="samure_backend_raw_unassociate_layer_surface")
    samure_backend_raw_unassociate_layer_surface :: proc(ctx : ^context, sfc : ^layer_surface) ---;

    @(link_name="samure_get_backend_raw")
    samure_get_backend_raw :: proc(ctx : ^context) -> ^backend_raw ---;

    @(link_name="samure_get_raw_surface")
    samure_get_raw_surface :: proc(layer_surface : ^layer_surface) -> ^raw_surface ---;

    @(link_name="samure_default_opengl_config")
    samure_default_opengl_config :: proc() -> ^opengl_config ---;

    @(link_name="_samure_backend_opengl_unwrap")
    _samure_backend_opengl_unwrap :: proc(rs : backend_opengl_result) -> ^backend_opengl ---;

    @(link_name="samure_init_backend_opengl")
    samure_init_backend_opengl :: proc(ctx : ^context, cfg : ^opengl_config) -> backend_opengl_result ---;

    @(link_name="samure_destroy_backend_opengl")
    samure_destroy_backend_opengl :: proc(ctx : ^context) ---;

    @(link_name="samure_backend_opengl_render_start")
    samure_backend_opengl_render_start :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_backend_opengl_render_end")
    samure_backend_opengl_render_end :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_backend_opengl_associate_layer_surface")
    samure_backend_opengl_associate_layer_surface :: proc(ctx : ^context, layer_surface : ^layer_surface) -> u64 ---;

    @(link_name="samure_backend_opengl_on_layer_surface_configure")
    samure_backend_opengl_on_layer_surface_configure :: proc(ctx : ^context, layer_surface : ^layer_surface, width : i32, height : i32) ---;

    @(link_name="samure_backend_opengl_unassociate_layer_surface")
    samure_backend_opengl_unassociate_layer_surface :: proc(ctx : ^context, layer_surface : ^layer_surface) ---;

    @(link_name="samure_get_backend_opengl")
    samure_get_backend_opengl :: proc(ctx : ^context) -> ^backend_opengl ---;

    @(link_name="samure_get_opengl_surface")
    samure_get_opengl_surface :: proc(layer_surface : ^layer_surface) -> ^opengl_surface ---;

    @(link_name="samure_backend_opengl_make_context_current")
    samure_backend_opengl_make_context_current :: proc(gl : ^backend_opengl, layer_surface : ^layer_surface) ---;

    @(link_name="samure_create_context_config")
    samure_create_context_config :: proc(event_callback : event_callback, render_callback : render_callback, update_callback : update_callback, user_data : rawptr) -> context_config ---;

    @(link_name="_samure_context_unwrap")
    _samure_context_unwrap :: proc(rs : context_result) -> ^context ---;

    @(link_name="samure_create_context")
    samure_create_context :: proc(config : ^context_config) -> context_result ---;

    @(link_name="samure_create_context_with_backend")
    samure_create_context_with_backend :: proc(config : ^context_config, backend : ^backend) -> context_result ---;

    @(link_name="samure_destroy_context")
    samure_destroy_context :: proc(ctx : ^context) ---;

    @(link_name="samure_context_run")
    samure_context_run :: proc(ctx : ^context) ---;

    @(link_name="samure_context_get_output_rect")
    samure_context_get_output_rect :: proc(ctx : ^context) -> rect ---;

    @(link_name="samure_context_set_pointer_interaction")
    samure_context_set_pointer_interaction :: proc(ctx : ^context, enable : _c.int) ---;

    @(link_name="samure_context_set_input_regions")
    samure_context_set_input_regions :: proc(ctx : ^context, rects : ^rect, num_rects : _c.size_t) ---;

    @(link_name="samure_context_set_keyboard_interaction")
    samure_context_set_keyboard_interaction :: proc(ctx : ^context, enable : _c.int) ---;

    @(link_name="samure_context_process_events")
    samure_context_process_events :: proc(ctx : ^context) ---;

    @(link_name="samure_context_render_layer_surface")
    samure_context_render_layer_surface :: proc(ctx : ^context, sfc : ^layer_surface, geo : rect) ---;

    @(link_name="samure_context_render_output")
    samure_context_render_output :: proc(ctx : ^context, output : ^output) ---;

    @(link_name="samure_context_update")
    samure_context_update :: proc(ctx : ^context, delta_time : _c.double) ---;

    @(link_name="samure_context_create_output_layer_surfaces")
    samure_context_create_output_layer_surfaces :: proc(ctx : ^context) -> u64 ---;

    @(link_name="samure_context_set_pointer_shape")
    samure_context_set_pointer_shape :: proc(ctx : ^context, shape : u32) ---;

    @(link_name="samure_context_set_render_state")
    samure_context_set_render_state :: proc(ctx : ^context, render_state : render_state) ---;

    @(link_name="_samure_backend_unwrap")
    _samure_backend_unwrap :: proc(rs : backend_result) -> ^backend ---;

    @(link_name="samure_create_backend")
    samure_create_backend :: proc(on_layer_surface_configure : on_layer_surface_configure_t, render_start : render_start_t, render_end : render_end_t, destroy : destroy_t, associate_layer_surface : associate_layer_surface_t, unassociate_layer_surface : unassociate_layer_surface_t) -> backend_result ---;

}