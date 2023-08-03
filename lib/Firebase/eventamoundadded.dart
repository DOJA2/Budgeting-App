class BudgetInput {
  final String id;
  final String event;
  final double amount;

  const BudgetInput({
    required this.id,
    required this.event,
    required this.amount,
  });

  tojson() {
    return {
      "event": event, 
      "amount": amount
      };
  }
}

