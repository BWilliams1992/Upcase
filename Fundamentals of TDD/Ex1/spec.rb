# Use TDD principles to build out name functionality for a Person.
# Here are the requirements:
# - Add a method to return the full name as a string. A full name includes
#   first, middle, and last name. If the middle name is missing, there shouldn't
#   have extra spaces.
# - Add a method to return a full name with a middle initial. If the middle name
#   is missing, there shouldn't be extra spaces or a period.
# - Add a method to return all initials. If the middle name is missing, the
#   initials should only have two characters.
#
# We've already sketched out the spec descriptions for the #full_name. Try
# building the specs for that method, watch them fail, then write the code to
# make them pass. Then move on to the other two methods, but this time you'll
# create the descriptions to match the requirements above.

class Person
  def initialize(first_name: 'Benjamin', middle_name: 'Edward', last_name: 'Williams')
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  # implement your behavior here
  def full_name
    if @middle_name === nil
      @first_name + ' ' + @last_name
    else
      @first_name + ' ' + @middle_name + ' ' + @last_name
    end
  end
  
end

RSpec.describe Person do
  describe "#full_name" do
    it "concatenates first name, middle name, and last name with spaces" do
      person = Person.new
      expect(person.full_name).to eq('Benjamin Edward Williams')
    end
    it "does not add extra spaces if middle name is missing" do
      person = Person.new(middle_name: nil)
      expect(person.full_name).to eq('Benjamin Williams')
    end
  end

  describe "#full_name_with_middle_initial" do
    it "concatinates first name, first letter of middle name and a perios, and last name with spaces" do
      person = Person.new()
      expect(person.full_name_with_middle_initial).to eq("Benjamin E. Williams")
    end
  end

  describe "#initials"
end