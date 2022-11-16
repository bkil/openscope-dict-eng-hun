(function() {
function addCsvRows(data) {
  tbody = document.getElementsByTagName('tbody')[0];
  lines = data.split('_');
  for (i=0; i<lines.length; i++) {
    tr = tbody.insertRow();
    cells = lines[i].split("\t");

    id = cells[0];
    if (cells[1])
      id += '__' + cells[1];
    if (cells[3])
      id += '__' + cells[3];
    id = id.replace(/ /g, '_');
    tr.id = id;

    cell = tr.insertCell();
    cell.innerHTML = '<a href=#' + id + '>' + cells[0] + '</a>';
    for (j=1; j<5; j++) {
      cell = tr.insertCell();
      if (j < cells.length) {
        rich = cells[j];
        rich = rich.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        rich = rich.replace(/\*([^*]+)\*/g, '<em>$1</em>');
        cell.innerHTML = rich;
      }
    }
  }
}

function saveTableToCache(dbVersion) {
  dict = document.getElementsByTagName('tbody')[0].innerHTML;
  cache = dbVersion + "\n" + dict;
  try {
    window.localStorage.setItem('dict', cache);
  } catch (e) {
    if (e.name === "QuotaExceededError") {
      console.log('localStorage denied: quota exceeded');
    } else if (e.name === "SecurityError") {
      console.log('localStorage denied: not caching table');
    } else {
      throw e;
    }
  }
}

addCsvRows("((dict))");
saveTableToCache("((dbVersion))");
})();
