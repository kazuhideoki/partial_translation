console.log("★★★◆◆◆revisionBeforeTranslate.js◆◆◆★★★");
var TRANSLATING_TARGET = "translating_target";
var PT_NODE_CLASS_NAME = "pt-node";
var ORIGINAL_CLASS_NAME = "pt-original";
var TRANSLATED_CLASS_NAME = "pt-translated";

try {
  modifyPtNodes(); //  →originalPartとかぶっている → 以前の結果を削除する
} catch (err) {
  console.log("■エラーは " + err);
}

// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■
// ■■■■■■■■■■■■■■■■■■

function modifyPtNodes() {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
  var range = document.getSelection().getRangeAt(0);
  const ptNodes = document.getElementsByClassName(PT_NODE_CLASS_NAME);

  const targetText = range.toString();

  if (ptNodes.length) {
    Array.prototype.forEach.call(ptNodes, function (ptNode) {
      const originalNode = ptNode.childNodes[0];
      console.log("originalNodeは " + originalNode);
      const translatedNode = ptNode.childNodes[1];

      const headPoint = range.comparePoint(originalNode, 0);
      console.log("headPoint " + headPoint);
      const interPoint = range.comparePoint(translatedNode, 0);
      console.log("interPoint " + interPoint);
      const tailPoint = range.comparePoint(
        translatedNode.childNodes[0],
        translatedNode.textContent.length
      );
      console.log("tailPoint " + tailPoint);

      if (headPoint === 0 && interPoint === 1) {
        rangeOnLeft(ptNode, originalNode, translatedNode);
      } else if (headPoint === 0 && interPoint === 0 && tailPoint === 1) {
      } else if (headPoint === 0 && interPoint === 0 && tailPoint === 0) {
      } else if (headPoint === -1 && interPoint === 1) {
      } else if (headPoint === -1 && interPoint === 0 && tailPoint === 1) {
      } else if (headPoint === -1 && interPoint === 0 && tailPoint === 0) {
      } else if (headPoint === -1 && interPoint === -1 && tailPoint === 1) {
      } else if (headPoint === -1 && interPoint === -1 && tailPoint === 0) {
      }
    });

    function rangeOnLeft(ptNode, originalNode, translatedNode) {
      console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
      const originalTextNode = document.createTextNode(
        originalNode.textContent
      );
      ptNode.parentNode.insertBefore(originalTextNode, ptNode);

      ptNode.parentNode.removeChild(ptNode);
    }
  }
}

console.log("★★★◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆★★★");
