package main

import samure "../../."
import "core:c/libc"
import "core:fmt"

main :: proc() {
    cfg := samure.create_context_config(on_event, on_render, nil, nil)
    cfg.pointer_interaction = true

    ctx, err := samure.create_context(&cfg)
    if err != samure.ERROR_NONE {
        fmt.eprintf("failed to create context: %d\n", err)
        return
    }
    defer samure.destroy_context(ctx)

    fmt.printf("Outputs: %d\n", ctx.num_outputs)
    for i: uint = 0; i < ctx.num_outputs; i += 1 {
        o := ctx.outputs[i]
        fmt.printf("output \"%s\":\n", o.name)
        fmt.printf("- x: %d\n", o.geo.x)
        fmt.printf("- y: %d\n", o.geo.y)
        fmt.printf("- width: %d\n", o.geo.w)
        fmt.printf("- height: %d\n", o.geo.h)
    }

    samure.context_run(ctx)
}

on_event :: proc "c" (
    ctx: ^samure.context_t,
    event: ^samure.event,
    user_data: rawptr,
) {
    #partial switch event.type {
    case samure.event_type.POINTER_BUTTON:
        if event.button == 272 && event.state == 1 {
            ctx.running = false
        }
    }
}

on_render :: proc "c" (
    ctx: ^samure.context_t,
    layer_surface: ^samure.layer_surface,
    output_geo: samure.rect,
    user_data: rawptr,
) {
    r := samure.get_raw_surface(layer_surface)

    pixels := ([^]u8)(r.buffer.data)
    for y: i32 = 0; y < r.buffer.height; y += 1 {
        for x: i32 = 0; x < r.buffer.width * 4; x += 4 {
            idx := y * r.buffer.width * 4 + x
            pixels[idx + 0] = 0 // B
            pixels[idx + 1] = 0 // G
            pixels[idx + 2] = 255 // R
            pixels[idx + 3] = 32 // A
        }
    }

    f: f64
    f = layer_surface.frame_delta_time
}
