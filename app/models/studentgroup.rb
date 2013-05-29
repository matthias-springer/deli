require "maglev_record"

class Studentgroup
  include MaglevRecord::RootedBase

  attr_accessor :name, :creator
  attr_accessor :students, :tutors, :lecture

  validates :name, :presence => true
  validates :lecture, :presence => true

  def initialize(*args)
    super(*args)
    self.students = []
    self.tutors = []
  end

  def to_s
    "#{name}"
  end

  def add_student(user)
    return false if user.nil? or students.include? user
    students << user
    true
  end

  def remove_student(user)
    return false unless students.include? user
    return false if user.nil?
    students.delete(user)
    true
  end

end

Maglev.persistent do
  class Studentgroup
    def custom_database_tabs
      tabs = []

      html_generator = <<-GENERATOR_STRING
        |outerHtml|
        outerHtml := html div.
        object ensureIsLoaded: 'attributes' from: 1 to: object attributesSize withCallback: [ |innerHtml|
          innerHtml := HTMLCanvas onJQuery: outerHtml asJQuery.
          innerHtml with: [
            innerHtml img
              style: 'height: 250px; margin-right: 10px; display: inline-block;';
              src: 'http://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Chengdu-pandas-d10.jpg/800px-Chengdu-pandas-d10.jpg'.
            innerHtml div
              style: 'display: inline-block';
              with: [
                innerHtml b 
                  with: 'This is student group ';
                  with: (object attributeAt: 'name') inlineViewComponent.
                innerHtml br.
                innerHtml br.
                innerHtml 
                  with: 'My students are ';
                  with: (object attributeAt: 'students') inlineViewComponent;
                  with: [innerHtml br];
                  with: '... and ';
                  with: (object attributeAt: 'tutors') inlineViewComponent;
                  with: ' are my tutors.']]].
      GENERATOR_STRING

      tabs.push(["Panda Student Group", "pandaStudentGroup", html_generator])
      tabs
    end
  end
end

Studentgroup.maglev_record_persistable
Studentgroup.redo_include_and_extend
