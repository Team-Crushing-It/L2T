void main() {
  print("-----------------------------------");
  var firebaseList = [
    "this is a really simple message",
    "Here I am testing to see the extents of a flexible"
  ];
  var sentenceItMatchesWith = [];
  var _text = "is simple stuff goes extents of this message";
  var recognizedWords = _text.split(" ");
  for (var sentence in firebaseList) {
    var count = 0;
    for (var a in recognizedWords) {
      if (a.length > 3 && sentence.contains(a)) {
        count += 1;
      }
    }
    if (count >= 2) {
      sentenceItMatchesWith.add(sentence);
    }
  }
  print(sentenceItMatchesWith);
}
