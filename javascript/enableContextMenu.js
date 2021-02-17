console.log("★★★◆◆◆enableContextMenu.js★★★◆◆◆");

document.oncontextmenu = function () {
  return true;
};
document.getElementsByTagName("html")[0].oncontextmenu = function () {
  return true;
};
document.body.oncontextmenu = function () {
  return true;
};
