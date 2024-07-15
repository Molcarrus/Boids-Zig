const r = @import("raylib");

const boid = @import("boid.zig");
const vector2 = @import("vector2.zig");

const Boid = boid.Boid();

const update = boid.update;

const Vector2 = vector2.Vector2;

const boid_count: i32 = 200;

pub fn main() !void {
    const screen_width = 640;
    const screen_height = 480;

    var boid_arr: [boid_count]Boid = undefined;

    for (0..boid_count) |i| {
        boid_arr[i].init(Vector2(@as(f32, @floatFromInt(r.getRandomValue(80, screen_width - 80))), @as(f32, @floatFromInt(r.getRandomValue(80, screen_height - 80)))));
    }

    r.initWindow(screen_width, screen_height, "basic window");
    defer r.closeWindow();

    r.setTargetFPS(60);

    while (!r.windowShouldClose()) {
        r.beginDrawing();
        defer r.endDrawing();

        r.clearBackground(r.Color.red);

        for (0..boid_count) |i| {
            update(&boid_arr[i], &boid_arr);
            boid_arr[i].draw();
        }
    }
}
