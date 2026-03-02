return {
  {
    "jwalton512/vim-blade",
  },

  -- Fix vat/vit for nested HTML tags (mini.ai's pattern-based matching
  -- can't handle nested tags of the same name like nested <div>s)
  {
    "nvim-mini/mini.ai",
    opts = {
      custom_textobjects = {
        t = function(ai_type)
          local cur_pos = vim.fn.getpos(".")

          -- Use Vim's built-in tag text object via normal! (bypasses mini.ai mappings)
          -- Vim's built-in at/it uses searchpair() which correctly handles nesting
          vim.cmd("normal! v" .. (ai_type == "a" and "at" or "it"))

          -- Capture the visual selection
          local from = vim.fn.getpos("v")
          local to = vim.fn.getpos(".")

          -- Exit visual mode
          vim.cmd([[execute "normal! \<Esc>"]])

          -- Restore cursor
          vim.fn.setpos(".", cur_pos)

          -- Validate (check if a selection was actually made)
          if from[2] == 0 or to[2] == 0 then
            return nil
          end

          -- Normalize positions (ensure from < to)
          local from_line, from_col = from[2], from[3]
          local to_line, to_col = to[2], to[3]
          if from_line > to_line or (from_line == to_line and from_col > to_col) then
            from_line, to_line = to_line, from_line
            from_col, to_col = to_col, from_col
          end

          return {
            from = { line = from_line, col = from_col },
            to = { line = to_line, col = to_col },
          }
        end,
      },
    },
  },
}
