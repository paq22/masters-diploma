require './theme3'

USED_THEMES = [Theme3]

puts(USED_THEMES.map do |t|
  theme = t.new
  theme.theme_test()
end.join("\n"))