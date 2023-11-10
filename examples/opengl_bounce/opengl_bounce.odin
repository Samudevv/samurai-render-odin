package main

import samure "../../."
import "core:c/libc"
import "core:dynlib"
import "core:fmt"
import "core:math/linalg/glsl"
import "core:math/rand"
import "core:os"
import "core:strings"


import gl "vendor:OpenGL"

GL_LIB :: "libGL.so"
gl_lib: dynlib.Library

VERT_SRC :: `#version 330 core
#extension GL_ARB_explicit_uniform_location : require
layout (location = 0) in vec3 aPos;

layout (location = 1) uniform mat4 proj;

void main()
{
   gl_Position = proj * vec4(aPos.x, aPos.y, aPos.z, 1.0);
}`

FRAG_SRC :: `#version 330 core
out vec4 FragColor;
void main()
{
   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}`

shader_prog: u32
vbo, vao, ebo: u32

ball_x, ball_y: f32
ball_angle: f32

main :: proc() {
    ok: bool
    gl_lib, ok = dynlib.load_library(GL_LIB)
    if !ok {
        fmt.eprintf("failed to load %s\n", GL_LIB)
        os.exit(1)
    }
    defer dynlib.unload_library(gl_lib)

    gl_cfg: samure.opengl_config
    cfg := samure.create_context_config(on_event, on_render, on_update, nil)
    cfg.gl = samure.default_opengl_config()
    cfg.backend = samure.backend_type.OPENGL
    cfg.pointer_interaction = true
    cfg.gl.major_version = 4
    cfg.gl.minor_version = 6
    cfg.gl.samples = 8

    ctx, err := samure.create_context(&cfg)
    if err != samure.ERROR_NONE {
        samure.perror("failed to create context", err)
        os.exit(1)
    }
    defer samure.destroy_context(ctx)

    samure.backend_opengl_make_context_current(
        samure.get_backend_opengl(ctx),
        nil,
    )

    gl.load_up_to(4, 6, glGetProcAddress)
    fmt.printf("OpenGL %s\n", gl.GetString(gl.VERSION))

    // build and compile shader
    vert_src := strings.clone_to_cstring(VERT_SRC)
    frag_src := strings.clone_to_cstring(FRAG_SRC)
    vert := gl.CreateShader(gl.VERTEX_SHADER)
    frag := gl.CreateShader(gl.FRAGMENT_SHADER)
    gl.ShaderSource(vert, 1, &vert_src, nil)
    gl.ShaderSource(frag, 1, &frag_src, nil)

    gl.CompileShader(vert)
    gl.CompileShader(frag)

    success: i32
    shader_failed: bool
    log: [512]u8
    gl.GetShaderiv(vert, gl.COMPILE_STATUS, &success)
    if success == 0 {
        gl.GetShaderInfoLog(vert, 512, nil, cast([^]u8)&log)
        log_str := strings.clone_from_bytes(log[:])
        fmt.eprintf("ERROR::VERTEX: %s\n", log_str)
        shader_failed = true
    } else {
        fmt.println("INFO::VERTEX: Successfully compiled")
    }
    gl.GetShaderiv(frag, gl.COMPILE_STATUS, &success)
    if success == 0 {
        gl.GetShaderInfoLog(frag, 512, nil, cast([^]u8)&log)
        log_str := strings.clone_from_bytes(log[:])
        fmt.eprintf("ERROR::FRAGMENT: %s\n", log_str)
        shader_failed = true
    } else {
        fmt.println("INFO::FRAGMENT: Successfully compiled")
    }

    if shader_failed {
        os.exit(1)
    }

    shader_prog = gl.CreateProgram()
    gl.AttachShader(shader_prog, vert)
    gl.AttachShader(shader_prog, frag)
    gl.LinkProgram(shader_prog)

    gl.GetProgramiv(shader_prog, gl.LINK_STATUS, &success)
    if success == 0 {
        gl.GetProgramInfoLog(shader_prog, 512, nil, cast([^]u8)&log)
        log_str := strings.clone_from_bytes(log[:])
        fmt.eprintf("ERROR::PROGRAM: %s\n", log_str)
        shader_failed = true
    } else {
        fmt.println("INFO::PROGRAM: Successfully linked")
    }
    gl.DeleteShader(vert)
    gl.DeleteShader(frag)

    if shader_failed {
        os.exit(1)
    }
    defer gl.DeleteProgram(shader_prog)

    vertices := [12]f32 {
        0.5,
        0.5,
        0.0, // top right
        0.5,
        -0.5,
        0.0, // bottom right
        -0.5,
        -0.5,
        0.0, // bottom left
        -0.5,
        0.5,
        0.0, // top left
    }
    indices := [6]u32 {
        // note that we start from 0!
        0,
        1,
        3, // first Triangle
        1,
        2,
        3, // second Triangle
    }

    gl.GenVertexArrays(1, &vao)
    gl.GenBuffers(1, &vbo)
    gl.GenBuffers(1, &ebo)
    defer gl.DeleteVertexArrays(1, &vao)
    defer gl.DeleteBuffers(1, &vbo)
    defer gl.DeleteBuffers(1, &ebo)

    gl.BindVertexArray(vao)

    gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
    gl.BufferData(
        gl.ARRAY_BUFFER,
        size_of(vertices),
        &vertices,
        gl.STATIC_DRAW,
    )
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
    gl.BufferData(
        gl.ELEMENT_ARRAY_BUFFER,
        size_of(indices),
        &indices,
        gl.STATIC_DRAW,
    )

    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)
    gl.EnableVertexAttribArray(0)

    gl.ValidateProgram(shader_prog)
    gl.GetProgramiv(shader_prog, gl.VALIDATE_STATUS, &success)
    if success == 0 {
        gl.GetProgramInfoLog(shader_prog, 512, nil, cast([^]u8)&log)
        log_str := strings.clone_from_bytes(log[:])
        fmt.eprintf("ERROR::PROGRAM: %s\n", log_str)
        shader_failed = true
    } else {
        fmt.println("INFO::PROGRAM: Successfully validated")
    }

    if shader_failed {
        os.exit(1)
    }

    gl.BindBuffer(gl.ARRAY_BUFFER, 0)
    gl.BindVertexArray(0)

    gl.Disable(gl.DEPTH_TEST)
    gl.Disable(gl.CULL_FACE)
    gl.Enable(gl.DEPTH_CLAMP)

    ball_x = 1920.0
    ball_y = 1080.0 / 2.0

    samure.context_run(ctx)
}

