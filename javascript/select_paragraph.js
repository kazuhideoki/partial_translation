console.log("★★★◆◆◆select_paragraph.js★★★◆◆◆");

// localStorage経由でisSelectParagraphを渡して, 発火するか否かを判定する。
window.addEventListener("touchstart", selectParagraph, true);

function selectParagraph(e) {
  let isSelectParagraph = window.localStorage.getItem("isSelectParagraph");
  if (isSelectParagraph === "true") {
    isSelectParagraph = true;
  } else if (isSelectParagraph === "false") {
    isSelectParagraph = false;
  }

  if (isSelectParagraph) {
    try {
      const touchedElement = e.targetTouches.item(0).target;
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
