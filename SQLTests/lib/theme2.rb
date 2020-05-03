# Тема 2

require './question2'
require './question3'
require './question4'

class Theme2
  USED_CLASSES = [Question2, Question3, Question4]
  QUESTION_SIZE = 3

  def initialize(num = 3)
    @size = num
    @questions = []
    for i in 0 ... @size
      q = USED_CLASSES[i % USED_CLASSES.size].new(QUESTION_SIZE)
      q.generate_all()
      @questions << q
    end
  end

  def theme_test()
    "N
Построение запросов

" + @questions.map{ |q| q.all_test_question() }.join("\n\n") + "\n"
  end
end
