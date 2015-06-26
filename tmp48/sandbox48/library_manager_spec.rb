require './library_manager.rb'
require 'active_support/all'
require 'pry'

describe LibraryManager do

  it 'should return penalty' do
    two_days_ago = DateTime.now.new_offset(0) - 48.hours
    price_in_cent = 1400

    res = LibraryManager.new.penalty(price_in_cent, two_days_ago)

    expect(res).to eq 67
  end


  it 'should return possibilyty of meeting' do
    res = LibraryManager.new.could_meet_each_other?(1234, 1256, 1876, 1955)

    expect(res).to eq false

    res = LibraryManager.new.could_meet_each_other?(1234, 1256, 1235, 1245)

    expect(res).to eq true
  end


  it 'should return days to buy for particular book with price' do
    price_in_cent = 1400

    res = LibraryManager.new.days_to_buy(price_in_cent)

    expect(res).to eq 42 # The result is always 41.6 ~ 42.
  end


  it 'should return name in transliteration' do
    author_name = "Гнат Хоткевич"

    res = LibraryManager.new.author_translit(author_name)

    expect(res).to eq 'Hnat Khotkevych'
  end


  it 'should return penalty to finish reading' do
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
