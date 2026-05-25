import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoResult {
  final Duration position;
  final bool isPlaying;

  const FullscreenVideoResult({
    required this.position,
    required this.isPlaying,
  });
}

class ExerciseFullscreenVideoPage extends StatefulWidget {
  final String url;
  final Duration initialPosition;
  final bool autoPlay;

  const ExerciseFullscreenVideoPage({
    super.key,
    required this.url,
    required this.initialPosition,
    required this.autoPlay,
  });

  @override
  State<ExerciseFullscreenVideoPage> createState() =>
      _ExerciseFullscreenVideoPageState();
}

class _ExerciseFullscreenVideoPageState
    extends State<ExerciseFullscreenVideoPage> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    setState(() {
      _isInitializing = true;
      _hasError = false;
    });

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    _controller = controller;

    try {
      await controller.initialize();
      await controller.setLooping(false);

      if (widget.initialPosition > Duration.zero &&
          widget.initialPosition < controller.value.duration) {
        await controller.seekTo(widget.initialPosition);
      }

      if (widget.autoPlay) {
        await controller.play();
      }

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    } catch (e, st) {
      debugPrint('Ошибка инициализации полноэкранного видео');
      debugPrint('Fullscreen video url: ${widget.url}');
      debugPrint('Fullscreen video error: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    setState(() {
      _showControls = true;
    });
  }

  void _close() {
    final controller = _controller;

    Navigator.of(context).pop(
      FullscreenVideoResult(
        position: controller?.value.position ?? widget.initialPosition,
        isPlaying: controller?.value.isPlaying ?? false,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _close();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final padding = MediaQuery.of(context).padding;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (_isInitializing)
              const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (_hasError ||
                controller == null ||
                !controller.value.isInitialized)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.videocam_off_outlined,
                      size: 42,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Не удалось загрузить видео',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _showControls = !_showControls;
                      });
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),
                  ),
                ),

                if (_showControls)
                  Center(
                    child: ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        return IconButton(
                          iconSize: 72,
                          color: Colors.white,
                          onPressed: _togglePlay,
                          icon: Icon(
                            value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                          ),
                        );
                      },
                    ),
                  ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: padding.bottom + 16,
                  child: VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    padding: EdgeInsets.zero,
                    colors: VideoProgressColors(
                      playedColor: appPrimaryBlue,
                      bufferedColor: Colors.white.withOpacity(0.35),
                      backgroundColor: Colors.white.withOpacity(0.18),
                    ),
                  ),
                ),
              ],

            Positioned(
              top: padding.top + 8,
              left: 12,
              child: _FullscreenOverlayIconButton(
                icon: Icons.close,
                onPressed: _close,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullscreenOverlayIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FullscreenOverlayIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.45),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 24,
        onPressed: onPressed,
      ),
    );
  }
}