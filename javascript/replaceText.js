var c = window.localStorage.getItem("count") || "0";
var ptData = window.localStorage.getItem(`ptData${c}`);
console.log("ptDataは" + ptData);
var originalText = JSON.parse(ptData).originalText;
var translatedText = JSON.parse(ptData).translatedText;

var selection = document.getSelection();
var focusNode = selection.focusNode;
var focusNodeString = selection.focusNode.parentNode.innerHTML;
var offSetMin = Math.min(selection.focusOffset, selection.anchorOffset);
var offSetMax = Math.max(selection.focusOffset, selection.anchorOffset);
var range = selection.getRangeAt(0);

console.log(range.toString());
range.deleteContents();
console.log(range.toString());
// 選択の直後に翻訳元テキストと結果を挿入
var firstPart = focusNodeString.substr(0, offSetMin);
var lastPart = focusNodeString.substr(offSetMax);
var originalPart = `<b id="original${c} class="modified-by-partial-translate" style="color: blue">${originalText}</b>`;
var translatedPart = `<b id="translated${c}" class="modified-by-partial-translate" style="color: red;">${translatedText}</b>`;

var newNodeString = firstPart + originalPart + translatedPart + lastPart;

focusNode.parentNode.innerHTML = newNodeString;

window.localStorage.setItem("count", String(Number(c) + 1));
