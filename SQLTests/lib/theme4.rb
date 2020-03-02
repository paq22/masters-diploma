# Тема 4

require 'question6'

class Theme4
  USED_CLASSES = [Question6]
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
Срединения таблиц

" + @questions.map{ |q| q.all_test_question() }.join("\n\n") + "\n"
  end
end
