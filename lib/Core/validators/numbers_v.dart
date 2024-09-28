String? numbersValidator(String? text) {
  if (text == null) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  if (text.isEmpty) {
    return "لا يمكن ان يكون حقل الادخال فارغ";
  }
  if (int.tryParse(text) == null) {
    return "ادخل رقم صحيح";
  }
  if (int.parse(text) <= 0) {
    return "يجب ان يكون الرقم 1 او اكثر";
  }
  return null;
}
