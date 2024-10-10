const std = @import("std");

pub const Token = struct {
    tag: Tag,
    loc: Loc,

    pub const Loc = struct {
        start: usize,
        end: usize,
    };

    pub const keywords = std.StaticStringMap(Tag).initComptime(.{
        .{ "if", .keyword_if },
        .{ "else", .keyword_else },
        .{ "or", .keyword_or },
        .{ "not", .keyword_not },
        .{ "and", .keyword_and },
        .{ "return", .keyword_return },
        .{ "where", .keyword_where },
        .{ "load", .keyword_load },
    });

    pub fn getKeyword(bytes: []const u8) ?Tag {
        return keywords.get(bytes);
    }

    pub const Tag = enum {
        type,
        comma,
        l_paren,
        r_paren,
        arrow,
        equal,

        // Numeric operators
        number,
        question_mark,
        plus,
        minus,
        asterix,
        slash,
        caret,
        percent,
        bang,

        // Boolean operators
        not_equal,
        less,
        less_or_equal,
        greater,
        greater_or_equal,

        identifier,
        indentation,

        keyword_if,
        keyword_or,
        keyword_and,
        keyword_not,
        keyword_else,
        keyword_return,
        keyword_where,
        keyword_load,

        invalid,
        comment,
        eof,
    };
};

pub const Tokenizer = struct {
    buffer: [:0]const u8,
    index: usize,

    pub fn init(buffer: [:0]const u8) Tokenizer {
        return .{
            .buffer = buffer,
            .index = if (std.mem.startsWith(u8, buffer, "\xEF\xBB\xBF")) 3 else 0, // Whacky ass utf-8 bom
        };
    }

    const State = enum {
        start,
        invalid,
        newline,
        indentation,
        identifier,
        number,
        decimal_point,
        minus,
        bang,
        comment,
        comment_end,
    };

    pub fn next(self: *Tokenizer) Token {
        var result: Token = .{ .tag = undefined, .loc = .{
            .start = self.index,
            .end = undefined,
        } };

        state: switch (State.newline) {
            .start => switch (self.buffer[self.index]) {
                0 => {
                    if (self.index == self.buffer.len) {
                        return .{
                            .tag = .eof,
                            .loc = .{
                                .start = self.index,
                                .end = self.index,
                            },
                        };
                    } else {
                        continue :state .invalid;
                    }
                },
                '\n' => {
                    self.index += 1;
                    result.loc.start = self.index;
                    continue :state .newline;
                },
                '\r', ' ', '\t' => {
                    self.index += 1;
                    result.loc.start = self.index;
                    continue :state .start;
                },
                '.' => {
                    self.index += 1;
                    result.loc.start = self.index;
                    continue :state .decimal_point;
                },
                'a'...'z', '_' => {
                    result.tag = .identifier;
                    continue :state .identifier;
                },
                '0'...'9' => continue :state .number,
                'N', 'Z', 'Q', 'R', 'C' => {
                    result.tag = .type;
                    self.index += 1;
                },
                ',' => {
                    result.tag = .comma;
                    self.index += 1;
                },
                '?' => {
                    result.tag = .question_mark;
                    self.index += 1;
                },
                '(' => {
                    result.tag = .l_paren;
                    self.index += 1;
                },
                ')' => {
                    result.tag = .r_paren;
                    self.index += 1;
                },
                '=' => {
                    result.tag = .equal;
                    self.index += 1;
                },
                '!' => continue :state .bang,
                '%' => {
                    result.tag = .percent;
                    self.index += 1;
                },
                '^' => {
                    result.tag = .caret;
                    self.index += 1;
                },
                '*' => {
                    result.tag = .asterix;
                    self.index += 1;
                },
                '/' => {
                    result.tag = .slash;
                    self.index += 1;
                },
                '+' => {
                    result.tag = .plus;
                    self.index += 1;
                },
                '-' => continue :state .minus,
                else => continue :state .invalid,
            },

            .invalid => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    0 => if (self.index == self.buffer.len) {
                        result.tag = .invalid;
                    } else {
                        continue :state .invalid;
                    },
                    '\n' => result.tag = .invalid,
                    else => continue :state .invalid,
                }
            },

            .newline => switch (self.buffer[self.index]) {
                ' ', '\t' => {
                    continue :state .indentation;
                },
                'A'...'Z' => {
                    continue :state .comment;
                },
                else => continue :state .start,
            },

            .indentation => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    ' ', '\t' => continue :state .indentation,
                    else => result.tag = .indentation,
                }
            },

            .comment => switch (self.buffer[self.index]) {
                '.' => {
                    self.index += 1;
                    continue :state .comment_end;
                },
                else => {
                    self.index += 1;
                    continue :state .comment;
                },
            },

            .comment_end => switch (self.buffer[self.index]) {
                '\n' => result.tag = .comment,
                else => continue :state .comment,
            },

            .minus => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    '>' => {
                        result.tag = .arrow;
                        self.index += 1;
                    },
                    else => result.tag = .minus,
                }
            },

            .bang => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    '=' => {
                        result.tag = .not_equal;
                        self.index += 1;
                    },
                    else => result.tag = .bang,
                }
            },

            .number => switch (self.buffer[self.index]) {
                '.' => continue :state .decimal_point,
                '0'...'9' => {
                    self.index += 1;
                    continue :state .number;
                },
                else => result.tag = .number,
            },

            .decimal_point => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    '0'...'9' => {
                        self.index += 1;
                        continue :state .number;
                    },
                    else => continue :state .invalid,
                }
            },

            .identifier => {
                self.index += 1;
                switch (self.buffer[self.index]) {
                    'a'...'z', '_', '0'...'9' => continue :state .identifier,
                    else => {
                        const ident = self.buffer[result.loc.start..self.index];
                        if (Token.getKeyword(ident)) |tag| {
                            result.tag = tag;
                        }
                    },
                }
            },
        }

        result.loc.end = self.index;
        return result;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [200]u8 = undefined;

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        const input_slice: [:0]const u8 = buf[0..user_input.len];
        var tokenizer = Tokenizer.init(input_slice);
        var token = tokenizer.next();
        while (token.tag != Token.Tag.eof) {
            try stdout.print("{s} {d}-{d}, ", .{ @tagName(token.tag), token.loc.start, token.loc.end });
            token = tokenizer.next();
        }
    }
}
