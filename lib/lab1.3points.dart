double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryfee,
}){
  double discount = (promoCode == 'SAVE10') ? (itemPrice*0.10): 0.0;

  double finalDeliveryFee = deliveryfee ?? 500;

  double finalTotal =(itemPrice-discount)+finalDeliveryFee;

  return finalTotal;
}
void main(){
double result = processOrder(orderId: '1', itemPrice: 5000.00, promoCode: 'SAVE10');
print(result);
}