# библиотека для подключения к Oracle
require 'oci8'

# подключение к БД
connection = OCI8.new('C##PA', 'PAPASSWORD')

# пример запроса к БД, по умолчанию создается схема,
# название которой совпадает с именем пользователя
connection.exec("SELECT * from (SELECT lastname FROM people ORDER BY 'lastname' ASC ) WHERE rownum <= 1;") do |responce|
    p responce
end

