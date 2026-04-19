--[[
  Файл: lua/mraks/init.lua
  Описание: Главный модуль конфигурации mraks. Подключает все остальные модули.
--]]

require("mraks.core.options")
require("mraks.core.keymaps")
require("mraks.core.autocmds")
require("mraks.lazy_init")
