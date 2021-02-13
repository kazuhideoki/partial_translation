console.log("★★★◆◆◆replaceText.js◆◆◆★★★");

// 選択部分を取得
var range = document.getSelection().getRangeAt(0);
// 翻訳結果のnodeを作る
var insertingNodes = createInsertingNodes();
// 翻訳結果を挿入
replaceNode(range, insertingNodes);

console.log(range.endContainer.parentElement.innerHTML);

function createInsertingNodes() {
  var c = window.localStorage.getItem("count") || "0";
  var ptData = window.localStorage.getItem(`ptData${c}`);
  var originalText = JSON.parse(ptData).originalText;
  var translatedText = JSON.parse(ptData).translatedText;

  var originalPart = document.createElement("b");
  originalPart.innerHTML = `<b id="original${c}" class="modified" style="color: blue;">${originalText}</b>`;
  var translatedPart = document.createElement("b");
  translatedPart.innerHTML = `<b id="translated${c}" class="modified" style="color: red;">${translatedText}</b>`;

  var insertingNodes = document.createElement("span");
  insertingNodes.appendChild(originalPart);
  insertingNodes.appendChild(translatedPart);

  // insertingNodes.onclick =
  //   insertingNodes.style.display === "none" ? "inline" : "none";
  insertingNodes.addEventListener("click", function () {
    console.log(`◆◆◆${originalText} is Clicked!!!◆◆◆`);
    if (translatedPart.style.display === "none") {
      translatedPart.style.display = "inline";
    } else {
      translatedPart.style.display = "none";
    }
  });

  return insertingNodes;
}

function replaceNode(range, node) {
  range.insertNode(node);
  range.setStartAfter(node);
  range.deleteContents();
}
