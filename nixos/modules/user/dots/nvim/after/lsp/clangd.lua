-- Overrides for clangd. Files in after/lsp/ are merged on top of the ones in
-- lsp/ (`:h lsp-config-merge`).
--
-- --background-index parses the headers in the background, so "go to
-- definition" works for system headers you have not opened yet.
--
-- --fallback-style=none switches off clangd's fallback formatting. Without
-- it, clangd formats a file it cannot parse with clang-format, and
-- clang-format flattens such a file into a single line - so saving a file
-- with a syntax error would rewrite it into one long line.

return {
  cmd = { "clangd", "--background-index", "--fallback-style=none" },
}
