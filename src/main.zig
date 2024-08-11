const std = @import("std");
const l = @import("lexer.zig");

const print = std.debug.print;

const input =
    \\hey
    \\what
    \\69 < 42
    \\move(x,y);
    \\
    \\
    \\mov x      <- y
    \\
    \\      veryLongWeird___function_name89_8thatCouldBE_POSSIBLE_4();
;

pub fn main() !void {
    var lexer = l.Lexer{ .source = input };

    while (lexer.next()) |token| {
        if (token == l.Token.Eof) break;
        print("{s:<6} | {s}\n", .{ @tagName(token), lexer.slice() });
    }

    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();
    // try stdout.print("Run `zig build test` to run the tests.\n", .{});
    // try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
