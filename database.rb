require "csv"

class Person
  attr_accessor :name, :phone, :address, :position, :salary, :slack, :github

  def to_s
    "    Phone: #{phone}
    Address: #{address}
    #{position}
    Salary = $#{salary}
    Slack = #{slack}
    Github = #{github}"
  end
end

class Functions
  def initialize
    @database = []
    read
  end

  def read
    CSV.foreach("employees.csv", { headers: true, header_converters: :symbol }) do |employee|
      person = Person.new

      person.name     = employee[:name]
      person.phone    = employee[:phone]
      person.address  = employee[:address]
      person.position = employee[:position]
      person.salary   = employee[:salary]
      person.slack    = employee[:slack]
      person.github   = employee[:github]

      @database << person
    end
  end

  def home
    loop do
      puts "What would you like to do?
            A = Add a person
            S = Search for a person
            D = Delete a person
            R = Get a Report
            L = leave"
      action = gets.chomp!

      case action
        when "A"
          add
        when "S"
          search
        when "D"
          delete
        when "R"
          report
        when "L"
          puts "Have a great day!"
          return
        else
          puts %{Please type "A", "S", "D", or "L" without quotes}
      end
    end
  end

  def add
    person = Person.new

    puts "Please enter person's name"
    name = gets.chomp!

    if name.empty?
      puts "Sorry, User cannot be created without a name."
      return
    end

    matching_people = @database.select { |person| person.name == name }
    if matching_people.any?
      puts "#{name} is already in the database.\n#{person}"
      matching_people.each do |person|
        puts "Please select something else: User is already listed
                   #{person}"
        return
      end
    end

    person.name = name

    puts "Please enter person's phone #"
    person.phone = gets.chomp!

    puts "Please enter person's address"
    person.address = gets.chomp!

    puts "What's the person's position? (example: Instructor, Student, TA, etc)"
    person.position = gets.chomp!

    puts "What's the person's salary (in US$)?"
    person.salary = gets.chomp.to_i

    puts "What's the person's Slack Account?"
    person.slack = gets.chomp!

    puts "What's the person's Github Account?"
    person.github = gets.chomp!

    puts "Thanks so much!  #{person.name} is now added."

    @database << person
    write
  end

  def search
    puts "Sure!  What's the person's name, slack, or github ID?"
    name = gets.chomp!

    searching = @database.select { |person| person.name.include?(name) || person.slack == name || person.github == name }

    if searching.empty?
      puts "Sorry, #{name} isn't in our database.
            Have them add their details to become searchable."
      return
    else
      searching.each do |person|
        puts "User is listed:\n#{person}"
      end
    end
  end

  def delete
    puts "Deleting a User can't be undone.
          Yes to continue, No to stop."
    delete_answer = gets.chomp.downcase
    if delete_answer == "yes"
      puts "Ok, what's the person's name?"
      delete_name = gets.chomp!
      for person in @database
        if person.name == delete_name
          puts "#{person.name} & all their info. has been deleted."
          @database.delete(person)
          write
          return
        end
      end

      puts "Looks like you're 1 step ahead of us! #{delete_name} isn't in our database."
    end
  end

  def report
    positions = []
    @database.each do |person|
      unless positions.include?(person.position)
        positions << person.position
      end
    end

    positions.each do |position|
      salaries = []
      names = []
      @database.each do |person|
        if person.position == position
          salaries << person.salary.to_i
          names << person.name
        end
      end

      salaries.sort!

      sum = 0
      salaries.each do |i|
        sum += i
      end
      average = sum / salaries.size

      print "The employees working as #{position}s are: "

      names.each do |name|
        print name + " "
      end

      puts "\nThe # of employees that are #{position}s are: #{salaries.count}"
      puts "The minimum salary for #{position} is: $#{salaries[0]}"
      puts "The maximum salary for #{position} is: $#{salaries[-1]}"
      puts "The average salary for #{position} is: $#{average}"
    end
  end

  def write
    CSV.open("employees.csv", "w") do |csv|
      csv << %w{Name Phone Address Position Salary Slack Github}
      @database.each do |person|
        csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
      end
    end
  end
end

functions = Functions.new
functions.home
