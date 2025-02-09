import 'package:get/get.dart';
import 'package:practiceproject/utils/storage_service.dart';

import 'main.dart';

class DashboardController extends GetxController {
  final StorageService storageService = StorageService();
  RxString userRole = ''.obs;
  RxList menuRoleWise = [
    {

    }
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserType();
  }

  getUserType() async {
    String? usertype = storageService.read<String>('userType');
    if (usertype == 'schoolAdmin') {
      userRole.value = 'School Admin';
    } else if (usertype == 'branchAdmin') {
      userRole.value = 'Branch Admin';
    } else if (usertype == 'teacher') {
      userRole.value = 'Teacher';
    } else if (usertype == 'classTeacher') {
      userRole.value = 'Class Teacher';
    }
  }
}
