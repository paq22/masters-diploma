# Тема 3

require 'question5'

class Theme3
  USED_CLASSES = [Question5]
  QUESTION_SIZE = 2 # изменила. было 500

  def initialize(num = 1)
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
Вложенные запросы

" + @questions.map{ |q| q.all_test_question() }.join("\n\n") + "\n"
  end
end
