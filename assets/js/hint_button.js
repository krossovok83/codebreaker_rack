window.addEventListener("DOMContentLoaded", function hint_button() {
  let hint = document.getElementById("hints_count").innerText;
  let hint_button = document.getElementById("hint_button");

  if (hint.slice(-1) === "1") {
    document.getElementById("hint_2").hidden = true;
  }
  if (hint.slice(-1) === "0") {
    document.getElementById("hint_1").hidden = true;
    document.getElementById("hint_2").hidden = true;
  }
  if (hint.charAt(0) === "0") {
    hint_button.className = "btn btn-danger btn-lg float-right";
    hint_button.childNodes[0].nodeValue = "No Hint "
    hint_button.disabled = true;
  }
})
