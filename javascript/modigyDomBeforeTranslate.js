console.log("★★★◆◆◆modigyDomBeforeTranslate.js◆◆◆★★★");
var count = window.localStorage.getItem("count");
var translatingNodeId = `pt_translating_id${count}`;
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
  const selection = document.getSelection();
  const range = selection.getRangeAt(0);
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
        rangeOnLeft(ptNode, originalNode);
      } else if (headPoint === 0 && interPoint === 0 && tailPoint === 1) {
        rangeOnLeft(ptNode, originalNode);
      } else if (headPoint === 0 && interPoint === 0 && tailPoint === 0) {
        rangeOnLeft(ptNode, originalNode);
      } else if (headPoint === -1 && interPoint === 1) {
        // ※spanタグ追加している
        rangeInsideNode(ptNode, originalNode);
      } else if (headPoint === -1 && interPoint === 0 && tailPoint === 1) {
        // ※spanタグ追加している
        rangeInsideNode(ptNode, originalNode);
      } else if (headPoint === -1 && interPoint === 0 && tailPoint === 0) {
        rangeOnLeft(ptNode, originalNode);
      } else if (headPoint === -1 && interPoint === -1 && tailPoint === 1) {
        rangeInsideTranslatedNode();
      } else if (headPoint === -1 && interPoint === -1 && tailPoint === 0) {
        rangeOnRight(ptNode, translatedNode, originalNode);
      }
    });

    function rangeOnLeft(ptNode, originalNode) {
      console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
      const originalTextNode = document.createTextNode(
        originalNode.textContent
      );
      ptNode.parentNode.insertBefore(originalTextNode, ptNode);

      ptNode.parentNode.removeChild(ptNode);
    }
    // ※originalTextをspanNodeにしてそこをselectするようにしている
    // そのためよけいなspanが追加される → バグの温床か？
    function rangeInsideNode(ptNode, originalNode) {
      console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
      const originalTextSpanNode = document.createElement("span");
      originalTextSpanNode.id = translatingNodeId;
      originalTextSpanNode.innerHTML = originalNode.textContent;
      ptNode.parentNode.insertBefore(originalTextSpanNode, ptNode);

      window.getSelection().selectAllChildren(originalTextSpanNode);

      ptNode.parentNode.removeChild(ptNode);
    }

    function rangeInsideTranslatedNode() {
      console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
      window.getSelection().removeAllRanges();
    }
    function rangeOnRight(ptNode, translatedNode, originalNode) {
      console.log(`◆◆◆${arguments.callee.name}◆◆◆`);
      window.getSelection().removeAllRanges();

      // newRangeまで作れるが、addRangeが効かない
      // const newRange = document.createRange();
      // const endContainerNode = range.endContainer.cloneNode();
      // newRange.selectNodeContents(endContainerNode);
      // newRange.setEnd(endContainerNode, range.endOffset);
      // console.log(JSON.stringify(newRange.toString()));

      window.getSelection().addRange(newRange);
    }
  }
}

console.log("★★★◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆★★★");
