import '../../domain/entities/purchase_item.dart';

class PurchaseItemModel extends PurchaseItem {
  PurchaseItemModel({
    required super.id,
    required super.uuid,
    required super.userName,
    required super.amount,
    required super.itemId,
    required super.itemType,
    required super.dayAndMoth,
  });
  factory PurchaseItemModel.fromJson(Map json) {
    return PurchaseItemModel(
      id: json["id"],
      uuid: json["uuid"],
      userName: json["user_name"] ?? "",
      amount: json["amount"],
      itemId: json["item_id"],
      itemType: json["item_type"],
      dayAndMoth: json["day_month"],
    );
  }
  factory PurchaseItemModel.fromClass(PurchaseItem item) {
    return PurchaseItemModel(
      id: item.id,
      uuid: item.uuid,
      userName: item.userName,
      amount: item.amount,
      itemId: item.itemId,
      itemType: item.itemType,
      dayAndMoth: item.dayAndMoth,
    );
  }
  toJson() {
    return {
      "uuid": uuid,
      "user_name": userName,
      "amount": amount,
      "item_id": itemId,
      "item_type": itemType,
      "day_month": "${DateTime.now().month}/${DateTime.now().day}",
    };
  }
}
