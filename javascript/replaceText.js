console.log("★★★◆◆◆replaceText.js◆◆◆★★★");
var count = window.localStorage.getItem("count");
var ptNodeId = `pt_node${count}`;
var PT_NODE_CLASS_NAME = "pt-node";
var COMMON_CLASS_NAME = "pt-modified";
var originalId = `pt_original${count}`;
var ORIGINAL_CLASS_NAME = "pt-original";
var translatedId = `pt_translated${count}`;
var TRANSLATED_CLASS_NAME = "pt-translated";

var insertingNodes = createInsertingNodes(count); // 表示させる翻訳結果のnodeを作る

replaceNode(insertingNodes); // 翻訳結果を挿入

// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■

function createInsertingNodes(c) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  // ローカルストレージ経由で翻訳データを取得
  var ptData = window.localStorage.getItem(`ptData${c}`);
  var originalText = JSON.parse(ptData).originalText;
  var translatedText = JSON.parse(ptData).translatedText;

  // 元テキスト
  var originalPart = document.createElement("span");
  originalPart.innerHTML = originalText;
  originalPart.id = originalId;
  originalPart.className = COMMON_CLASS_NAME + " " + ORIGINAL_CLASS_NAME;
  originalPart.style.color = "blue";

  // 翻訳テキスト
  var translatedPart = document.createElement("span");
  translatedPart.innerHTML = translatedText;
  translatedPart.id = translatedId;
  translatedPart.className = COMMON_CLASS_NAME + " " + TRANSLATED_CLASS_NAME;
  translatedPart.style.color = "red";

  // 2つを合わせる
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
  range.insertNode(node);
  range.setStartAfter(node);
  range.deleteContents();
}

console.log("★★★◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆★★★");
