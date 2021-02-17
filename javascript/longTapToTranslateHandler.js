console.log("★★★◆◆◆longTapToTranslateHandler.js★★★◆◆◆");
function listAllEventListeners() {
  const allElements = Array.prototype.slice.call(
    document.querySelectorAll("*")
  );
  allElements.push(document);
  allElements.push(window);

  const types = [];

  for (let ev in window) {
    if (/^on/.test(ev)) types[types.length] = ev;
  }

  let elements = [];
  for (let i = 0; i < allElements.length; i++) {
    const currentElement = allElements[i];
    for (let j = 0; j < types.length; j++) {
      if (typeof currentElement[types[j]] === "function") {
        elements.push({
          node: currentElement,
          type: types[j],
          func: currentElement[types[j]].toString(),
        });
      }
    }
  }

  return elements.sort(function (a, b) {
    return a.type.localeCompare(b.type);
  });
}

document.addEventListener("touchend", detectTouchEnd, false);
// document.addEventListener("select", function (params) {
//   console.log("select");
// });
// document.addEventListener("selectstart", function (params) {
//   console.log("selectstart");
// });
// document.addEventListener("selection-change", function (params) {
//   console.log("selection-change");
// });
// document.addEventListener("touchcancel", function (params) {
//   console.log("touchcancel");
// document.addEventListener("touchstart", function (params) {
//   console.log("touchstart");
// });
// document.addEventListener("touchmove", function (params) {
//   console.log("touchmove");
// });
document.addEventListener("mouseup", function (params) {
  console.log("mouseup");
});

function detectTouchEnd() {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  // console.log(window?.getEventListeners(window));
  // console.table(listAllEventListeners());

  // console.log("★onselectは" + window.onselect);

  const selection = window.getSelection().toString().length;
  // console.log(selection); // OK

  if (selection) {
    window.flutter_inappwebview.callHandler("translateByLongTap");
  }
}
console.log(JSON.stringify(listAllEventListeners()));

var d = [
  {
    node: { __jsaction: {} },
    type: "onerror",
    func:
      "function (){var d=c.slice();d.push.apply(d,arguments);return a.apply(this,d)}",
  },
  {
    node: { __jsaction: {} },
    type: "onload",
    func:
      "function (){var d=c.slice();d.push.apply(d,arguments);return a.apply(this,d)}",
  },
  {
    node: { __jsaction: {} },
    type: "onload",
    func: "function (){d();a.Ca++;a.Ha<q_Nna&&q_Hna(a,b)}",
  },
  {
    node: { __jsaction: {} },
    type: "onload",
    func: "function (){d();a.Ca++;a.Ha<q_Nna&&q_Hna(a,b)}",
  },
];
