-- lite-xl 1.16

-- PHP lint plugin for lint+

--- CONFIG ---

-- config.lint.php_args: {string}
--   passes the specified arguments to php

--- IMPLEMENTATION ---

local lintplus = require "plugins.lintplus"

local redirection = ""
if PLATFORM == "Linux" then
  redirection = "2> /dev/null"
end

lintplus.add("php") {
  filename = "%.php$",
  procedure = {
    command = lintplus.args_command(
      {
        "php",
        "-l",
        lintplus.args,
        lintplus.filename,
        redirection
      },
      "php_args"
    ),
    interpreter = function (filename, line, context)
      local line_processed = false
      return function ()
        if line_processed then
          return nil
        end
        local message, file, line_num = line:match(
          "[%a ]+:%s*(.*)%s+in%s+(%g+)%s+on%sline%s+(%d+)"
        )
        if line_num then
          line_processed = true
          return filename, tonumber(line_num), 1, "error", message
        end
      end
    end
  },
}