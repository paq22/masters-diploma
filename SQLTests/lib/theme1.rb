# Тема 1

require './question1'

class Theme1
  USED_CLASSES = [Question1]
  QUESTION_SIZE = 500

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
Основные конструкции

" + @questions.map{ |q| q.all_test_question() }.join("\n\n") + "\n"
  end
end
