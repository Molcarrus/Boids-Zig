const std = @import("std");
const math = std.math;

const r = @import("raylib");

const vector2 = @import("vector2.zig");

const Vector2 = vector2.Vector2;
const Vector2Add = vector2.Vector2Add;
const Vector2Subtract = vector2.Vector2Subtract;
const Vector2Scale = vector2.Vector2Scale;
const Vector2Length = vector2.Vector2Length;

pub fn to_degree(radians: f32) f32 {
    return radians * @as(f32, @divFloor(180, math.pi));
}

pub fn Boid() type {
    return struct {
        visual_range: f32 = undefined,
        repulsion_range: f32 = undefined,
        turn_factor: f32 = undefined,
        centering_factor: f32 = undefined,
        avoid_factor: f32 = undefined,
        matching_factor: f32 = undefined,
        max_speed: f32 = undefined,
        min_speed: f32 = undefined,
        position: r.Vector2 = undefined,
        velocity: r.Vector2 = undefined,
        rotation: f32 = undefined,
        color: r.Color = undefined,

        const Self = @This();

        pub fn init(self: *Self, position: r.Vector2) void {
            self.visual_range = 20;
            self.repulsion_range = 10;
            self.turn_factor = 0.2;
            self.centering_factor = 0.005;
            self.avoid_factor = 0.05;
            self.matching_factor = 0.05;
            self.max_speed = 2;
            self.min_speed = 1;
            self.position = position;
            self.velocity = Vector2(0, 0);
            self.rotation = 0;
            self.color = r.Color.black;
        }

        pub fn draw(self: *Self) void {
            self.rotation = to_degree(@as(f32, math.atan2(self.velocity.y, self.velocity.x)));
            r.drawPoly(self.position, 3, 4.0, self.rotation, self.color);
        }
    };
}

const boid = Boid();

pub fn update(self: *boid, boids: []boid) void {
    var pos_avg = Vector2(0, 0);
    var vel_avg = Vector2(0, 0);
    var neighbors: i32 = 0;
    var repulsion_pos = Vector2(0, 0);

    for (boids) |b| {
        const diff = Vector2Subtract(self.position, b.position);
        const diff_len = Vector2Length(diff);

        if (diff_len < self.visual_range) {
            if (diff_len < self.repulsion_range) {
                repulsion_pos = Vector2Add(repulsion_pos, diff);
            }
            pos_avg = Vector2Add(pos_avg, b.position);
            vel_avg = Vector2Add(vel_avg, b.velocity);

            neighbors = neighbors + 1;
        }
    }

    if (neighbors > 0) {
        pos_avg = Vector2(@as(f32, @divExact(pos_avg.x, @as(f32, @floatFromInt(neighbors)))), @as(f32, @divExact(pos_avg.x, @as(f32, @floatFromInt(neighbors)))));
        vel_avg = Vector2(@as(f32, @divExact(vel_avg.x, @as(f32, @floatFromInt(neighbors)))), @as(f32, @divExact(vel_avg.y, @as(f32, @floatFromInt(neighbors)))));

        self.velocity = Vector2Add(self.velocity, Vector2Add(Vector2Scale(Vector2Subtract(pos_avg, self.position), self.centering_factor), Vector2Scale(Vector2Subtract(vel_avg, self.velocity), self.matching_factor)));
        self.velocity = Vector2Add(self.velocity, Vector2Scale(repulsion_pos, self.avoid_factor));
    }

    const speed = @as(f32, @sqrt(self.velocity.x * self.velocity.x + self.velocity.y * self.velocity.y));

    if (speed < self.min_speed) {
        self.velocity = Vector2Scale(self.velocity, @as(f32, @divExact(self.max_speed, speed)));
    } else if (speed > self.max_speed) {
        self.velocity = Vector2Scale(self.velocity, @as(f32, @divExact(self.max_speed, speed)));
    }

    const margin: f32 = 50;

    if (self.position.x < margin) {
        self.velocity.x = self.velocity.x + self.turn_factor;
    }
    if (self.position.x > @as(f32, @as(f32, 640) - margin)) {
        self.velocity.x = self.velocity.x - self.turn_factor;
    }
    if (self.position.y < margin) {
        self.velocity.y = self.velocity.y + self.turn_factor;
    }
    if (self.position.y > @as(f32, @as(f32, 480) - margin)) {
        self.velocity.y = self.velocity.y - self.turn_factor;
    }

    self.position = Vector2Add(self.position, self.velocity);
}
