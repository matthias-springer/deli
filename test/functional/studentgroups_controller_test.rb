require 'test_helper'
require "functional/controller_test_base"

class StudentgroupsControllerTest < ActionController::TestCase
  include DeliControllerTestCase

  def assert_false(value)
    assert_equal false, value
  end


  def setup
    login_student
  end

  def teardown
    [User, Lecture, Studentgroup].each do |cls| cls.clear end
    MaglevRecord.save
    clear_group_session
  end

  def create_clear_session
    session[:group] = {
        name: "",
        lecture: { title: "" },
        students: { @user.id => @user.to_s },
        tutors: {},
        is_new: true
      }
  end

  def create_session_from_group(group)
    session[:group] = {
      id: group.id,
      name: group.name,
      lecture: { id: group.lecture.id, title: group.lecture.title },
      students: { @user.id => @user.to_s },
      tutors: {},
      is_new: false }
  end

  def clear_group_session
    session.delete(:group)
  end

  # index
  test "guest cannot list groups" do
    logout
    assert_raise(CanCan::AccessDenied) do
      get :index
    end
  end

  # new
  test "new-action should create entry in session" do
    get :new
    group_info = session[:group]
    assert_not_nil group_info
    assert group_info[:is_new]
  end

  # create
  test "should be able to create new group successfully" do
    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    MaglevRecord.save
    old_count = Studentgroup.size

    create_clear_session
    post :create, studentgroup_name: "new group", chosen_lecture: l.id
    assert_redirected_to studentgroups_path

    assert_not_nil assigns(:group)
    assert_equal old_count + 1, Studentgroup.size
    assert_equal Studentgroup.first.creator, @user

    assert_nil session[:group]
  end
  test "creating invalid group shoul render to 'new'" do
    create_clear_session

    post :create, studentgroup_name: "new group", chosen_lecture: 2
    assert_response :success

    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    MaglevRecord.save
    post :create, chosen_lecture: l.id
    assert_response :success

    assert_not_nil session[:group]
  end

  def create_test_group
    l = Lecture.new({title: "New Lecture", description: "This is really good!"})
    @group = Studentgroup.new({name: "New group", lecture: l})
    MaglevRecord.save
  end

  # show
  test "should show studentgroup" do
    login_admin
    create_test_group
    get :show, id: @group.id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_equal assigns(:group), @group
  end

  test "should show studentgroup i am in" do
    login_admin
    create_test_group
    @group.students << @user
    MaglevRecord.save

    get :show, id: @group.id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_equal assigns(:group), @group
  end

  # destroy
  test "destroy not existing studentgroup" do
    login_admin
    delete :destroy, id: 1
    assert_redirected_to studentgroups_path
    assert_equal flash[:error], "Diese Gruppe existiert nicht!"
    assert_nil flash[:notice]
  end
  test "destroy existing studentgroup" do
    login_admin
    create_test_group
    counter = Studentgroup.size
    delete :destroy, id: @group.id
    assert_redirected_to studentgroups_path
    assert_equal flash[:notice], "Gruppe erfolgreich gelöscht!"
    assert_nil flash[:error]
    assert_equal Studentgroup.size, counter - 1
    assert_nil Studentgroup.find_by_objectid(@group.id)
  end


  def map_list(user_list)
    result = {}
    user_list.each { |user| result[user.id] = user.to_s}
    result
  end

  # edit
  test "edit" do
    login_admin
    create_test_group
    get :edit, id: @group.id
    group_info = session[:group]

    assert_not_nil group_info
    assert(!group_info[:is_new])
    assert_equal group_info[:name], @group.name
    assert_equal group_info[:lecture],  { id: @group.lecture.id, title: @group.lecture.title }
    [:students, :tutors].each do |key|
      assert_equal group_info[key], map_list(@group.attributes[key]), "#{key.to_s} check fails"
    end
  end

  # update
  test "update with errors" do
    login_admin
    create_test_group

    put :update, id: 3
    assert_redirected_to studentgroups_path
    assert_equal flash[:error], "Diese Gruppe existiert nicht!"

    create_session_from_group(@group)
    put :update, id: @group.id
    assert_response :success
    assert_template "edit"
  end

  test "update is invalid" do
    login_admin
    create_test_group

    create_session_from_group(@group)
    params = {
      id: @group.id,
      chosen_lecture: @group.lecture.id,
      studentgroup_name: ""
    }
    put :update, params
    assert_response :success
    assert_template "edit"
  end

  test "successfull update" do
    login_admin
    create_test_group

    create_session_from_group(@group)
    params = {
      id: @group.id,
      chosen_lecture: @group.lecture.id,
      studentgroup_name: @group.name
    }

    put :update, params
    assert_redirected_to studentgroups_path
  end

  # edit_temp
  def params_for(role, action, user_id)
    {
      chosen_lecture: @group.lecture.id,
      "#{action}_#{role}".to_sym => "",
      "#{role}_to_#{action}".to_sym => user_id
    }
  end

  test "update new studentgroup with not existing student" do
    login_admin
    create_test_group
    create_clear_session

    users = session[:group][:students]

    put :edit_temp, params_for("student", "add", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:students]

    put :edit_temp, params_for("student", "delete", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:students]
  end

  test "update new studentgroup with not existing tutor" do
    login_admin
    create_test_group
    create_clear_session

    users = session[:group][:tutors]

    put :edit_temp, params_for("tutor", "add", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:tutors]

    put :edit_temp, params_for("tutor", "delete", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:tutors]
  end

  test "update existing studentgroup with not existing student" do
    login_admin
    create_test_group
    create_session_from_group(@group)
    users = session[:group][:students]

    put :edit_temp, params_for("student", "add", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:students]

    put :edit_temp, params_for("student", "delete", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:students]
  end

  test "update existing studentgroup with not existing tutor" do
    login_admin
    create_test_group
    create_session_from_group(@group)
    users = session[:group][:tutors]

    put :edit_temp, params_for("tutor", "add", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:tutors]

    put :edit_temp, params_for("tutor", "delete", "1")
    assert_equal flash[:error], "Benutzer existiert nicht!"
    assert_equal users, session[:group][:tutors]
  end


  test "update new studentgroup with existing student" do
    login_admin
    create_test_group
    create_clear_session

    student = User.new({last_name: "Last2", first_name: "First"})
    MaglevRecord.save
    assert_false session[:group][:students].include? student.id

    put :edit_temp, params_for("student", "add", student.id)
    assert_equal flash[:notice], "Benutzer #{student.to_s} erfolgreich eingefügt!"
    assert session[:group][:students].include?(student.id)

    put :edit_temp, params_for("student", "delete", student.id)
    assert_equal flash[:notice], "Benutzer #{student.to_s} erfolgreich aus der Gruppe entfernt!"
    assert_false session[:group][:students].include? student.id
  end

  test "update new studentgroup with existing tutor" do
    login_admin
    create_test_group
    create_clear_session

    tutor = User.new({last_name: "Last2", first_name: "First"})
    MaglevRecord.save
    assert_false session[:group][:tutors].include? tutor.id

    put :edit_temp, params_for("tutor", "add", tutor.id)
    assert_equal flash[:notice], "Benutzer #{tutor.to_s} erfolgreich eingefügt!"
    assert session[:group][:tutors].include?(tutor.id)

    put :edit_temp, params_for("tutor", "delete", tutor.id)
    assert_equal flash[:notice], "Benutzer #{tutor.to_s} erfolgreich aus der Gruppe entfernt!"
    assert_false session[:group][:tutors].include? tutor.id
  end

  test "update existing studentgroup with existing student" do
    login_admin
    create_test_group
    create_session_from_group(@group)

    student = User.new({last_name: "Last2", first_name: "First"})
    MaglevRecord.save

    assert_false session[:group][:students].include? student.id

    put :edit_temp, params_for("student", "add", student.id)
    assert_equal flash[:notice], "Benutzer #{student.to_s} erfolgreich eingefügt!"
    assert session[:group][:students].include?(student.id)

    put :edit_temp, params_for("student", "delete", student.id)
    assert_equal flash[:notice], "Benutzer #{student.to_s} erfolgreich aus der Gruppe entfernt!"
    assert_false session[:group][:students].include? student.id
  end

  test "update existing studentgroup with existing tutor" do
    login_admin
    create_test_group
    create_session_from_group(@group)

    tutor = User.new({last_name: "Last2", first_name: "First"})
    MaglevRecord.save
    assert_false session[:group][:tutors].include? tutor.id

    put :edit_temp, params_for("tutor", "add", tutor.id)
    assert_equal flash[:notice], "Benutzer #{tutor.to_s} erfolgreich eingefügt!"
    assert session[:group][:tutors].include?(tutor.id)

    put :edit_temp, params_for("tutor", "delete", tutor.id)
    assert_equal flash[:notice], "Benutzer #{tutor.to_s} erfolgreich aus der Gruppe entfernt!"
    assert_false session[:group][:tutors].include? tutor.id
  end

  def create_test_groups
    l =  Lecture.new({ title: "a Lecture", description: "something interesting" })
    g1 = Studentgroup.new({ name: "Group1",  lecture: l })
    g1.students << @user
    g2 = Studentgroup.new({ name: "Group2",  lecture: l })
    g3 = Studentgroup.new({ name: "Group3",  lecture: l })
    g4 = Studentgroup.new({ name: "Group4",  lecture: l })
    MaglevRecord.save
    [g1, g2, g3, g4]
  end

  # join
  test "should join a studentgroup" do
    login_admin
    groups = create_test_groups
    myGroups = @user.my_groups
    put :join, id: groups[1].id
    MaglevRecord.reset
    assert_equal myGroups.size + 1, @user.my_groups.size
    assert_redirected_to studentgroups_path
    assert_equal flash[:notice], "Du bist erfolgreich der Gruppe #{groups[1].to_s} beigetreten!"
  end

  test "should not join a studentgroup already joined" do
    login_admin
    groups = create_test_groups
    myGroups = @user.my_groups
    put :join, id: groups[0].id
    assert_equal myGroups.size, @user.my_groups.size
    assert_redirected_to studentgroups_path
    assert_equal flash[:notice], "Du bist bereits in dieser Gruppe!"
  end

  # list_for_join
  test "should list all, groups user not joined yet" do
    login_admin
    create_test_groups
    get :list_for_join
    MaglevRecord.reset
    groups = Studentgroup.find_all { |group| not group.students.include?(@user)}
    assert_response :success
    assert_template "list_for_join"
    assert_not_nil assigns(:groups)
    assert_equal assigns(:groups), groups
  end

  # leave
  test "should remove me from group you are in" do
    login_admin
    groups = create_test_groups
    myGroups = @user.my_groups
    put :leave, id: groups[0].id
    MaglevRecord.reset
    assert_equal myGroups.size-1, @user.my_groups.size
    assert_redirected_to studentgroups_path
    assert_equal flash[:notice], "Du hast erfolgreich die Gruppe #{groups[0].to_s} verlassen!"
  end

end