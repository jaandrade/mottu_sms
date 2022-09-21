import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  bool get authorized => _permissionStatus == PermissionStatus.granted;

  // requestPermission(Permission.sms)

  Future<void> checkPermissionStatus() async {
    _permissionStatus = await Permission.sms.status;
  }

  void checkServiceStatus(BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
      _permissionStatus = await permission.request();
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

}