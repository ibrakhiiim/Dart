void main(){
  int n =35;
  bool Prime=true;
  if(n <=1){Prime=false;}

  else if(n<=3){Prime=true;}

  for(int i=2;i<n;i++){
    if(n%i==0){
      Prime=false;
      break;
    }
  }
  if(Prime){
    print('$n -> prime');
  }
  else {
    print('$n -> not prime');
  }
}