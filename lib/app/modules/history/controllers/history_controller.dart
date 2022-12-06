import 'package:attendance/app/data/models/presensi_model.dart';
import 'package:attendance/app/data/services/presensi_services.dart';
import 'package:get/get.dart';

import '../../auth/controllers/authentication_manager.dart';

class HistoryController extends GetxController {
  RxInt count = 7.obs;

  RxList<MonthModel> listMonth = (List<MonthModel>.of([])).obs;
  RxList<Presensi> listPresensi = (List<Presensi>.of([])).obs;
  final AuthenticationManager _authManager = Get.put(AuthenticationManager());

  RxString month = "...".obs;

  @override
  void onInit() async {
    super.onInit();
    initModel();
    PresensiModel model = await getPresensiThisMonthByNip();
    month.value = model.month!;
    count.value = int.parse(model.monthnumber!) - 1;
    listPresensi.addAll(model.presensi!);
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

  Future<PresensiModel> getPresensiThisMonthByNip() async {
    return await PresensiService()
        .fetchPresensiThisMonthByUserNip(_authManager.getToken()!);
  }
}

class MonthModel {
  String id;
  String label;

  MonthModel(this.id, this.label);
}
