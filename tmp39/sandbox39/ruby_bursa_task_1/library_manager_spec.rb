require './library_manager.rb'
require 'active_support/all'
require 'pry'

describe LibraryManager do

  context '#penalty' do

    it 'return penalty, hours equal to 5' do
      overdue_hours = DateTime.now.new_offset(0) - 5.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 7
    end

    it 'return penalty, hours equal to 12' do
      overdue_hours = DateTime.now.new_offset(0) - 12.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 17
    end

    it 'return penalty, hours equal to 1' do
      overdue_hours = DateTime.now.new_offset(0) - 1.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 1
    end

    it 'return penalty, hours equal to 0' do
      overdue_hours = DateTime.now.new_offset(0) - 0.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 0
    end

    it 'return penalty, hours equal to -5' do
      overdue_hours = DateTime.now.new_offset(0) + 5.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 0
    end

    it 'return penalty, negative price' do
      overdue_hours = DateTime.now.new_offset(0) + 5.hours
      price_in_cent = -42

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 0
    end

  end


  context '#could_meet_each_other?' do

    it "did't meet each other, first died before second was born" do
      res = LibraryManager.new.could_meet_each_other?(1234, 1256, 1876, 1955)

      expect(res).to eq false
    end

    it "meet each other, first was born earlier" do
      res = LibraryManager.new.could_meet_each_other?(1940, 2005, 1950, 1999)

      expect(res).to eq true
    end

    it "meet each other, second was born earlier" do
      res = LibraryManager.new.could_meet_each_other?(1905, 1967, 1900, 1980)

      expect(res).to eq true
    end

    it "did't meet each other, second died before first was born" do
      res = LibraryManager.new.could_meet_each_other?(1803, 1855, 1700, 1745)

      expect(res).to eq false
    end
  
    it "meet each other, born and died in same years" do
      res = LibraryManager.new.could_meet_each_other?(1900, 1950, 1900, 1950)

      expect(res).to eq true
    end

    it "meet each other, first was born earlier in BC" do
      res = LibraryManager.new.could_meet_each_other?(-50, 10, 0, 58)

      expect(res).to eq true
    end

    it "meet each other, second was born earlier in BC" do
      res = LibraryManager.new.could_meet_each_other?(2, 50, -50, 50)

      expect(res).to eq true
    end

    it "incorrect years" do
      res = LibraryManager.new.could_meet_each_other?(2, -57, -57, 2)

      expect(res).to eq false
    end

    it "incorrect years 2" do
      res = LibraryManager.new.could_meet_each_other?(-50, -75, 5, -5)

      expect(res).to eq false
    end

  end


  context '#days_to_buy' do

    it 'return days to buy for particular book with price' do
      price_in_cent = 1400

      res = LibraryManager.new.days_to_buy(price_in_cent)

      expect(res).to eq 42
    end

  end

  context '#author_translit' do

    it 'return name in transliteration, original = Гнат Хоткевич' do
      author_name = "Гнат Хоткевич"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq 'Hnat Khotkevych'
    end

    it 'return name in transliteration, original = Ґлеб Щуров' do
      author_name = "Ґлеб Щуров"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq 'Gleb Shchurov'
    end

    it "return name in transliteration, original = Григорій Квітка-Основ'яненко" do
      author_name = "Григорій Квітка-Основ'яненко"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq "Hryhorii Kvitka-Osnovianenko"
    end

    it "return name in transliteration, original = гНат в'йХтхеВич" do
      author_name = "гНат в'йХтхеВич"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq "hNat viKhtkheVych"
    end

    it "return name in transliteration, original = ГНАТ Я ЄЯЮ В О Ь ВАСИЛЬ В'ЙХТХЕВИЧ" do
      author_name = "ГНАТ Я ЄЯЮ В О Ь ВАСИЛЬ В'ЙХТХЕВИЧ"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq "HNAT Ya YEIAIu V O  VASYL VIKHTKHEVYCh"
    end

    # s = '<td valign="bottom" nowrap="nowrap" width="113">Алушта</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Alushta</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Андрій</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Andrii</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Борщагівка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Borshchahivka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Борисенко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Borysenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Вінниця</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Vinnytsia</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Володимир</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Volodymyr</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Гадяч</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Hadiach</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Богдан</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Bohdan</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Згурський</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Zghurskyi</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Ґалаґан</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Galagan</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Ґорґани</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Gorgany</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Донецьк</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Donetsk</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Дмитро</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Dmytro</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Рівне</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Rivne</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Олег</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Oleh</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Есмань</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Esman</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Єнакієве</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yenakiieve</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Гаєвич</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Haievych</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Короп’є</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Koropie</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Житомир</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Zhytomyr</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Жанна</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Zhanna</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Жежелів</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Zhezheliv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Закарпаття</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Zakarpattia</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Казимирчук</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kazymyrchuk</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Медвин</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Medvyn</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Михайленко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Mykhailenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Іванків</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Ivankiv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Іващенко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Ivashchenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Їжакевич</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yizhakevych</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Кадиївка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kadyivka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Мар’їне</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Marine</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Йосипівка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yosypivka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Стрий</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Stryi</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Олексій</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Oleksii</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Київ</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kyiv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Коваленко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kovalenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Лебедин</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Lebedyn</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Леонід</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Leonid</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Миколаїв</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Mykolaiv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Маринич</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Marynych</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Ніжин</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Nizhyn</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Наталія</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Nataliia</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Одеса</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Odesa</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Онищенко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Onyshchenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Полтава</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Poltava</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Петро</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Petro</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Решетилівка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Reshetylivka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Рибчинський</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Rybchynskyi</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Суми</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Sumy</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Соломія</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Solomiia</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Тернопіль</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Ternopil</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Троць</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Trots</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Ужгород</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Uzhhorod</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Уляна</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Uliana</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Фастів</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Fastiv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Філіпчук</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Filipchuk</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Харків</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kharkiv</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Христина</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Khrystyna</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Біла Церква</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Bila Tserkva</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Стеценко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Stetsenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Чернівці</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Chernivtsi</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Шевченко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Shevchenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Шостка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Shostka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Кишеньки</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kyshenky</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Щербухи</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Shcherbukhy</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Гоща</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Hoshcha</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Гаращенко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Harashchenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Юрій</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yurii</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Корюківка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Koriukivka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Яготин</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yahotyn</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Ярошенко</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Yaroshenko</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Костянтин</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Kostiantyn</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Знам’янка</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Znamianka</td>
    #     <td valign="bottom" nowrap="nowrap" width="113">Феодосія</td>
    #     <td valign="bottom" nowrap="nowrap" width="104">Feodosiia</td>'

    # binding.pry

    # s2 = s.gsub(%r@<td.*?>(.*?)</td>@, ' \1 ').gsub(/\s{2,}/, ' ').split

    it "return name in transliteration, original = Есмань Ґалаґан Згурський Єнакієве Короп’є Гаєвич Йосипівка Мар’їне" do
      author_name = "Есмань Ґалаґан Згурський Єнакієве Короп’є Гаєвич Йосипівка Мар’їне"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq "Esman Galagan Zhurskyi Yenakiieve Koropie Haievych Yosypivka Marine"
    end

  end

  context '#penalty_to_finish' do

    it 'return penalty, without expiration' do
      twenty_days_from_now = DateTime.now.new_offset(0) + 480.hours
      price_in_cent = 1400
      pages_quantity = 348
      current_page = 25
      reading_speed = 5

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 0
    end

    it 'return penalty, with expiration which will happen' do
      twenty_days_from_now = DateTime.now.new_offset(0) + 1.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 6
    end

    it 'return penalty, with expiration which happened yet' do
      twenty_days_from_now = DateTime.now.new_offset(0) - 1.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 8
    end

    it 'return penalty, without expiration, book will be returned in time' do
      twenty_days_from_now = DateTime.now.new_offset(0) + 5.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 0
    end

  end

end