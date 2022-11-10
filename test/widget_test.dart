import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/services/office_services.dart';

void main() async {
  OfficeModel office = await OfficeService().fetchOfficesByUserId(1.toString());
  print(office.location);
}
