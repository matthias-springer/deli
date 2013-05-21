$(function() {
  var myOptions = function(mapped_values) {
    return {
      source: Object.keys(mapped_values),
      highlighter: function (item) {
        return mapped_values[item];
      },
      matcher: function (item) {
        return ~mapped_values[item].toLowerCase().indexOf(this.query.toLowerCase())
      },
      highlighter: function (item) {
        var query = this.query.replace(/[\-\[\]{}()*\\+?.,\\\^$|#\s]/g,"\\$&");
        var value = mapped_values[item]
        return value.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
          return '<strong>' + match + '</strong>'
        })
      }
    }
  };

  var initStudents = function(values) {
    var opts = myOptions(values)
    opts['updater'] = function(item) {
      $('#student_to_add').attr('value', item);
      return values[item];
    };
    $('#studentgroup_students').typeahead(opts);
  };

  var initTutors = function(values) {
    var opts = myOptions(values)
    opts['updater'] = function(item){
      $('#tutor_to_add').attr('value', item);
      return values[item];
    };
    $('#studentgroup_tutors').typeahead(opts);
  };

  var initLectures = function(values) {
    var opts = myOptions(values)
    opts['updater'] = function(item){
      $('#chosen_lecture').attr('value', item);
      return values[item];
    };
    $('#studentgroup_lecture').typeahead(opts);
  };

  $.ajax({
    url: '/users/students.json',
    data: {},
    success: initStudents,
    dataType: "json"
  });

  $.ajax({
    url: '/users/tutors.json',
    data: {},
    success: initTutors,
    dataType: "json"
  });

  $.ajax({
    url: '/lectures/index.json',
    data: {},
    success: initLectures,
    dataType: "json"
  });

  $('#change_to_post_btn').on('click', function(event) {
    // hook to have two actions (put and post) in one form
    $('#group_form input[name=_method]').remove();
  });

  $('#change_action_btn').on('click', function(event) {
    $('#group_form').attr('action', $(this).attr('action'));
  });

  $('.btn-delete-student').on('click', function(event) {
    $('#student_to_delete').attr('value', $(this).attr('data-student-id'));
  });
  $('.btn-delete-tutor').on('click', function(event) {
    $('#tutor_to_delete').attr('value', $(this).attr('data-tutor-id'));
  });
});