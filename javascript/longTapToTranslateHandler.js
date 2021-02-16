console.log("★★★◆◆◆longTapToTranslateHandler.js★★★◆◆◆");

document.addEventListener("touchend", detectTouchEnd, false);

function detectTouchEnd() {
  console.log(`◆◆◆${arguments.callee.name}◆◆◆`);

  if (window.getSelection().toString().length) {
    window.flutter_inappwebview.callHandler(
      "translateByLongTap"
      // "JSより、translateByLongTapだよ！！！！"
    );
  }
}
