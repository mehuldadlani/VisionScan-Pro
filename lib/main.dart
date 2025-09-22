import 'package:visionscan_pro/app/app.dart';
import 'package:visionscan_pro/app/bootstrap.dart';

/// Entry point for VisionScan Pro application
///
/// This function initializes the application with proper error handling,
/// system configuration, and dependency injection setup using the bootstrap pattern.
void main() {
  bootstrap(() => const VisionScanProApp());
}
