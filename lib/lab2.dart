void checkBalance({required String name, required double balance}) =>
    print('$name: \$${balance.toStringAsFixed(2)}');

double deposit({required double currentBalance, double? amount}) {
  double addAmount = amount ?? 0.0;
  double updatedBalance = currentBalance + addAmount;
  print('+\$$addAmount. Баланс: \$${updatedBalance.toStringAsFixed(2)}');
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
    print('Неверный ПИН-код.');
    return currentBalance;
  }

  double subAmount = amount ?? 0.0;

  if (subAmount > currentBalance) {
    print('Недостаточно средств.');
    return currentBalance;
  }

  double updatedBalance = currentBalance - subAmount;
  print('-\$$subAmount. Баланс: \$${updatedBalance.toStringAsFixed(2)}');
  return updatedBalance;
}

void main() {
  double myBalance = 1500.0;

  checkBalance(name: 'Ибрахим', balance: myBalance);

  myBalance = deposit(currentBalance: myBalance, amount: 350.0);

  myBalance = withdraw(
    name: 'Ибрахим',
    currentBalance: myBalance,
    amount: 200.0,
    pinCode: 7777,
  );

  myBalance = withdraw(
    name: 'Ибрахим',
    currentBalance: myBalance,
    amount: 50.0,
    pinCode: 1111,
  );
}