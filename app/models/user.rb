require "maglev_record"

class User
  include MaglevRecord::RootedBase

  attr_accessor :first_name, :last_name, :email, :password_digest, :password_confirmation

  has_secure_password
  validates_presence_of :password, :on => :create

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def admin?
    @roles[:admin]
  end
  def admin!
    set_role(:admin)
  end
  def no_admin!
    unset_role(:admin)
  end
  def tutor?
    @roles[:tutor]
  end
  def tutor!
    set_role(:tutor)
  end
  def no_tutor!
    unset_role(:tutor)
  end
  def student?
    @roles[:student]
  end
  def student!
    set_role(:student)
  end
  def no_student!
    unset_role(:tutor)
  end

  def initialize(*args)
    super(*args)
    @roles = Hash.new
    student!
    no_admin!
    no_tutor!
  end

  def set_role(role)
    @roles[role] = true
  end
  def unset_role(role)
    @roles[role] = false
  end
  protected :set_role, :unset_role


  def my_groups
    return Studentgroup.select do |group|
      group.students.include? self
    end
  end

  def my_lectures
    return Lecture.select do |lecture|
      lecture.students.include? self
    end
  end

  def in_lecture?(lecture_id)
    lecture = Lecture.find_by_objectid(lecture_id)
    if lecture
      return lecture.students.include? self
    else
      return false
    end
  end

  def in_group?(group_id)
    group = Studentgroup.find_by_objectid(group_id)
    if group
      return group.students.include? self
    else
      return false
    end
  end

end

Maglev.persistent do
  class User
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
              src: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Bai_yun_giant_panda.jpg/399px-Bai_yun_giant_panda.jpg'.
            innerHtml div
              style: 'display: inline-block';
              with: [
                innerHtml b 
                  with: 'Hi, I am Panda!'.
                innerHtml br.
                innerHtml 
                  with: 'You can e-mail me at ';
                  with: (object attributeAt: 'email') inlineViewComponent]]].
      GENERATOR_STRING

      tabs.push(["Panda User", "pandaUser", html_generator])
      tabs
    end
  end
end

User.maglev_record_persistable
MaglevRecord.save
User.redo_include_and_extend
