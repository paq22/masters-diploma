#encoding: UTF-8

# проблема в кодировке

require './theme1'

theme1 = Theme1.new()
#puts theme1.theme_test()#.force_encoding(Encoding::CP1251).encode(Encoding::UTF_8)
Dir.chdir("tests_themes")
# puts Dir.pwd
file = File.open('theme1.txt', 'w+')
file.puts(theme1.theme_test())
file.close()
