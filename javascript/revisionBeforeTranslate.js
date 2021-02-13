// 選択部分を取得
var selectedRange = document.getSelection().getRangeAt(0);
console.log("最初の selectedRangeは " + selectedRange);
// ★選択部分が以前の結果とかぶっているか判定

//  →originalPartとかぶっている → 以前の結果を削除して新たに翻訳する
var nodeIdsShouldDeleted = getNodeIdsShouldDeleted(selectedRange);
var intersectsTranslatedNodeIds = isIntersectsTranslatedNodes(selectedRange);

if (nodeIdsShouldDeleted.length) {
  deleteIntersectedNode(nodeIdsShouldDeleted);
  // console.log("rangeは " + selectedRange.toString());
  // selectedRange = document.getSelection().getRangeAt(0);
  // console.log("rangeは " + selectedRange.toString());
  // } else if (intersectsTranslatedNodeIds.length) {
} else if (false) {
  closeIntersectedNode();
  selectedRange = document.getSelection().getRangeAt(0);
}

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

function isIntersectsTranslatedNodes(params) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
}
function closeIntersectedNode(params) {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
}
