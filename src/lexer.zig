const std = @import("std");

pub const Token = enum { Unknown, Eof, Ident, Number, String, Symbol };

pub const Lexer = struct {
    source: []const u8,
    current: usize = 0,
    token_start: usize = 0,
    token_end: usize = 0,

    pub fn next(self: *Lexer) ?Token {
        self.skip_whitespace();
        if (self.current >= self.source.len) return null;

        const ch = self.source[self.current];

        if (ch == '"')
            return self.parse_string();

        if (std.ascii.isAlphabetic(ch))
            return self.parse_ident();

        if (std.ascii.isDigit(ch))
            return self.parse_number();

        self.token_start = self.current;
        self.current += 1;
        self.token_end = self.current;
        return Token.Symbol;
    }

    pub fn slice(self: *Lexer) []const u8 {
        return self.source[self.token_start..self.token_end];
    }

    fn parse_ident(self: *Lexer) Token {
        self.token_start = self.current;
        while (self.current < self.source.len and (std.ascii.isAlphanumeric(self.source[self.current]) or
            self.source[self.current] == '_'))
            self.current += 1;
        self.token_end = self.current;
        return Token.Ident;
    }

    fn parse_number(self: *Lexer) Token {
        self.token_start = self.current;
        while (self.current < self.source.len and (std.ascii.isDigit(self.source[self.current]) or self.source[self.current] == '.'))
            self.current += 1;
        self.token_end = self.current;
        return Token.Number;
    }

    fn parse_string(self: *Lexer) Token {
        self.token_start = self.current + 1;
        while (self.current < self.source.len and self.source[self.current] != '"')
            self.current += 1;
        self.token_end = self.current;
        self.current += 1;
        return Token.String;
    }

    fn skip_whitespace(self: *Lexer) void {
        while (self.current < self.source.len and std.ascii.isWhitespace(self.source[self.current]))
            self.current += 1;
    }
};
