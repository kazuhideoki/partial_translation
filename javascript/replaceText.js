var c = window.localStorage.getItem("count") || "0";
var ptData = window.localStorage.getItem(`ptData${c}`);
console.log("ptDataは" + ptData);
var translatedText = JSON.parse(ptData).translatedText;
console.log("translatedTextは" + translatedText);

var selection = document.getSelection();
var focusNode = selection.focusNode;
var focusNodeString = selection.focusNode.parentNode.innerHTML;
var offSet = Math.max(selection.focusOffset, selection.anchorOffset);

// 選択の直後に翻訳結果を挿入
var firstPart = focusNodeString.substr(0, offSet);
var secondPart = focusNodeString.substr(offSet);

var newNodeString = `${firstPart}<b style="color: red;">${translatedText}</b>${secondPart}`;

focusNode.parentNode.innerHTML = newNodeString;

window.localStorage.setItem("count", String(Number(c) + 1));
