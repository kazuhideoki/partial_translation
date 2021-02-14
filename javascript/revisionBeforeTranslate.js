console.log("★★★◆◆◆revisionBeforeTranslate.js◆◆◆★★★");

var PT_NODE_CLASS_NAME = "pt-node";
var ORIGINAL_CLASS_NAME = "pt-original";
var TRANSLATED_CLASS_NAME = "pt-translated";

// 選択部分を取得
var selectedRange = document.getSelection().getRangeAt(0);
console.log("最初の selectedRangeは " + selectedRange);

var nodeIdsShouldDeleted = getNodeIdsShouldDeleted(selectedRange); //  →originalPartとかぶっている → 以前の結果を削除する

if (nodeIdsShouldDeleted.length) {
  deleteIntersectedNode(nodeIdsShouldDeleted);
}

var nodeIdsShouldCollapse = getNodeIdsShouldCollapse(selectedRange); // translatedPartとかぶっている → 以前の結果を閉じる
if (nodeIdsShouldCollapse.length) {
  closeIntersectedNode(nodeIdsShouldCollapse, selectedRange);
}

saveTargetData(selectedRange); // 'targetDataへデータを格納'

// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■

function getNodeIdsShouldDeleted(range) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  var ptNodes = document.getElementsByClassName(PT_NODE_CLASS_NAME);

  // ★ここでrangeと比較してかぶっているか調べるところ
  // ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆

  var intersectsNodes = Array.prototype.filter.call(ptNodes, (element) => {
    console.log("_____" + element.outerHTML);
    var headPoint = range.comparePoint(element, 0);
    console.log("headPointは " + headPoint);
    var target = element.childNodes[1];
    console.log(target);
    var headPointOfTranslated = range.comparePoint(target, 0);
    console.log("headPointOfTranslatedは " + headPointOfTranslated);

    var result;
    if (headPoint === 0 || headPointOfTranslated === 0) {
      result = true;
    } else if (headPoint === -1 || headPointOfTranslated === 1) {
      result = true;
    }
    console.log("filterの中で " + result);
    return result;
  });

  // ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆

  console.log(JSON.stringify(intersectsNodes));

  var result = [];
  intersectsNodes.forEach((element) => {
    result.push(element.id);
  });

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

function saveTargetData(range) {
  var targetData = {
    targetText: range.toString(),
    isTranslating: !range.collapsed,
  };
  window.localStorage.setItem("targetData", JSON.stringify(targetData));
}
console.log("★★★◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆★★★");
