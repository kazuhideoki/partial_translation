console.log("★★★◆◆◆replaceText.js◆◆◆★★★");
var count = window.localStorage.getItem("count");
var ptNodeId = `pt_node${count}`;
var PT_NODE_CLASS_NAME = "pt-node";
var COMMON_CLASS_NAME = "pt-modified";
var originalId = `pt_original${count}`;
var ORIGINAL_CLASS_NAME = "pt-original";
var translatedId = `pt_translated${count}`;
var TRANSLATED_CLASS_NAME = "pt-translated";

// 選択部分を取得
var selectedRange = document.getSelection().getRangeAt(0);
console.log("最初の selectedRangeは " + selectedRange);
// ★選択部分が以前の結果とかぶっているか判定

// 表示させる翻訳結果のnodeを作る
var insertingNodes = createInsertingNodes(count);
// 翻訳結果を挿入
replaceNode(insertingNodes);

incrementDataCount(count);

console.log(selectedRange.endContainer.parentNode.innerHTML);

//
//
//

function createInsertingNodes(c) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  var ptData = window.localStorage.getItem(`ptData${c}`);
  var originalText = JSON.parse(ptData).originalText;
  var translatedText = JSON.parse(ptData).translatedText;

  var originalPart = document.createElement("b");
  originalPart.innerHTML = originalText;
  originalPart.id = originalId;
  originalPart.className = COMMON_CLASS_NAME + " " + ORIGINAL_CLASS_NAME;
  originalPart.style.color = "blue";
  console.log(originalPart.innerHTML);

  var translatedPart = document.createElement("b");
  translatedPart.innerHTML = translatedText;
  translatedPart.id = translatedId;
  translatedPart.className = COMMON_CLASS_NAME + " " + TRANSLATED_CLASS_NAME;
  translatedPart.style.color = "red";

  var insertingNodes = document.createElement("span");
  insertingNodes.id = ptNodeId;
  insertingNodes.className = PT_NODE_CLASS_NAME;
  insertingNodes.appendChild(originalPart);
  insertingNodes.appendChild(translatedPart);

  // 表示切り替えのイベントを登録
  insertingNodes.addEventListener("click", function () {
    console.log(`◆◆◆${arguments.callee.name} ${originalText} is Clicked!!!◆◆◆`);
    if (translatedPart.style.display === "none") {
      translatedPart.style.display = "inline";
    } else {
      translatedPart.style.display = "none";
    }
  });

  return insertingNodes;
}

function replaceNode(node) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  range = document.getSelection().getRangeAt(0);
  console.log(range);
  range.insertNode(node);
  range.setStartAfter(node);
  console.log(range);
  range.deleteContents();
}

function incrementDataCount(c) {
  var newCount = Number(c) + 1;
  window.localStorage.setItem("count", newCount);
}

{
  /* <span id="pt_node101" class="pt-node">
  <b id="pt_original101" class="pt-modified pt-original" style="color: blue;">
    over
  </b>
</span>; */
}
