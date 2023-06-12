import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'installer_close_button.dart';

class QrView extends StatefulWidget {
  final ValueNotifier<String?> qrResult;
  const QrView({Key? key, required this.qrResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  List<BarcodeFormat> allowedBarcodeFormats = [BarcodeFormat.qrCode];
  late MobileScannerController controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      formats: allowedBarcodeFormats);
  BarcodeCapture? barcode;
  MobileScannerArguments? arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        flex: 8,
        child: Stack(
          children: [
            _buildQrView(context),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 10, top: 30),
                    child: InstallerCloseButton(
                      icon: Icons.close,
                    )),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 65,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller.hasTorchState,
                          builder: (context, state, child) {
                            if (state != true) {
                              return const SizedBox.shrink();
                            }
                            return IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable: controller.torchState,
                                builder: (context, state, child) {
                                  if (state == null) {
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  }
                                  switch (state) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                      );
                                  }
                                },
                              ),
                              iconSize: 42.0,
                              onPressed: () => controller.toggleTorch(),
                            );
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: ValueListenableBuilder(
                            valueListenable: controller.cameraFacingState,
                            builder: (context, state, child) {
                              if (state == null) {
                                return const Icon(Icons.camera_front);
                              }
                              switch (state) {
                                case CameraFacing.front:
                                  return const Icon(Icons.camera_front);
                                case CameraFacing.back:
                                  return const Icon(Icons.camera_rear);
                              }
                            },
                          ),
                          iconSize: 42.0,
                          onPressed: () => controller.switchCamera(),
                        ),
                      ]),
                )),
          ],
        ),
      )
    ]));
  }

  Widget _buildQrView(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 3.4,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          fit: BoxFit.cover,
          scanWindow: scanWindow,
          controller: controller,
          onScannerStarted: (arguments) {
            setState(() {
              this.arguments = arguments;
            });
          },
          onDetect: (capture) {
            debugPrint('Barcode found! ${capture.barcodes.first.rawValue}');
            setState(() {
              widget.qrResult.value = capture.barcodes.first.rawValue;
            });
          },
        ),
        CustomPaint(
          painter: ScannerOverlay(scanWindow),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);
  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.58)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final borderPaint = Paint()
      ..color = InstallerColor.blueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, borderPaint);
    canvas.drawPath(
      backgroundWithCutout,
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
