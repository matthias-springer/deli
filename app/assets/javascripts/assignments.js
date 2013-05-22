$(function() {
  $(document).on("click", ".add_assignment_part", function(e) {
    var lastLine = $("form tr:last")
    var nextNumber = findNextNumber(lastLine)
    var clone = lastLine.clone()
    clone.find("input").val("")
    findNumberElement(clone).html("#" + nextNumber)
    clone.appendTo(lastLine.parent())
    $(this).remove()
  });

  var findNextNumber = function(el) {
    var numberElement = findNumberElement(el)
    // use substr(1) to omit the leading '#'
    var elementText = $.trim(numberElement.html()).substr(1)
    var currentNumber = parseInt(elementText)
    return currentNumber + 1
  }

  var findNumberElement = function(el) {
    return el.find(".span1:first")
  }
});