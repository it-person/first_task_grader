require 'active_support/all'
require 'time'
class LibraryManager

  # 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D). За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.  Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и текущего времени. По работе с датой-временем информацию можно посмотреть тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
  # Входящие параметры метода 
  # - стоимость книги в центах, 
  # - дата-время когда книга должна была быть сдана. 
  # Возвращаемое значение 
  # - пеня в центах
  def penalty(price, issue_datetime)
    time_now = DateTime.now.new_offset(0)
    time_ddl = DateTime.parse(*issue_datetime.to_s)
    if time_now < time_ddl  then return 0
    else
      sec = time_now.sec - time_ddl.sec
      min = (time_now.min - time_ddl.min)*60
      hour = (time_now.hour - time_ddl.hour)*3600
      day = (time_now.day - time_ddl.day)*24*3600
      month = (time_now.month - time_ddl.month)*720*3600
      year = (time_now.year - time_ddl.year)*8640*3600
      general_hours = (sec+min+hour+day+month+year)/3600
      print "Late hours: #{general_hours}"
      debt = 0.001*price*general_hours
      return debt.round(0)
    end
  end

  # 2. Известны годы жизни двух писателей. Год рождения, год смерти. Посчитать, могли ли они чисто теоретически встретиться. Даже если один из писателей был в роддоме - это все равно считается встречей. Помните, что некоторые писатели родились и умерли до нашей эры - в таком случае годы жизни будут просто приходить со знаком минус.
  # Входящие параметры метода 
  # - год рождения первого писателя, 
  # - год смерти первого писателя, 
  # - год рождения второго писателя, 
  # - год смерти второго писателя.
  # Возвращаемое значение 
  # - true или false
  def could_meet_each_other?(year_of_birth_first, year_of_death_first, year_of_birth_second, year_of_death_second)
      first_mas = (year_of_birth_first..year_of_death_first).to_a
      second_mas = (year_of_birth_second..year_of_death_second).to_a
      general_mas = first_mas&second_mas
      return general_mas.any?
  end

  # 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а не дешевле ли будет просто купить такую же книгу...  Необходимо помочь читателям это выяснить. За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
  # Входящий параметр метода 
  # - стоимость книги в центах 
  # Возвращаемое значение 
  # - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
  def days_to_buy(price)
      hours_quantity = 0
      value = 0
      while(value < price)
        hours_quantity +=1
        value += 0.001*price
      end
      return (hours_quantity/24.0).round(0)
  end


  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в транслит. Транслитерацию должна выполняться согласно официальным правилам http://kyivpassport.com/transliteratio/
  # Входящий параметр метода 
  # - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение 
  # - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit(ukr_name)
    trans_name = ukr_name.gsub(/[а-яА-ЯҐґЇїЄєІі']/, 'А'=>'A','Б'=>'B','В'=>'V','Г'=>'H','Ґ'=>'G','Д'=>'D','Е'=>'E', 'Є'=>'Ye', 'Ж'=>'Zh','З'=>'Z','И'=>'Y','І'=>'I','Ї'=>'Yi','Й'=>'Y','К'=>'K','Л'=>'L','М'=>'M', 'Н'=>'N','О'=>'O','П'=>'P','Р'=>'R','С'=>'S','Т'=>'T','У'=>'U','Ф'=>'F', 'Х'=>'Kh', 'Ц'=>'Ts','Ч'=>'Ch','Ш'=>'Sh','Щ'=>'Shch','Ю'=>'Yu','Я'=>'Ya','а'=>'a','б'=>'b','в'=>'v',
'г'=>'h','ґ'=>'g','д'=>'d','е'=>'e','є'=>'ie','ж'=>'zh','з'=>'z','и'=>'y','і'=>'i','ї'=>'i',
'й'=>'i','к'=>'k','л'=>'l','м'=>'m','н'=>'n','о'=>'o','п'=>'p','р'=>'r','с'=>'s','т'=>'t','у'=>'u',
'ф'=>'f','х'=>'kh','ц'=>'ts','ч'=>'ch','ш'=>'sh','щ'=>'shch','ю'=>'iu','я'=>'ia','\''=>'','ь'=>'')
    return trans_name
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
  def penalty_to_finish(price, issue_datetime, pages_quantity, current_page, reading_speed)
    time_now = DateTime.now.new_offset(0)
    time_ddl = DateTime.parse(*issue_datetime.to_s)
    if time_now > time_ddl
      sec1 = time_now.sec - time_ddl.sec
      min1 = (time_now.min - time_ddl.min)*60
      hour1 = (time_now.hour - time_ddl.hour)*3600
      day1 = (time_now.day - time_ddl.day)*24*3600
      month1 = (time_now.month - time_ddl.month)*720*3600
      year1 = (time_now.year - time_ddl.year)*8640*3600
      general_hours1 = (sec1+min1+hour1+day1+month1+year1)/3600
      rest_to_read = (pages_quantity - current_page)/reading_speed
      return ((rest_to_read+general_hours1)*price*0.001).round(0)
    else
      sec2 = time_ddl.sec - time_now.sec
      min2 = (time_ddl.min - time_now.min)*60
      hour2 = (time_ddl.hour - time_now.hour)*3600
      day2 = (time_ddl.day - time_now.day)*24*3600
      month2 = (time_ddl.month - time_now.month)*720*3600
      year2 = (time_ddl.year - time_now.year)*8640*3600
      general_hours2 = (sec2+min2+hour2+day2+month2+year2)/3600
      rest_to_read2 = (pages_quantity - current_page)/reading_speed
      if rest_to_read2 > general_hours2
        debt2 = (rest_to_read2 - general_hours2)*0.001*price
        return debt2.round(0)
      else return 0
      end
    end
  end

end