glGetProcAddress :: proc(p: rawptr, name: cstring) {
    name_str := strings.clone_from_cstring(name)
    (cast(^rawptr)p)^ = dynlib.symbol_address(gl_lib, name_str)
}

on_update :: proc "c" (
    ctx: ^samure.context_t,
    delta_time: f64,
    user_data: rawptr,
) {
    ball_x +=
        f32(500.0 * delta_time) * (f32(libc.rand() % 512) / 512.0 * 2.0 - 1.0)
    ball_y +=
        f32(500.0 * delta_time) * (f32(libc.rand() % 512) / 512.0 * 2.0 - 1.0)
    ball_angle += f32(2.0 * delta_time)
}

on_render :: proc "c" (
    ctx: ^samure.context_t,
    layer_surface: ^samure.layer_surface,
    output_geo: samure.rect,
    user_data: rawptr,
) {
    gl.Viewport(0, 0, output_geo.w, output_geo.h)
    gl.ClearColor(0.0, 0.0, 0.0, 0.0)
    gl.Clear(gl.COLOR_BUFFER_BIT)

    gl.UseProgram(shader_prog)
    gl.BindVertexArray(vao)

    proj := glsl.mat4Ortho3d(
        f32(output_geo.x),
        f32(output_geo.x + output_geo.w),
        f32(output_geo.y + output_geo.h),
        f32(output_geo.y),
        0.001,
        100.0,
    )
    transl := glsl.mat4Translate(glsl.vec3{ball_x, ball_y, 0.0})
    scale := glsl.mat4Scale(glsl.vec3{200.0, 200.0, 0.0})
    rotate := glsl.mat4Rotate(glsl.vec3{0.0, 0.0, 1.0}, ball_angle)

    final_mat := proj * transl * scale * rotate

    gl.UniformMatrix4fv(1, 1, gl.FALSE, cast([^]f32)&final_mat)

    gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)
}

on_event :: proc "c" (
    ctx: ^samure.context_t,
    event: ^samure.event,
    user_data: rawptr,
) {
    #partial switch event.type {
    case samure.event_type.POINTER_BUTTON:
        ctx.running = false
    case samure.event_type.POINTER_MOTION:
        ball_x = f32(event.x + f64(event.seat.pointer_focus.output.geo.x))
        ball_y = f32(event.y + f64(event.seat.pointer_focus.output.geo.y))
    case samure.event_type.POINTER_ENTER:
        samure.context_set_pointer_shape(ctx, 5)
    }
}
