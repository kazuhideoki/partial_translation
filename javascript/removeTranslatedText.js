var targetElements = document.getElementsByClassName(
  "modified-by-partial-translate"
);
console.log(targetElements);
Array.prototype.forEach.call(targetElements, function (element) {
  console.log("削除したのは " + element.textContent);
  element.remove();
});
