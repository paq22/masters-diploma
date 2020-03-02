# Преобразование вопроса в форму, понятную builder-у

module Question1Text
  def text()
    "Сопоставьте началам запросов их конец так, чтобы получилась
     синтаксически верная конструкция. Предполагается, что если в
     запросе используется какой-то объект, то он существует в БД.
     Кроме того, считается, что каждому названию соответсвует
     опредленный вид объектов: table1 и т.д. - таблица, field1 и т.д. - поле,
     view1 - представление, func1 - функция, aggreg1 - агрегатная функция,
     trig1 - триггер, index1 - индекс, schema1 - схема, user1 - пользователь."
  end

  def single_test_question(good_questions, good_answers,
      bad_questions, bad_answers)
    "Q
#{text()}
" + good_questions.each_with_index.map do |q, i|
    "
R

R1
#{q}

R2
#{good_answers[i]}
"
    end.join() + bad_questions.each_with_index.map do |q, i|
        "
R

R1
#{q}

R

R2
#{bad_answers[i]}"
    end.join("\n")
  end

  def all_test_question()
    @variants.map{ |r| single_test_question(*r) }
  end

end
