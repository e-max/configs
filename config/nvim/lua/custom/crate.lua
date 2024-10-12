local uv = vim.loop
local api = vim.api

local M = {}
local cache = {}

local function read_file_sync(path)
  local fd, stat, data
  fd = uv.fs_open(path, 'r', 438) -- octal 0666
  if not fd then
    return nil
  end

  stat = uv.fs_fstat(fd)
  if not stat then
    uv.fs_close(fd)
    return nil
  end

  data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

local function get_crate_name(filename)
  local body, crate
  while #filename > 1 do
    local dir = vim.fn.fnamemodify(filename, ':h')
    local path = dir .. '/Cargo.toml'
    body = read_file_sync(path)
    if body then
      crate = body:match '.*name%s*=%s*"([-_%w]+)"'
      if crate then
        return crate
      end
    end
    filename = dir -- Move up the directory tree
  end
  return nil -- No crate name found after reaching the top
end

function M.get_crate()
  local filename = api.nvim_buf_get_name(0)
  if not cache[filename] or cache[filename] == '' then
    local crate = get_crate_name(filename)
    cache[filename] = crate or ''
  end
  return cache[filename]
end

return M
