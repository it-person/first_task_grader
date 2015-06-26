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
    now_date = DateTime.now.new_offset(0)
    difference_in_time = (now_date.to_time-issue_date.to_time)/3600
    return 0 if difference_in_time < 0 || prcie < 0
    (price*0.001*difference_in_time).round
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
    b = case
        when year_of_birth_first>year_of_death_first||year_of_birth_second>year_of_death_second
          "Error"
        when year_of_birth_first<=year_of_birth_second&&year_of_birth_second<=year_of_death_first
          true
        when year_of_birth_first<=year_of_death_second&&year_of_death_second<=year_of_death_first
          true 
        when year_of_birth_second<=year_of_birth_first&&year_of_birth_first<=year_of_death_second
          true
        when year_of_birth_second<=year_of_death_first&&year_of_death_first<=year_of_death_second
          true
        else
          false
      end
    return b


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
    number_of_days = 0
    penalty = 0


    begin
      penalty += price*0.0001*24
      number_of_days+=1
    end while penalty < price
  

    return 0 if price < 0 
    number_of_days.rounds 


  end


  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в 
  # транслит. Транслитерацию должна выполняться согласно официальным 
  # правилам http://kyivpassport.com/transliteratio/
  
  # Входящий параметр метода 
  # - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение 
  # - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit ukr_name
    
    ukr_chars = ukr_name.chars

    translit = {'а'=>'a', 'б'=>'b', 'в'=>'v', 'г'=>'h', 'ґ'=>'g', 'д'=>'d', 'е'=>'e', 'є'=>'ie',
            'ж'=>'zh', 'з'=>'z', 'и'=>'y', 'і'=>'i', 'ї'=>'i', 'й'=>'i', 'к'=>'k', 'л'=>'l',
            'м'=>'m', 'н'=>'n', 'о'=>'o', 'п'=>'p', 'р'=>'r', 'с'=>'s', 'т'=>'t', 'у'=>'u',
            'ф'=>'f', 'х'=>'kh', 'ц'=>'ts', 'ч'=>'ch', 'ш'=>'sh', 'щ'=>'shch', 'ю'=>'iu',
            'я'=>'ia', 'А'=>'A','Б'=>'B', 'В'=>'V', 'Г'=>'H', 'Ґ'=>'G', 'Д'=>'D', 'Е'=>'E', 'Є'=>'Ye', 
            'Ж'=>'Zh', 'З'=>'z','И'=>'Y', 'І'=>'I', 'Ї'=>'Yi', 'Й'=>'Y', 'К'=>'K', 'Л'=>'L', 'М'=>'M',
            'Н'=>'N', 'О'=>'O','П'=>'P', 'Р'=>'R', 'С'=>'S','Т'=>'T', 'У'=>'U', 'Ф'=>'F', 'Х'=>'Kh', 
            'Ц'=>'Ts0', 'Ч'=>'Ch','Ш'=>'Sh', 'Щ'=>'Shch', 'Ю'=>'Yu', 'Я'=>'Ya', ' '=>' '}
    i = 0 
    eng_chars = Array.new


    begin
      eng_chars[i]  = translit.values_at(ukr_chars[i]).join
      i+=1
    end while i < ukr_chars.length

    eng_name = eng_chars.join

    return  eng_name # решение пишем тут


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

    time_to_reading = (pages_quantity - current_page)/reading_speed #время в часах для того, что бы дочитать книгу(мб деление на ноль )

    time_to_finish = Time.now + (time_to_reading*3600)#время окочания чтения 

    difference_in_time = time_to_finish - issue_datetime.to_time


    return 0 if difference_in_time <= 0 || prcie <= 0 || pages_quantity < current_page
    (price*0.001*(difference_in_time/3600)).round


  end

end
