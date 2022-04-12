window.addEventListener("DOMContentLoaded", function color_button() {
  let buttons = [document.getElementById("answer_1"),
    document.getElementById("answer_2"),
    document.getElementById("answer_3"),
    document.getElementById("answer_4")]

  buttons.forEach(function (element) {
    if (element.innerText === "x") {
      element.className = 'btn btn-danger marks';
    }
    if (element.innerText === "+") {
      element.className = 'btn btn-success marks';
    }
    if (element.innerText === "-") {
      element.className = 'btn btn-primary marks';
    }
  })
})

