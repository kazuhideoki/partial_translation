console.log("★★★◆◆◆replaceText.js◆◆◆★★★");
var tagRegExp = /<(".*?"|'.*?'|[^'"])*?>/;
var temporallyRemovedNodes = [];

var range = document.getSelection().getRangeAt(0);
var endContainer = range.endContainer;

function replaceNode(range, node) {
  range.insertNode(node);
  range.setStartAfter(node);
  range.deleteContents();
}

function generateInsertingNodesString() {
  var c = window.localStorage.getItem("count") || "0";
  var ptData = window.localStorage.getItem(`ptData${c}`);
  console.log("ptDataは " + ptData);
  var originalText = JSON.parse(ptData).originalText;
  console.log("originalTextは " + originalText);
  var translatedText = JSON.parse(ptData).translatedText;

  var originalPart = `<b id="original${c}" class="modified" style="color: blue;">${originalText}</b>`;
  var translatedPart = `<b id="translated${c}" class="modified" style="color: red;">${translatedText}</b>`;

  return originalPart + translatedPart;
}

var insertingNodes = document.createElement("span");
insertingNodes.innerHTML = generateInsertingNodesString();
replaceNode(range, insertingNodes);

// var endContainerInnerHTML = range.endContainer.parentNode.innerHTML;
// console.log("endContainerInnerHTMLは " + endContainerInnerHTML);

// var offsetMin = Math.min(range.endOffset, range.startOffset);
// // console.log("offsetMinは " + offsetMin);
// var offsetMax = Math.max(range.endOffset, range.startOffset);
// // console.log("offsetMaxは " + offsetMax);
// var firstPart = endContainerInnerHTML.toString().substr(0, offsetMin);
// console.log("最初のfirstPartは " + firstPart);

// var lastPart = endContainerInnerHTML.substr(offsetMax);

// // ◆◆◆substrしたあとのinnerHTMLからgetElementsByClassNameできるか？
// var tempElm = document.createElement("div");
// tempElm.innerHTML = endContainerInnerHTML;
// console.log("tempElm.innerHTMLは " + tempElm.innerHTML);
// var translatedNode = tempElm.getElementsByClassName(
//   "modified"
//   // ""
// );
// console.log(
//   "endContainerInnerHTMLのtranslatedNodeは " + JSON.stringify(translatedNode)
// );

// function retrieveTranslatedNodes(node, offset) {
//   console.log("◆◆◆retrieveTranslatedNodes◆◆◆");
//   var parentNode = endContainer.parentNode.innerHTML;
//   console.log("retrieveTranslatedNodesのparentNodeは " + parentNode);

//   var firstPart = parentNode.substr(0, offset);
//   var lastPart = parentNode.substr(offset + node.length);

//   var newNodeString = firstPart + node + lastPart;

//   parentNode.innerHTML = newNodeString;
// }
// function insertTranslatedNode() {
//   console.log("◆◆◆insertTranslatedNode◆◆◆");
//   // 選択の直後に翻訳元テキストと結果を挿入
//   var originalPart = `<b id="original${c}" class="modified" style="color: blue;">${originalText}</b>`;
//   var translatedPart = `<b id="translated${c}" class="modified" style="color: red;">${translatedText}</b>`;

//   var newNodeString = firstPart + originalPart + translatedPart + lastPart;

//   endContainer.parentNode.innerHTML = newNodeString;

//   window.localStorage.setItem("count", String(Number(c) + 1));
// }

// function checkHasNodesBeforeSelection() {
//   var result = translatedNode.length ? true : false;
//   console.log("◆◆◆checkHasNodesBeforeSelection 返り値は " + result + " ◆◆◆");
//   return result;
// }

// // 前半部分(firstPart)に翻訳済みNode(translatedNode)があるとreplaceがうまく行かないので一時的に削除
// function removeNode() {
//   console.log("◆◆◆removeNode◆◆◆");
//   // offsetの取得, 正規表現で最初にタグにがあるところ
//   // var offset = firstPart.search(tagRegExp);
//   var offset = firstPart.search(/</);
//   console.log("removeNodeのoffsetは" + offset);

//   // 該当タグを一時的にlocalStorageに退避する
//   var NodesClone = [...translatedNode];
//   temporallyRemovedNodes.push({
//     node: NodesClone[0],
//     offset: offset,
//   });

//   // Nodeを削除する
//   translatedNode[0].remove();
// }

// while (checkHasNodesBeforeSelection()) {
//   removeNode();
// }

// insertTranslatedNode();
// console.log(
//   "temporallyRemovedNodesは " + JSON.stringify(temporallyRemovedNodes)
// );

// while (temporallyRemovedNodes.length) {
//   var data = temporallyRemovedNodes.pop();

//   retrieveTranslatedNodes(data.node, data.offset);
// }
