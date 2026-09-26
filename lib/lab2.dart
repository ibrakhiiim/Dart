// 1. Функция проверки баланса (использует стрелочную синтаксис =>)
void checkBalance({required String name, required double balance}) =>
    print('клиент: $name - баланс: \$${balance.toStringAsFixed(2)}');

// 2. Функция пополнения счета
double deposit({required double currentBalance, double? amount}) {
  double addAmount = amount ?? 0.0; // Если amount null, заменяем на 0.0
  double updatedBalance = currentBalance + addAmount;
  print('Депозит: успешен (+\$$addAmount). Баланс: \$${updatedBalance.toStringAsFixed(2)}');
  return updatedBalance;
}

// 3. Функция снятия наличных
double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  // Проверяем ПИН-код: если null или неверный (не 1234), транзакция отклоняется
  int enteredPin = pinCode ?? 0000;
  if (enteredPin != 1234) {
    print('Ошибка: Неверный ПИН-код. Транзакция отклонена для $name.');
    return currentBalance;
  }

  // Безопасно распаковываем сумму (если null, то 0.0)
  double subAmount = amount ?? 0.0;

  // Проверяем, хватает ли денег на счете
  if (subAmount > currentBalance) {
    print('Ошибка: Недостаточно средств на счете для $name.');
    return currentBalance;
  }

  double updatedBalance = currentBalance - subAmount;
  print('Снятие: успешно (-\$$subAmount). Остаток: \$${updatedBalance.toStringAsFixed(2)}');
  return updatedBalance;
}

void main() {
  double myBalance = 500.0;

  // Проверка баланса
  checkBalance(name: 'Иван', balance: myBalance);

  // Пополнение счета
  myBalance = deposit(currentBalance: myBalance, amount: 200.0);

  // Успешное снятие (с правильным пином 1234)
  myBalance = withdraw(
    name: 'Иван',
    currentBalance: myBalance,
    amount: 100.0,
    pinCode: 1234,
  );

  // Ошибка: попытка снять с неверным пином
  myBalance = withdraw(
    name: 'Иван',
    currentBalance: myBalance,
    amount: 50.0,
    pinCode: 9999,
  );
}