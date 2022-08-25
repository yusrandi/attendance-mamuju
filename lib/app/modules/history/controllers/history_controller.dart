import 'package:get/get.dart';

class HistoryController extends GetxController {
  RxInt count = 7.obs;

  RxList<MonthModel> listMonth = (List<MonthModel>.of([])).obs;

  @override
  void onInit() {
    super.onInit();
    initModel();
  }

  initModel() {
    listMonth.add(MonthModel("01", "Januari"));
    listMonth.add(MonthModel("02", "Februari"));
    listMonth.add(MonthModel("03", "Maret"));
    listMonth.add(MonthModel("04", "April"));
    listMonth.add(MonthModel("05", "Mei"));
    listMonth.add(MonthModel("06", "Juni"));
    listMonth.add(MonthModel("07", "Juli"));
    listMonth.add(MonthModel("08", "Agustus"));
    listMonth.add(MonthModel("09", "September"));
    listMonth.add(MonthModel("10", "Oktober"));
    listMonth.add(MonthModel("11", "Nopember"));
    listMonth.add(MonthModel("12", "Desember"));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void decrement() => count.value--;
}

class MonthModel {
  String id;
  String label;

  MonthModel(this.id, this.label);
}
