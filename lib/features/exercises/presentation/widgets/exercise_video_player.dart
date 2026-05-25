import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_fullscreen_video_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  final String url;
  final bool isActive;

  const ExerciseVideoPlayer({
    super.key,
    required this.url,
    required this.isActive,
  });

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant ExerciseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _controller?.pause();
      _controller?.dispose();
      _controller = null;
      _initializeController();
      return;
    }

    if (!widget.isActive) {
      _controller?.pause();
    }
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

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    } catch (e, st) {
      debugPrint('Ошибка инициализации видео');
      debugPrint('Video url: ${widget.url}');
      debugPrint('Video error: $e');
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

  Future<void> _openFullscreen() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final wasPlaying = controller.value.isPlaying;
    final initialPosition = controller.value.position;

    await controller.pause();

    if (!mounted) return;

    final result = await Navigator.of(context).push<FullscreenVideoResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ExerciseFullscreenVideoPage(
          url: widget.url,
          initialPosition: initialPosition,
          autoPlay: wasPlaying,
        ),
      ),
    );

    if (!mounted) return;

    if (result == null) {
      if (wasPlaying) {
        await controller.play();
      }

      setState(() {});
      return;
    }

    await controller.seekTo(result.position);

    if (result.isPlaying) {
      await controller.play();
    } else {
      await controller.pause();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = _controller;

    if (_isInitializing) {
      return Container(
        color: colors.surface,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError || controller == null || !controller.value.isInitialized) {
      return Container(
        color: colors.surface,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam_off_outlined,
                size: 34,
                color: colors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                'Не удалось загрузить видео',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),

          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
            ),
          ),

          if (_showControls)
            Center(
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  return IconButton(
                    iconSize: 58,
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
            top: 8,
            right: 8,
            child: _VideoOverlayIconButton(
              icon: Icons.fullscreen,
              onPressed: _openFullscreen,
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              colors: VideoProgressColors(
                playedColor: appPrimaryBlue,
                bufferedColor: Colors.white.withOpacity(0.35),
                backgroundColor: Colors.white.withOpacity(0.18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoOverlayIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _VideoOverlayIconButton({
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