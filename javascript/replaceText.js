console.log("★★★◆◆◆replaceText.js◆◆◆★★★");
var c = window.localStorage.getItem("count");
var COMMON_CLASS_NAME = "pt-modified";
var ORIGINAL_ID = `pt_original${c}`;
var ORIGINAL_CLASS_NAME = "pt-original";
var TRANSLATED_ID = `pt_translated${c}`;
var TRANSLATED_CLASS_NAME = "pt-translated";

// 選択部分を取得
var range = document.getSelection().getRangeAt(0);
// ★選択部分が以前の結果とかぶっているか判定

//  →originalPartとかぶっている → 以前の結果を削除して新たに翻訳する
// if (isIntersectsOriginalNode()) {
//   deleteIntersectedNode();
//   //  →translatedPart → 閉じて新たに翻訳する
// } else if (isIntersectsTranslatedNode()) {
//   closeIntersectedNode();
// }
// 表示させる翻訳結果のnodeを作る
var insertingNodes = createInsertingNodes(c);
// 翻訳結果を挿入
replaceNode(range, insertingNodes);

incrementDataCount(c);

function isIntersectsOriginalNode(range) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  var originalNodes = document.getElementsByClassName(ORIGINAL_CLASS_NAME);
  var translatedNodes = document.getElementsByClassName(TRANSLATED_CLASS_NAME);

  // ★ここでrangeと比較してかぶっているか調べるところ
  var originalArr = [];
  Array.prototype.forEach.call(originalNodes, (element) => {
    originalArr.push(range.comparePoint(element, 0));
  });
  var translatedArr = [];
  Array.prototype.forEach.call(translatedNodes, (element) => {
    translatedArr.push(range.comparePoint(element, 0));
  });

  var result = originalArr.includes(0) || translatedArr.includes(0);
  console.log(result);
  return result;
}
function deleteIntersectedNode(params) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
}
function isIntersectsTranslatedNode(params) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
}
function closeIntersectedNode(params) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
}
function createInsertingNodes(c) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  var ptData = window.localStorage.getItem(`ptData${c}`);
  var originalText = JSON.parse(ptData).originalText;
  var translatedText = JSON.parse(ptData).translatedText;

  var originalPart = document.createElement("b");
  originalPart.innerHTML = `<b id="${ORIGINAL_ID}" class="${COMMON_CLASS_NAME} ${ORIGINAL_CLASS_NAME}" style="color: blue;">${originalText}</b>`;
  var translatedPart = document.createElement("b");
  translatedPart.innerHTML = `<b id="${TRANSLATED_ID}" class="${COMMON_CLASS_NAME} ${TRANSLATED_CLASS_NAME}" style="color: red;">${translatedText}</b>`;

  var insertingNodes = document.createElement("span");
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

function replaceNode(range, node) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  range.insertNode(node);
  range.setStartAfter(node);
  range.deleteContents();
}

function incrementDataCount(c) {
  var newCount = Number(c) + 1;
  window.localStorage.setItem("count", newCount);
}
