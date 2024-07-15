const r = @import("raylib");

pub fn Vector2(x: f32, y: f32) r.Vector2 {
    return .{
        .x = x,
        .y = y,
    };
}

pub fn Vector2Add(v1: r.Vector2, v2: r.Vector2) r.Vector2 {
    return .{
        .x = v1.x + v2.x,
        .y = v1.y + v2.y,
    };
}

pub fn Vector2Subtract(v1: r.Vector2, v2: r.Vector2) r.Vector2 {
    return .{
        .x = v1.x - v2.x,
        .y = v1.y - v2.y,
    };
}

pub fn Vector2Length(v: r.Vector2) f32 {
    return @as(f32, @sqrt(v.x * v.x + v.y * v.y));
}

pub fn Vector2Scale(v: r.Vector2, scale: f32) r.Vector2 {
    return .{
        .x = v.x * scale,
        .y = v.y * scale,
    };
}
