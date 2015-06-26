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

    it 'penalty equal to 0' do
      overdue_hours = DateTime.now.new_offset(0) + 48.hours
      price_in_cent = 1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 0
    end

    it 'with negative price' do
      overdue_hours = DateTime.now.new_offset(0) + 48.hours
      price_in_cent = -1400

      res = LibraryManager.new.penalty(price_in_cent, overdue_hours)

      expect(res).to eq 0
    end

  end


  context '#could_meet_each_other?' do

    it "didn't meet each other, first died before second was born" do
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

    it "didn't meet each other, second died before first was born" do
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
      res = LibraryManager.new.could_meet_each_other?(2, 50,-50, 50,)

      expect(res).to eq true
    end

    it "with extreme values" do
      res = LibraryManager.new.could_meet_each_other?(5, 4, 3, 2)

      expect(res).to eq false
    end

    it "both died and were born in 0" do
      res = LibraryManager.new.could_meet_each_other?(0, 0, 0, 0)

      expect(res).to eq true
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

    it 'return name in transliteration' do
      author_name = "Гнат Хоткевич"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq 'Hnat Khotkevych'
    end

    it 'return name in transliteration' do
      author_name = "Ґлеб Щуров"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq 'Gleb Shchurov'
    end

    it 'return name in transliteration' do
      author_name = "Григорій Квітка-Основ’яненко"

      res = LibraryManager.new.author_translit(author_name)

      expect(res).to eq "Hryhorii Kvitka-Osnovianenko"
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

    it 'return penalty, with expiration which will happend' do
      one_hour_from_now = DateTime.now.new_offset(0) + 1.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, one_hour_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 6
    end

    it 'return penalty, with expiration which had happend before' do
      one_hour_before = DateTime.now.new_offset(0) - 1.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, one_hour_before, pages_quantity, current_page, reading_speed)

      expect(res).to eq 8
    end

    it 'return penalty, without expiration, book will be returned in time ' do
      five_hours_from_now = DateTime.now.new_offset(0) + 5.hours
      price_in_cent = 1400
      pages_quantity = 100
      current_page = 50
      reading_speed = 10

      res = LibraryManager.new.penalty_to_finish(price_in_cent, five_hours_from_now, pages_quantity, current_page, reading_speed)

      expect(res).to eq 0
    end


  end

end