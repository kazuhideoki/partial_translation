var targetElements = document.getElementsByClassName("modified");
console.log(targetElements);
Array.prototype.forEach.call(targetElements, function (element) {
  console.log("削除したのは " + element.innerHTML);
  element.remove();
});
