window.addEventListener("DOMContentLoaded", function table_visible() {
  let table = document.getElementById('table_top_players');
  let welcome_string = document.getElementById('welcome_string');
  if (table.innerText.includes("1")) {
    table.hidden = false;
    welcome_string.hidden = true;
  } else {
    table.hidden = true;
    welcome_string.hidden = false;
  }
})
