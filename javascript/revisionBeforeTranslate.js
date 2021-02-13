console.log("★★★◆◆◆revisionBeforeTranslate.js◆◆◆★★★");

var COMMON_CLASS_NAME = "pt-modified";
var ORIGINAL_CLASS_NAME = "pt-original";
var TRANSLATED_CLASS_NAME = "pt-translated";

// 選択部分を取得
var selectedRange = document.getSelection().getRangeAt(0);
console.log("最初の selectedRangeは " + selectedRange);
// ★選択部分が以前の結果とかぶっているか判定

//  →originalPartとかぶっている → 以前の結果を削除して新たに翻訳する
var nodeIdsShouldDeleted = getNodeIdsShouldDeleted(selectedRange);

if (nodeIdsShouldDeleted.length) {
  deleteIntersectedNode(nodeIdsShouldDeleted);
}

var nodeIdsShouldCollapse = getNodeIdsShouldCollapse(selectedRange);
if (nodeIdsShouldCollapse.length) {
  closeIntersectedNode(nodeIdsShouldCollapse, selectedRange);
}

// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■

function getNodeIdsShouldDeleted(range) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  var originalNodes = document.getElementsByClassName(ORIGINAL_CLASS_NAME);

  console.log(originalNodes);
  console.log(originalNodes.length);
  var translatedNodes = document.getElementsByClassName(TRANSLATED_CLASS_NAME);
  console.log(translatedNodes.length);

  // ★ここでrangeと比較してかぶっているか調べるところ
  //
  var filteredOriginalNodes = Array.prototype.filter.call(
    originalNodes,
    (element) => {
      var result = range.comparePoint(element, 0) === 0;
      console.log("filterの中で " + result);
      return result;
    }
  );

  var filteredTranslatedNodes = Array.prototype.filter.call(
    translatedNodes,
    (element) => {
      return range.comparePoint(element, 0) === 0;
    }
  );

  var intersectsNodes = [...filteredOriginalNodes, ...filteredTranslatedNodes];
  console.log(JSON.stringify(intersectsNodes));

  var intersectsNodeIds = [];
  intersectsNodes.forEach((element) => {
    intersectsNodeIds.push(element.parentNode.id);
  });

  // ダブリをなくす
  var setResult = new Set(intersectsNodeIds);
  let result = Array.from(setResult);

  console.log("returnは " + JSON.stringify(result));

  return result;
}

function deleteIntersectedNode(ids) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  var ptNodes = [];
  ids.forEach(function (id) {
    ptNodes.push(document.getElementById(id));
  });

  console.log(JSON.stringify(ptNodes));

  ptNodes.forEach(function (ptNode) {
    console.log("ptNodeは" + ptNode);
    // translatedNodeは削除
    var translatedNode = ptNode.getElementsByClassName(
      TRANSLATED_CLASS_NAME
    )[0];
    ptNode.removeChild(translatedNode);

    // originalNode の前にtextContentをつけてから削除
    var originalNode = ptNode.getElementsByClassName(ORIGINAL_CLASS_NAME)[0];
    var textContent = originalNode.textContent;
    var textNode = document.createTextNode(textContent);
    console.log("textNode.textContentは " + textNode.textContent);
    console.log(ptNode.parentNode.innerHTML);

    ptNode.parentNode.insertBefore(textNode, ptNode);
    console.log(ptNode.parentNode.innerHTML);
    ptNode.parentNode.removeChild(ptNode);
  });
}

function getNodeIdsShouldCollapse(range) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  var translatedNodes = document.getElementsByClassName(TRANSLATED_CLASS_NAME);
  console.log("translatedNodes.lengthは " + translatedNodes.length);

  var filteredTranslatedNodes = Array.prototype.filter.call(
    translatedNodes,
    (element) => {
      console.log("(テキスト)" + element.textContent);
      console.log(element.textContent.length);
      console.log(element.childNodes[0].length);
      var offset = element.childNodes[0].length;
      var result = range.comparePoint(element.childNodes[0], offset);
      console.log("filteredTranslatedNodesのfilterのresultは " + result);
      return result === 0;
    }
  );

  var intersectsNodeIds = [];
  filteredTranslatedNodes.forEach((element) => {
    intersectsNodeIds.push(element.parentNode.id);
  });
  console.log(JSON.stringify(intersectsNodeIds));

  return intersectsNodeIds;
}

function closeIntersectedNode(ids, range) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  var ptNodes = [];
  ids.forEach(function (id) {
    ptNodes.push(document.getElementById(id));
  });

  ptNodes.forEach(function (ptNode) {
    var translatedNode = ptNode.getElementsByClassName(
      TRANSLATED_CLASS_NAME
    )[0];

    translatedNode.style.display = "none";
    range.setStartAfter(ptNode);
  });
}
