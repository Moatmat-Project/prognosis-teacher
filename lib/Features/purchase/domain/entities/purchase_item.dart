class PurchaseItem {
  //
  final int id;
  final String uuid;
  final String userName;
  //
  final int amount;
  //
  final String itemType;
  final String itemId;
  //
  late String dayAndMoth;
  final String? createdAt;

  PurchaseItem({
    this.id = 0,
    this.uuid = "",
    required this.userName,
    required this.amount,
    required this.itemType,
    required this.itemId,
    required this.dayAndMoth,
    this.createdAt,
  });
  PurchaseItem copyWith({
    int? id,
    String? uuid,
    String? userName,
    int? amount,
    String? itemId,
    String? itemType,
    String? dayAndMoth,
    String? createdAt,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      dayAndMoth: dayAndMoth ?? this.dayAndMoth,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
