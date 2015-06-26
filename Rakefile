require 'gmail'
require 'pry'
require 'zip'
require 'csv'
require 'active_support/all'

desc "Make coffee"
task :check_homework do
  counter = 0
  results = []
  while counter < 50
  Gmail.connect('gmail_account', 'secret_token').mailbox("HomeWork").emails.each do |email|
    begin
      puts '='*80
      student_grade = []
      student_name = email.message.subject.split('.')[0] #=> ["Мананников Сергей", " HW1", " Tasks1"]
      puts "checking #{student_name}, #{counter}"
      student_grade << counter << student_name
      FileUtils.mkdir "#{Dir.pwd}/tmp#{counter}"
      FileUtils.mkdir "#{Dir.pwd}/tmp#{counter}/sandbox#{counter}"
      email.message.attachments.each do |f|
        File.write(File.join("#{Dir.pwd}/tmp#{counter}", 'ruby_bursa_task_1.zip'), f.body.decoded)
      end
      Zip::File.open("#{Dir.pwd}/tmp#{counter}/ruby_bursa_task_1.zip") do |zip_file|
        zip_file.each { |f| zip_file.extract(f, File.join("#{Dir.pwd}/tmp#{counter}/sandbox#{counter}", f.name)) }
      end
      begin
        require "./tmp#{counter}/sandbox#{counter}/ruby_bursa_task_1/library_manager.rb" if File.exist?("./tmp#{counter}/sandbox#{counter}/ruby_bursa_task_1/library_manager.rb")
        require "./tmp#{counter}/sandbox#{counter}/library_manager.rb" if File.exist?("./tmp#{counter}/sandbox#{counter}/library_manager.rb")
        first = 0
        if LibraryManager.new.methods.include? :penalty
          first += 2
          first += 4 if 0 == LibraryManager.new.penalty(1400, DateTime.now.new_offset(0))
          first += 4 if (16..17).include? LibraryManager.new.penalty(1400, (DateTime.now.new_offset(0) - 12.hours))
        end
        second = 0
        if LibraryManager.new.methods.include? :could_meet_each_other?
          second += 2
          second += 4 if ! LibraryManager.new.could_meet_each_other?(1234, 1256, 1876, 1955)
          second += 4 if LibraryManager.new.could_meet_each_other?(1905, 1967, 1900, 1980)
        end
        third = 0
        if LibraryManager.new.methods.include? :days_to_buy
          third += 2 
          third += 8 if (41..42).include? LibraryManager.new.days_to_buy(123)
        end
        if third == 0 && LibraryManager.new.methods.include?( :days_to_bye)
          first += 2
          third += 8 if (41..42).include? LibraryManager.new.days_to_bye(123)
        end
        fourth = 0
        if LibraryManager.new.methods.include? :author_translit
          fourth += 2
          fourth += 4 if 'Ivan Franko' == LibraryManager.new.author_translit('Іван Франко')
          fourth += 4 if 'Marko Vovchok' == LibraryManager.new.author_translit('Марко Вовчок')
        end
        fifth = 0
        if LibraryManager.new.methods.include? :penalty_to_finish
          fifth += 2
          fifth += 4 if 8 == LibraryManager.new.penalty_to_finish(1400, DateTime.now.new_offset(0) - 1.hours, 100, 50, 10)
          fifth += 4 if 0 == LibraryManager.new.penalty_to_finish(1400, DateTime.now.new_offset(0) + 5.hours, 100, 50, 10)
        end
        Object.send(:remove_const, :LibraryManager)
        total = fifth + first + fourth + second + third
        student_grade << total << first << second << third << fourth << fifth
      rescue Exception => e  
        puts e.message
        puts e.backtrace.inspect  
      end    
      puts student_grade.to_s
      results << student_grade
    rescue Exception => e  
      puts e.message
      puts e.backtrace.inspect  
    end
    counter += 1
  end
  CSV.open("hw_1_grades.csv", "w") do |csv| 
    results.each{ |res| csv << res }
  end
end
