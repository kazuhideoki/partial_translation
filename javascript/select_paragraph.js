console.log("★★★◆◆◆select_paragraph.js★★★◆◆◆");

// アプリ立ち上げ時の初期化
window.localStorage.setItem("isSelectParagraph", "false");

// localStorage経由でisSelectParagraphを渡して, 発火するか否かを判定する。
window.addEventListener("touchstart", selectParagraph, true);

function selectParagraph(e) {
  // console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  let isSelectParagraph = window.localStorage.getItem("isSelectParagraph");
  if (isSelectParagraph === "true") {
    isSelectParagraph = true;
  } else if (isSelectParagraph === "false") {
    isSelectParagraph = false;
  }
  // console.log(isSelectParagraph);

  if (isSelectParagraph) {
    try {
      const touchedElement = e.targetTouches.item(0).target;
      console.log(touchedElement.innerHTML);
      const range = new Range();
      range.selectNodeContents(touchedElement);

      const selection = document.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
    } catch (err) {
      console.log("selectParagraphのerrは" + err);
    }
  }
}
