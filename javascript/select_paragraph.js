console.log("★★★◆◆◆select_paragraph.js★★★◆◆◆");

window.addEventListener("touchstart", function (e) {
  selectParagraph(e);
});

function selectParagraph(e) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

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
