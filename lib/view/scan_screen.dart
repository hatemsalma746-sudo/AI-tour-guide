import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_route.dart';
import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.museumId = mockMuseumId});

  final String museumId;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  final _galleryPicker = ImagePicker();
  CameraController? _cameraController;
  Uint8List? _selectedImage;
  bool _cameraLoading = true;
  bool _isInitializing = false;
  bool _isPickingImage = false;
  bool _isCapturing = false;
  bool _flashEnabled = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing ||
        _cameraController != null ||
        _selectedImage != null) {
      return;
    }
    _isInitializing = true;
    if (mounted && !_cameraLoading) {
      setState(() => _cameraLoading = true);
    }

    CameraController? controller;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException(
          'NoCameraAvailable',
          'No camera is available on this device.',
        );
      }
      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final nextController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      controller = nextController;
      await nextController.initialize();
      if (!mounted) {
        await nextController.dispose();
        controller = null;
        return;
      }
      setState(() {
        _cameraController = nextController;
        _cameraError = null;
        _flashEnabled = false;
      });
      controller = null;
    } on CameraException catch (error) {
      if (mounted) {
        setState(() => _cameraError = _cameraErrorText(error));
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _cameraError =
              'The camera is not available. Choose a photo from the gallery.',
        );
      }
    } finally {
      await controller?.dispose();
      _isInitializing = false;
      if (mounted) {
        setState(() => _cameraLoading = false);
      }
    }
  }

  String _cameraErrorText(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera permission is off. Allow camera access in your phone settings, or choose a photo from the gallery.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this phone. Choose a photo from the gallery.';
      case 'NoCameraAvailable':
        return 'No camera is available on this device. Choose a photo from the gallery.';
      default:
        return 'The camera could not start. Choose a photo from the gallery or try again.';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final controller = _cameraController;
      _cameraController = null;
      if (mounted) {
        setState(() {});
      }
      if (controller != null) {
        unawaited(controller.dispose());
      }
    } else if (state == AppLifecycleState.resumed &&
        !_isPickingImage &&
        _selectedImage == null) {
      _initializeCamera();
    }
  }

  Future<void> _takePhoto() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final photo = await controller.takePicture();
      final bytes = await photo.readAsBytes();
      if (mounted) {
        setState(() => _selectedImage = bytes);
      }
    } on CameraException catch (error) {
      if (mounted) {
        showToast(context, _cameraErrorText(error));
      }
    } catch (_) {
      if (mounted) {
        showToast(
          context,
          tourText(
            context,
            'The photo could not be captured. Please try again.',
            'تعذر التقاط الصورة. حاول مرة أخرى.',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _chooseFromGallery() async {
    if (_isPickingImage || _isCapturing) {
      return;
    }
    setState(() => _isPickingImage = true);
    try {
      final controller = _cameraController;
      _cameraController = null;
      if (controller != null) {
        await controller.dispose();
      }
      if (mounted) {
        setState(() {});
      }
      final photo = await _galleryPicker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        if (mounted) {
          setState(() => _selectedImage = bytes);
        }
      }
    } catch (_) {
      if (mounted) {
        showToast(
          context,
          tourText(
            context,
            'The gallery could not be opened. Please try again.',
            'تعذر فتح المعرض. حاول مرة أخرى.',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
        if (_selectedImage == null && _cameraController == null) {
          _initializeCamera();
        }
      }
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final next = _flashEnabled ? FlashMode.off : FlashMode.torch;
    try {
      await controller.setFlashMode(next);
      if (mounted) {
        setState(() => _flashEnabled = !_flashEnabled);
      }
    } on CameraException {
      if (mounted) {
        showToast(
          context,
          tourText(
            context,
            'Flash is not available on this camera.',
            'الفلاش غير متاح في هذه الكاميرا.',
          ),
        );
      }
    }
  }

  void _retakePhoto() {
    setState(() => _selectedImage = null);
    if (_cameraController == null) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = _cameraController;
    _cameraController = null;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  Widget _cameraView() {
    final selectedImage = _selectedImage;
    if (selectedImage != null) {
      return Positioned.fill(
        child: Image.memory(selectedImage, fit: BoxFit.cover),
      );
    }
    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      final previewSize = controller.value.previewSize;
      if (previewSize == null) {
        return Positioned.fill(child: CameraPreview(controller));
      }
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
    return Positioned.fill(
      child: Container(
        color: const Color(0xff211e18),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_cameraLoading)
              const CircularProgressIndicator(color: tourGold)
            else
              const Icon(
                Icons.no_photography_outlined,
                color: tourGold,
                size: 38,
              ),
            const SizedBox(height: 14),
            Text(
              _cameraLoading
                  ? tourText(
                      context,
                      'Starting camera…',
                      'جارٍ تشغيل الكاميرا…',
                    )
                  : isArabic(context)
                  ? 'الكاميرا غير متاحة. اختر صورة من المعرض.'
                  : _cameraError ?? 'Camera unavailable',
              textAlign: TextAlign.center,
              style: const TextStyle(color: tourCream, height: 1.4),
            ),
            if (!_cameraLoading) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _initializeCamera,
                icon: const Icon(Icons.refresh),
                label: Text(
                  tourText(context, 'Try camera again', 'حاول تشغيل الكاميرا'),
                ),
                style: TextButton.styleFrom(foregroundColor: tourGold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Scan Artifact',
    centerTitle: true,
    fullWidth: true,
    trailing: IconButton(
      tooltip: tourText(context, 'Toggle flash', 'تشغيل الفلاش'),
      onPressed: _toggleFlash,
      icon: Icon(
        _flashEnabled ? Icons.flash_on : Icons.flash_off,
        color: tourGold,
      ),
    ),
    child: LayoutBuilder(
      builder: (context, box) {
        final cameraSide = box.maxWidth < box.maxHeight * .56
            ? box.maxWidth
            : box.maxHeight * .56;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: SizedBox.square(
                    dimension: cameraSide,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _cameraView(),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x22000000),
                                  Color(0x08000000),
                                  Color(0x990d0c09),
                                ],
                                stops: [0, .5, 1],
                              ),
                            ),
                          ),
                          const Center(child: Viewfinder(squareFrame: true)),
                          Positioned(
                            bottom: 14,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _StatusPill(
                                text: _selectedImage != null
                                    ? tourText(
                                        context,
                                        'Photo ready to scan',
                                        'الصورة جاهزة للمسح',
                                      )
                                    : _cameraController?.value.isInitialized ==
                                          true
                                    ? tourText(
                                        context,
                                        'Camera is ready',
                                        'الكاميرا جاهزة',
                                      )
                                    : _cameraLoading
                                    ? tourText(
                                        context,
                                        'Starting camera…',
                                        'جارٍ تشغيل الكاميرا…',
                                      )
                                    : tourText(
                                        context,
                                        'Camera unavailable',
                                        'الكاميرا غير متاحة',
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  _selectedImage == null
                      ? tourText(
                          context,
                          'Point the camera at an artifact',
                          'وجّه الكاميرا نحو القطعة الأثرية',
                        )
                      : tourText(
                          context,
                          'Photo selected for scanning',
                          'تم اختيار الصورة للمسح',
                        ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: tourCream, fontSize: 16),
                ),
                Text(
                  tourText(
                    context,
                    'Keep the artifact inside the frame for best results.',
                    'ضع القطعة داخل الإطار للحصول على أفضل نتيجة.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: tourMuted, fontSize: 13),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundControl(
                      tooltip: tourText(
                        context,
                        'Choose from phone gallery',
                        'اختر من معرض الهاتف',
                      ),
                      icon: Icons.photo_library_outlined,
                      onPressed: _chooseFromGallery,
                    ),
                    const SizedBox(width: 28),
                    _ShutterControl(
                      isBusy: _isCapturing || _isPickingImage,
                      hasPhoto: _selectedImage != null,
                      onPressed: _selectedImage == null
                          ? _takePhoto
                          : _retakePhoto,
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(width: 28),
                      _RoundControl(
                        tooltip: tourText(
                          context,
                          'Retake photo',
                          'التقط الصورة مرة أخرى',
                        ),
                        icon: Icons.refresh,
                        onPressed: _retakePhoto,
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: () => pushScreen(
                    context,
                    AppRoute.scanErrorScreen,
                    widget.museumId,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: tourMuted,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    tourText(
                      context,
                      'Preview not recognized state',
                      'معاينة حالة عدم التعرّف',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    decoration: BoxDecoration(
      color: tourInk.withValues(alpha: .82),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 9, color: tourGold),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: tourCream, fontSize: 12)),
      ],
    ),
  );
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      foregroundColor: tourCream,
      backgroundColor: tourRaised,
      fixedSize: const Size(50, 50),
      side: const BorderSide(color: Color(0xff5a4a2f)),
    ),
  );
}

class _ShutterControl extends StatelessWidget {
  const _ShutterControl({
    required this.isBusy,
    required this.hasPhoto,
    required this.onPressed,
  });

  final bool isBusy;
  final bool hasPhoto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: hasPhoto
        ? tourText(context, 'Retake photo', 'التقط الصورة مرة أخرى')
        : tourText(context, 'Take photo', 'التقط صورة'),
    child: IconButton(
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(strokeWidth: 2, color: tourInk),
            )
          : Icon(hasPhoto ? Icons.refresh : Icons.camera_alt, size: 28),
      style: IconButton.styleFrom(
        foregroundColor: tourInk,
        backgroundColor: tourCream,
        fixedSize: const Size(68, 68),
        side: const BorderSide(color: tourGold, width: 3),
      ),
    ),
  );
}
