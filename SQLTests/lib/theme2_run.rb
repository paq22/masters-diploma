require './theme2'

USED_THEMES = [Theme2]

puts(USED_THEMES.map do |t|
  theme = t.new
  theme.theme_test()
end.join("\n"))