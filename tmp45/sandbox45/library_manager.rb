require 'active_support/all';
class LibraryManager

  # 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D).
  # За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.  
  # Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и 
  # текущего времени. По работе с датой-временем информацию можно посмотреть 
  # тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
  # 
  # Входящие параметры метода 
  # - стоимость книги в центах, 
  # - дата и время возврата (момент, когда книга должна была быть сдана, в формате DateTime)
  # Возвращаемое значение 
  # - пеня в центах
  def penalty price, issue_datetime
    penaltyHours = ((DateTime.now - issue_datetime).to_f * 24).round
    res = if penaltyHours > 0
            penaltyHours * price * 0.001
          else
            0
          end
    return res.round
  end

  # 2. Известны годы жизни двух писателей. Год рождения, год смерти. Посчитать, могли ли они чисто 
  # теоретически встретиться. Даже если один из писателей был в роддоме - это все равно считается встречей. 
  # Помните, что некоторые писатели родились и умерли до нашей эры - в таком случае годы жизни будут просто 
  # приходить со знаком минус.
  # 
  # Входящие параметры метода 
  # - год рождения первого писателя, 
  # - год смерти первого писателя, 
  # - год рождения второго писателя, 
  # - год смерти второго писателя.
  # Возвращаемое значение 
  # - true или false
  def could_meet_each_other? year_of_birth_first, year_of_death_first, year_of_birth_second, year_of_death_second
    lifeOfFirst = (year_of_birth_first..year_of_death_first)
    lifeOfSecond = (year_of_birth_second..year_of_death_second)
    return (lifeOfFirst.member?(year_of_birth_second) or lifeOfFirst.member?(year_of_death_second) or lifeOfSecond.member?(year_of_birth_first) or lifeOfSecond.member?(year_of_death_first))
  end

  # 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а 
  # не дешевле ли будет просто купить такую же книгу...  Необходимо помочь читателям это выяснить. За каждый 
  # час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
  # 
  # Входящий параметр метода 
  # - стоимость книги в центах 
  # Возвращаемое значение 
  # - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
  def days_to_buy price
    #Для данного метода абсолютно не важна стоимость книги. Как ни крути а полная стоимость книги набегает
    #за 1000 часов что примерно равно 42 дням
    penaltyIndex = 0.1 / 100
    penaltyHours = price / (price * penaltyIndex)
    return (penaltyHours / 24).round
  end


  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в 
  # транслит. Транслитерацию должна выполняться согласно официальным 
  # правилам http://kyivpassport.com/transliteratio/
  
  # Входящий параметр метода 
  # - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение 
  # - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit ukr_name
    translit = ukr_name
    ukrLetters = ['А', 'а', 'Б', 'б', 'В', 'в', 'Г', 'г', 'Ґ', 'ґ', 'Д', 'д', 'Е', 'е',
                  'Є', 'є', 'Ж', 'ж', 'З', 'з', 'И', 'и', 'І', 'і', 'Ї', 'ї', 'Й', 'й',
                  'К', 'к', 'Л', 'л', 'М', 'м', 'Н', 'н', 'О', 'о', 'П', 'п', 'Р', 'р',
                  'С', 'с', 'Т', 'т', 'У', 'у', 'Ф', 'ф', 'Х', 'х', 'Ц', 'ц',
                  'Ч', 'ч', 'Ш', 'ш', 'Щ', 'щ', 'Ь', 'ь', 'Ю', 'ю', 'Я', 'я']
    engLetters = ['A', 'a', 'B', 'b', 'V', 'v', 'H', 'h', 'G', 'g', 'D', 'd', 'E', 'e',
                  'Ye', 'ie', 'Zh', 'zh', 'Z', 'z', 'Y', 'y', 'I', 'i', 'Yi', 'i', 'Y', 'i',
                  'K', 'k', 'L', 'l', 'M', 'm', 'N', 'n', 'O', 'o', 'P', 'p', 'R', 'r',
                  'S', 's', 'T', 't', 'U', 'u', 'F', 'f', 'Kh', 'kh', 'Ts', 'ts',
                  'Ch', 'ch', 'Sh', 'sh', 'Shch', 'shch', '', '', 'Yu', 'iu', 'Ya', 'ia']
    for i in 0..ukrLetters.length-1
      translit = translit.gsub(ukrLetters[i], engLetters[i])
    end
    return translit
  end

  #5. Читатели любят дочитывать книги во что-бы то ни стало. Необходимо помочь им просчитать сумму штрафа, 
  # который придеться заплатить чтобы дочитать книгу, исходя из количества страниц, текущей страницы и 
  # скорости чтения за час.
  # 
  # Входящий параметр метода 
  # - Стоимость книги в центах
  # - DateTime сдачи книги (может быть как в прошлом, так и в будущем)
  # - Количество страниц в книге
  # - Текущая страница
  # - Скорость чтения - целое количество страниц в час.
  # Возвращаемое значение 
  # - Пеня в центах или 0 при условии что читатель укладывается в срок здачи.
  def penalty_to_finish price, issue_datetime, pages_quantity, current_page, reading_speed
    timeToRead = ((pages_quantity - current_page) / reading_speed)/24.0
    endReading = DateTime.now + timeToRead
    res = if endReading > issue_datetime
      penaltyIndex = 0.1 / 100
      penaltyHours = ((endReading - issue_datetime).to_f * 24).round
      penaltyHours * price * penaltyIndex
    else
      0
    end
    return res.round
  end

end
