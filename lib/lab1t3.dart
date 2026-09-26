void main() {
  String text = 'flutter mobile development';
  String vowel = 'aeoiu';
  int count =0;
  for (int i =0;i<text.length;i++){
    if(vowel.contains(text[i].toLowerCase())){
      count++;
    }
  }
  print(count);
}