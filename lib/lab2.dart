void checkBalance({required String name, required double balance}) =>
    print('$name : $balance');

double deposit({required double currentBalance, double? amount}) {
  double addAmount = amount ?? 0.0;
  double updatedBalance = currentBalance + addAmount;
  print('+$addAmount. balance: $updatedBalance');
  return updatedBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int enteredPin = pinCode ?? 0000;
  if (enteredPin != 7777) {
    print('wrong');
    return currentBalance;
  }

  double subAmount = amount ?? 0.0;

  if (subAmount > currentBalance) {
    print('less balance.');
    return currentBalance;
  }

  double updatedBalance = currentBalance - subAmount;
  print('-$subAmount. balance: $updatedBalance');
  return updatedBalance;
}

void main() {
  double myBalance = 1500.0;

  checkBalance(name: 'Ibrakhim', balance: myBalance);

  myBalance = deposit(currentBalance: myBalance, amount: 350.0);

  myBalance = withdraw(
    name: 'Ibrakhim',
    currentBalance: myBalance,
    amount: 200.0,
    pinCode: 7777,
  );

  myBalance = withdraw(
    name: 'Ibrakhim',
    currentBalance: myBalance,
    amount: 50.0,
    pinCode: 1111,
  );
}