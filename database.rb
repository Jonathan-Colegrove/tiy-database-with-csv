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

class Functions
  def initialize
    @database = []
    read
  end

  def home
    loop do
      puts "What would you like to do?
            A = Add a person
            S = Search for a person
            D = Delete a person

            L = leave"
      action = gets.chomp!

      case action
        when "A"
          add
        when "S"
          search
        when "D"
          delete
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
    person.name = gets.chomp!

    if person.name.empty?
      puts "Sorry, User cannot be created without a name."
      return
    end

    if @database.include?(person.name)
      puts "Please select something else: User is already listed
            #{person}"
      return
    end

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
    puts "Sure!  What's the person's name?"
    search_name = gets.chomp!

    for person in @database
      if person.name == search_name
        puts "User is listed:\n#{person}"
        return
      end
    end

    puts "Sorry, #{search_name} isn't in our database.
          Have them add their details to become searchable."
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

  def write
    CSV.open("employees.csv", "w") do |csv|
      csv << ["Name", "Phone", "Address", "Position", "Salary", "Slack", "Github"]
      @database.each do |person|
        csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
      end
    end
  end
end

functions = Functions.new
functions.home
