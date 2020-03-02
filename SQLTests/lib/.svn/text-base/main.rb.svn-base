# Главный запускаемый файл проекта

require 'theme1'
require 'theme2'
require 'theme3'
require 'theme4'

USED_THEMES = [Theme1, Theme2, Theme3, Theme4]

puts(USED_THEMES.map do |t|
  theme = t.new
  theme.theme_test()
end.join("\n"))
