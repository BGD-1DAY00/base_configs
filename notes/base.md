# Obsidian.nvim Quick Reference

## Essential Commands

### Navigation & Search
- `:ObsidianQuickSwitch` - Fuzzy find and open any note
- `:ObsidianSearch [query]` - Search notes content
- `:ObsidianBacklinks` - Show all notes linking to current
- `:ObsidianLinks` - Show all links in current note
- `:ObsidianTags [tag]` - Find all notes with tag
- `:ObsidianTOC` - Table of contents for current note

### Creating Notes
- `:ObsidianNew [title]` - Create new note
- `:ObsidianNewFromTemplate [title]` - New note from template
- `:ObsidianExtractNote [title]` - Extract selection to new note

### Daily Notes
- `:ObsidianToday` - Open today's daily note
- `:ObsidianYesterday` - Open yesterday's note
- `:ObsidianTomorrow` - Open tomorrow's note
- `:ObsidianDailies` - List all daily notes

### Templates
- `:ObsidianTemplate` - Insert template in current note
- `:ObsidianNewFromTemplate` - Create note from template

### Links & References
- `:ObsidianLink [query]` - Link selected text to note
- `:ObsidianLinkNew [title]` - Create note and link to it
- `:ObsidianFollowLink` - Follow link under cursor (or use `gf`)

### Other
- `:ObsidianRename [newname]` - Rename note and update all links
- `:ObsidianOpen` - Open current note in Obsidian app
- `:ObsidianPasteImg [name]` - Paste image from clipboard
- `:ObsidianToggleCheckbox` - Cycle checkbox state
- `:ObsidianWorkspace` - Switch workspace

## Key Mappings (Default)

| Key | Action |
|-----|--------|
| `gf` | Follow link under cursor |
| `<leader>ch` | Toggle checkbox |
| `<CR>` | Smart action (follow link or toggle checkbox) |

## Markdown Syntax

### Links
- `[[note]]` - Wiki link to note
- `[[note|Custom Text]]` - Wiki link with custom text
- `[text](note.md)` - Markdown link
- `#tag` - Tag reference

### Formatting
- `*bold*` - Bold text
- `/italic/` - Italic text
- `_underline_` - Underlined text
- `-strikethrough-` - Strikethrough text
- `` `code` `` - Inline code
- `==highlight==` - Highlighted text

### Lists & Tasks
- `- [ ]` - Todo checkbox
- `- [x]` - Done checkbox
- `- [>]` - Forwarded/delegated
- `- [~]` - Cancelled
- `- [!]` - Important

### Structure
- `# Heading 1`
- `## Heading 2`
- `### Heading 3`
- `---` - Horizontal rule
- `> Quote` - Blockquote

## Directory Structure

```
~/.config/notes/
├── inbox/          # New notes go here
├── daily/          # Daily notes
├── templates/      # Note templates
├── assets/
│   └── images/     # Pasted images
└── *.md           # Your notes
```

## Tips

1. **Quick Switch**: Use `:ObsidianQuickSwitch` (map it to `<leader>ff` or similar)
2. **Daily Notes**: Start each day with `:ObsidianToday`
3. **Templates**: Set up templates for common note types
4. **Tags**: Use `#tag` in frontmatter or content for organization
5. **Completion**: Type `[[` to trigger note name completion
6. **Search**: `:ObsidianSearch` uses ripgrep - very fast!

## Troubleshooting

- **No formatting?** Set `vim.opt.conceallevel = 2`
- **No completion?** Install `nvim-cmp` and dependencies
- **Can't find notes?** Check your workspace path
- **No icons?** Install a Nerd Font

## Custom Keybindings (Suggested)

Add to your Neovim config:

```lua
-- Quick access to Obsidian commands
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian Quick Switch" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New Note" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Daily Note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Notes" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Backlinks" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Template" })
```
