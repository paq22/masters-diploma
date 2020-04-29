require './theme1'

USED_THEMES = [Theme1]

puts(USED_THEMES.map do |t|
  theme = t.new
  theme.theme_test()
end.join("\n"))
