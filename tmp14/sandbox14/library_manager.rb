require 'date'    # подключение класса date для иоспользования объектов DateTime

class LibraryManager
  PENALTY_PER_HOUR = 0.001
  # 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D). За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.  Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и текущего времени. По работе с датой-временем информацию можно посмотреть тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
  # Входящие параметры метода 
  # - стоимость книги в центах, 
  # - дата-время когда книга должна была быть сдана. 
  # Возвращаемое значение 
  # - пеня в центах
  def penalty price, issue_datetime
    # offset_due_to_timezones = (DateTime.now.strftime("%z").to_i - issue_datetime.strftime("%z").to_i) / 100 + 
    #                           (DateTime.now.strftime("%z").to_i - issue_datetime.strftime("%z").to_i) % 100 / 60.0  
    expired_hours = (DateTime.now.new_offset(0).strftime("%s").to_i / 3600.0 - issue_datetime.strftime("%s").to_i / 3600.0).ceil #+ offset_due_to_timezones
    penalty_in_cents = (price * PENALTY_PER_HOUR * expired_hours).round
    penalty_in_cents < 0 || price < 0 ? 0 : penalty_in_cents
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
    half_life_first = (year_of_death_first - year_of_birth_first) / 2.0
    half_life_second = (year_of_death_second - year_of_birth_second) / 2.0
    return false if half_life_first < 0 || half_life_second < 0
    middle_of_life_first =  half_life_first + year_of_birth_first
    middle_of_life_second =  half_life_second + year_of_birth_second
    distance_between_middles = (middle_of_life_first - middle_of_life_second).abs
    distance_between_middles <= half_life_first + half_life_second ? true : false
  end

  # 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а не дешевле ли будет просто купить такую же книгу...  Необходимо помочь читателям это выяснить. За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
  # Входящий параметр метода 
  # - стоимость книги в центах 
  # Возвращаемое значение 
  # - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
  def days_to_buy price
    (1.0 / (24.0 * PENALTY_PER_HOUR)).ceil
  end


  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в транслит. Транслитерацию должна выполняться согласно официальным правилам http://kyivpassport.com/transliteratio/
  # Входящий параметр метода 
  # - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение 
  # - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit ukr_name
    transliteration_rules = {
      А: "A", а: "a",
      Б: "B", б: "b",
      В: "V", в: "v",
      Г: "H", г: "h",
      Ґ: "G", ґ: "g",
      Д: "D", д: "d",
      Е: "E", е: "e",
              є: "ie",
      Ж: "Zh", ж: "zh",
      З: "Z", з: "z",
      И: "Y", и: "y",
      І: "I", і: "i",
              ї: "i",
              й: "i",
      К: "K", к: "k",
      Л: "L", л: "l",
      М: "M", м: "m",
      Н: "N", н: "n",
      О: "O", о: "o",
      П: "P", п: "p",
      Р: "R", р: "r",
      С: "S", с: "s",
      Т: "T", т: "t",
      У: "U", у: "u",
      Ф: "F", ф: "f",
      Х: "Kh", х: "kh",
      Ц: "Ts", ц: "ts",
      Ч: "Ch", ч: "ch",
      Ш: "Sh", ш: "sh",
      Щ: "Shch", щ: "shch",
               ю: "iu",
               я: "ia",
      ь: "", ’: ""     
    }
    first_letters = {
      Є: "Ye", є: "ye",
      Ї: "Yi", ї: "yi",
      Й: "Y", й: "y",
      Ю: "Yu", ю: "yu",
      Я: "Ya", я: "ya",
    }
    letters = ukr_name.split('')
    replaced_letters = letters.map.with_index do |x,i|
      if ((first_letters.has_key? x.to_sym) && ((i==0) || letters[i-1]==' ')) then
        first_letters[x.to_sym]
      elsif transliteration_rules.has_key? x.to_sym then
        transliteration_rules[x.to_sym]
      else
        x
      end
    end
    replaced_letters.join('')
  end  

  #5. Читатели любят дочитывать книги во что-бы то ни стало. Необходимо помочь им просчитать сумму штрафа, который придеться заплатить чтобы дочитать книгу, исходя из количества страниц, текущей страницы и скорости чтения за час.
  # Входящий параметр метода 
  # - Стоимость книги в центах
  # - Дата-время сдачи книги (может быть как в прошлом, так и в будущем)
  # - Количество страниц в книге
  # - Текущая страница
  # - Скорость чтения - целое количество страниц в час.
  # Возвращаемое значение 
  # - Пеня в центах или 0 при условии что читатель укладывается в срок здачи.
  def penalty_to_finish price, issue_datetime, pages_quantity, current_page, reading_speed
    hours_to_read = ((pages_quantity - current_page) / reading_speed.to_f)
    # offset_due_to_timezones = (DateTime.now.strftime("%z").to_i - issue_datetime.strftime("%z").to_i) / 100 + 
    #                           (DateTime.now.strftime("%z").to_i - issue_datetime.strftime("%z").to_i) % 100 / 60.0
    expired_hours = ((DateTime.now.new_offset(0).strftime("%s").to_i / 3600.0 - 
                      issue_datetime.strftime("%s").to_i / 3600.0) + hours_to_read).ceil
    penalty_in_cents = (price * PENALTY_PER_HOUR * expired_hours).round
    penalty_in_cents < 0 || price < 0 ? 0 : penalty_in_cents                                        
  end

end
