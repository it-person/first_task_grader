require './library_manager.rb'
require 'active_support/all'
require 'pry'

describe LibraryManager do
######## Penalty ############################

  it 'penalty. Should return penalty' do
    two_days_ago = DateTime.now.new_offset(0) - 48.hours
    price_in_cent = 1400

    res = LibraryManager.new.penalty(price_in_cent, two_days_ago)

    expect(res).to eq 67
  end

  it 'penalty. Price <= 0 ' do
    two_days_ago = DateTime.now.new_offset(0) - 48.hours
    price_in_cent = -1400

    res = LibraryManager.new.penalty(price_in_cent, two_days_ago)

    expect(res).to eq 0
  end

  it 'penalty. issue_datetime >= current ' do
    two_days_ago = DateTime.now.new_offset(0) + 48.hours
    price_in_cent = 1400

    res = LibraryManager.new.penalty(price_in_cent, two_days_ago)

    expect(res).to eq 0
  end
#####################################

  it 'could_meet_each_other?. should return false (1234, 1256, 1876, 1955)' do
    res = LibraryManager.new.could_meet_each_other?(1234, 1256, 1876, 1955)
    expect(res).to eq false
  end

  it 'could_meet_each_other?. should return true (1234, 1256, 1235, 1245)' do
    res = LibraryManager.new.could_meet_each_other?(1234, 1256, 1235, 1245)
    expect(res).to eq true
  end

  it 'could_meet_each_other?. should return true (-100, -50, -60, 100)' do
    res = LibraryManager.new.could_meet_each_other?(-100, -50, -60, 100)
    expect(res).to eq true
  end

  it 'could_meet_each_other?. should return false (100, 80, 90, 120)' do
    res = LibraryManager.new.could_meet_each_other?(100, 80, 90, 120)
    expect(res).to eq false
  end

  it 'could_meet_each_other?. should return false (0, 0, 0, 0)' do
    res = LibraryManager.new.could_meet_each_other?(0, 0, 0, 0)
    expect(res).to eq true
  end

#####################################

  it 'days_to_buy. should return days to buy for particular book with price' do
    price_in_cent = 1400
    res = LibraryManager.new.days_to_buy(price_in_cent)
    expect(res).to eq 42 # The result is always 41.6 ~ 42.
  end

  it 'days_to_buy. should return 0 days if price <= 0' do
    price_in_cent = -1400
    res = LibraryManager.new.days_to_buy(price_in_cent)
    expect(res).to eq 0 # The result is always 41.6 ~ 42.
  end

#####################################

  it 'author_translit. should return name in transliteration' do
    res = LibraryManager.new.author_translit("Гнат Хоткевич")
    expect(res).to eq 'Hnat Khotkevych'

    res = LibraryManager.new.author_translit(" гнат хоткевич ")
    expect(res).to eq 'Hnat Khotkevych'

    res = LibraryManager.new.author_translit(" Єнакієве Короп’є  ")
    expect(res).to eq 'Yenakiieve Koropie'

    res = LibraryManager.new.author_translit(" їжакевич  щербухи ")
    expect(res).to eq 'Yizhakevych Shcherbukhy'

  end


  it 'penalty_to_finish. should return penalty to finish reading' do
    twenty_days_from_now = DateTime.now.new_offset(0) + 480.hours
    price_in_cent = 1400
    pages_quantity = 348
    #binding.pry
    current_page = 25
    reading_speed = 5

    res = LibraryManager.new.penalty_to_finish(price_in_cent, twenty_days_from_now, pages_quantity, current_page, reading_speed)

    expect(res).to eq 0
  end

end
