package main

import samure "../../."
import "core:fmt"
import "core:os"

main :: proc() {
    cfg := samure.create_context_config(nil, nil, nil, nil)
    cfg.backend = samure.backend_type.OPENGL

    ctx, err := samure.create_context(&cfg)
    if err != samure.ERROR_NONE {
        samure.perror("failed to create context", err)
        os.exit(1)
    }
    defer samure.destroy_context(ctx)
}
