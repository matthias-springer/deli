$(function() {
  $(document).on("click", ".add_assignment_part", function(e) {
    var lastLine = $("form tr:last")
    var nextNumber = findNextNumber($(this))
    var clone = lastLine.clone()
    clone.find("input").val("")
    findNumberElement(clone).html("#" + nextNumber)
    clone.appendTo(lastLine.parent())
    $(this).remove()
  });

  $(document).on("click", ".remove_assignment_part", function(e) {
    $(this).parents("tr").remove()
  })

  var findNextNumber = function(el) {
    return parseInt(el.data("id")) + 1
  }

  var findNumberElement = function(el) {
    return el.find(".span1:first")
  }
});