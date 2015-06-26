require 'date'
class LibraryManager

  # 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D). 
  # За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости. 
  # Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и текущего времени. 
  # По работе с датой-временем информацию можно посмотреть тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
  # Входящие параметры метода 
  # - стоимость книги в центах, 
  # - дата-время когда книга должна была быть сдана. 
  # Возвращаемое значение 
  # - пеня в центах
  def penalty price, issue_datetime
        
    date_now = DateTime.now.new_offset( 0 )
    return 0 if issue_datetime >= date_now || price < 0

    hours = (date_now.to_time - issue_datetime.to_time).to_i / 3600
    
    penalty = price * 0.001 * hours
    penalty.round

  end

  # 2. Известны годы жизни двух писателей. Год рождения, год смерти. Посчитать, могли ли они чисто теоретически встретиться. Даже если один из писателей был в роддоме - это все равно считается встречей. Помните, что некоторые писатели родились и умерли до нашей эры - в таком случае годы жизни будут просто приходить со знаком минус.
  # Входящие параметры метода 
  # - год рождения первого писателя, 
  # - год смерти первого писателя, 
  # - год рождения второго писателя, 
  # - год смерти второго писателя.
  # Возвращаемое значение 
  # - true или false
  def could_meet_each_other? year_of_birth_first, year_of_death_first, year_of_birth_second, year_of_death_second
    
    if year_of_birth_first > year_of_death_first || year_of_birth_second > year_of_death_second
      return false
    end

    life_time1 = (year_of_birth_first..year_of_death_first).to_a
    life_time2 = (year_of_birth_second..year_of_death_second).to_a
 
    return (life_time1 & life_time2).count > 0 ? true : false

  end

  # 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а не дешевле ли будет просто купить такую же книгу...  Необходимо помочь читателям это выяснить. За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
  # Входящий параметр метода 
  # - стоимость книги в центах 
  # Возвращаемое значение 
  # - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
  def days_to_buy price

    return 0 if price <= 0

    penalty_for_day = price * 0.001 * 24

    days = price / penalty_for_day
    days.round

  end

  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в транслит. Транслитерацию должна выполняться согласно официальным правилам http://kyivpassport.com/transliteratio/
  # Входящий параметр метода 
  # - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение 
  # - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit ukr_name

    str = ""

    first_char_name = true
    ukr_name.each_char do |char|

      case char
      when 'А'
        str = str + 'A'
      when 'а'
        str = str + 'a'
      when 'Б'
        str = str + 'B'
      when 'б'
        str = str + 'b'
      when 'В'
        str = str + 'V'
      when 'в'
        str = str + 'v'
      when 'Г'
        str = str + 'H'
      when 'г'
        str = str + 'h'
      when 'Ґ'
        str = str + 'G'
      when 'ґ'
        str = str + 'g'
      when 'Д'
        str = str + 'D'
      when 'д'
        str = str + 'd'
      when 'Е'
        str = str + 'E'
      when 'е'
        str = str + 'e'
      when 'Є'
        translit = first_char_name ? 'Ye' : 'Ie'
        str = str + translit
      when 'є'
        translit = first_char_name ? 'ye' : 'ie'
        str = str + translit
      when 'Ж'
        str = str + 'Zh'
      when 'ж'
        str = str + 'zh'
      when 'З'
        str = str + 'Z'
      when 'з'
        str = str + 'z'
      when 'И'
        str = str + 'Y'
      when 'и'
        str = str + 'y'
      when 'І'
        str = str + 'I'
      when 'і'
        str = str + 'i'
      when 'Ї'
        translit = first_char_name ? 'Yi' : 'I'
        str = str + translit
      when 'ї'
        translit = first_char_name ? 'yi' : 'i'
        str = str + translit
      when 'Й'
        translit = first_char_name ? 'Y' : 'I'
        str = str + translit
      when 'й'
        translit = first_char_name ? 'y' : 'i'
        str = str + translit
      when 'К'
        str = str + 'K'
      when 'к'
        str = str + 'k'
      when 'Л'
        str = str + 'L'
      when 'л'
        str = str + 'l'
      when 'М'
        str = str + 'M'
      when 'м'
        str = str + 'm'
      when 'Н'
        str = str + 'N'
      when 'н'
        str = str + 'n'
      when 'О'
        str = str + 'O'
      when 'о'
        str = str + 'o'
      when 'П'
        str = str + 'P'
      when 'п'
        str = str + 'p'
      when 'Р'
        str = str + 'R'
      when 'р'
        str = str + 'r'
      when 'С'
        str = str + 'S'
      when 'с'
        str = str + 's'
      when 'Т'
        str = str + 'T'
      when 'т'
        str = str + 't'
      when 'У'
        str = str + 'U'
      when 'у'
        str = str + 'u'
      when 'Ф'
        str = str + 'F'
      when 'ф'
        str = str + 'f'
      when 'Х'
        str = str + 'Kh'
      when 'х'
        str = str + 'kh'
      when 'Ц'
        str = str + 'Ts'
      when 'ц'
        str = str + 'ts'
      when 'Ч'
        str = str + 'Ch'
      when 'ч'
        str = str + 'ch'
      when 'Ш'
        str = str + 'Sh'
      when 'ш'
        str = str + 'sh'
      when 'Щ'
        str = str + 'Shch'
      when 'щ'
        str = str + 'shch'
      when 'Ю'
        translit = first_char_name ? 'Yu' : 'Iu'
        str = str + translit
      when 'ю'
        translit = first_char_name ? 'yu' : 'iu'
        str = str + translit
      when 'Я'
        translit = first_char_name ? 'Ya' : 'Ia'
        str = str + translit
      when 'я'
        translit = first_char_name ? 'ya' : 'ia'
        str = str + translit
      end        

      if char == ' ' || char == '-' 
        str = str + char
        first_char_name = true
      else
        first_char_name = false
      end

    end
    
    str

  end  

  #5. Чиdatetimeтатели любят дочитывать книги во что-бы то ни стало. Необходимо помочь им просчитать сумму штрафа, который придеться заплатить чтобы дочитать книгу, исходя из количества страниц, текущей страницы и скорости чтения за час.
  # Входящий параметр метода 
  # - Стоимость книги в центах
  # - Дата-время сдачи книги (может быть как в прошлом, так и в будущем)
  # - Количество страниц в книге
  # - Текущая страница
  # - Скорость чтения - целое количество страниц в час.
  # Возвращаемое значение 
  # - Пеня в центах или 0 при условии что читатель укладывается в срок здачи.
  def penalty_to_finish price, issue_datetime, pages_quantity, current_page, reading_speed

    return 0 if reading_speed == 0 || price < 0

    date_now = DateTime.now.new_offset( 0 )

    hours_remaining_for_reading = (pages_quantity - current_page) / reading_speed.to_f
    
    time_when_read = date_now.to_time + (hours_remaining_for_reading * 3600)
    time_issue = issue_datetime.to_time
 
    if time_when_read > time_issue
      hours = (time_when_read - time_issue).to_i / 3600
      penalty = price * 0.001 * hours 
      penalty.round
    else
      penalty = 0
    end

  end

end
