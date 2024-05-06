import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_controller.g.dart';

@riverpod
class PermissionsController extends _$PermissionsController {
  @override
  FutureOr<bool> build() {
    return _checkPermissions();
  }

  Future<bool> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final statusMap = {
      Permission.camera: cameraStatus,
    };
    if (Platform.isIOS) {
      final photosStatus = await Permission.photos.status;
      statusMap[Permission.photos] = photosStatus;
    } else if (Platform.isAndroid) {
      final android = await DeviceInfoPlugin().androidInfo;
      final sdkInt = android.version.sdkInt;

      if (sdkInt > 32) {
        final photosStatus = await Permission.photos.status;
        statusMap[Permission.photos] = photosStatus;
      } else {
        final storageStatus = await Permission.storage.status;
        statusMap[Permission.storage] = storageStatus;
      }
    }

    if (statusMap.values.every((status) => status.isGranted)) {
      return true;
    } else {
      final statusMap2 = await _requestPermissions();
      return statusMap2.values.every((status) => status.isGranted);
    }
  }

  Future<Map<Permission, PermissionStatus>> _requestPermissions() async {
    final statusList = [Permission.camera];
    if (Platform.isIOS) {
      statusList.add(Permission.photos);
    } else if (Platform.isAndroid) {
      final android = await DeviceInfoPlugin().androidInfo;
      final sdkInt = android.version.sdkInt;

      if (sdkInt > 32) {
        statusList.add(Permission.photos);
      } else {
        statusList.add(Permission.storage);
      }
    }
    final statusMap = await statusList.request();

    return statusMap;
  }
}
