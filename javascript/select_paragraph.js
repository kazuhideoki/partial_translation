console.log("★★★◆◆◆select_paragraph.js★★★◆◆◆");

var isMoved = false;
var targetEvent;

// localStorage経由でisSelectParagraphを渡して, 発火するか否かを判定する。
window.addEventListener(
  "touchstart",
  (e) => {
    isMoved = false;
    targetEvent = e;
  },
  true
);

window.addEventListener(
  "touchmove",
  () => {
    isMoved = true;
  },
  true
);

window.addEventListener("touchend", selectParagraph, true);

function selectParagraph(e) {
  let isSelectParagraph = window.localStorage.getItem("isSelectParagraph");
  if (isSelectParagraph === "true") {
    isSelectParagraph = true;
  } else if (isSelectParagraph === "false") {
    isSelectParagraph = false;
  }

  if (isSelectParagraph && isMoved === false) {
    try {
      // const touchedElement = targetEvent.targetTouches.item(0).target; // android でのみ成功 iosでは一瞬選択される
      const touchedElement = e.target; // android でのみ成功 iosでは一瞬選択される
      const range = new Range();
      range.selectNodeContents(touchedElement);

      const selection = document.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
    } catch (err) {
      console.log("selectParagraph: 【error】 " + err);
    }
  }
}
