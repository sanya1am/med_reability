import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:med_reability/core/services/media_url_helper.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_video_player.dart';
import 'package:med_reability/utils/theme/app_theme.dart';


class ExerciseMediaSlider extends StatefulWidget {
  final List<String> mediaUrls;

  const ExerciseMediaSlider({
    super.key,
    required this.mediaUrls,
  });

  @override
  State<ExerciseMediaSlider> createState() => _ExerciseMediaSliderState();
}

class _ExerciseMediaSliderState extends State<ExerciseMediaSlider> {
  late final PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (currentIndex >= widget.mediaUrls.length) {
      currentIndex = 0;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideoUrl(String url) {
    final uri = Uri.tryParse(url);
    final path = (uri?.path ?? url).toLowerCase();

    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.m4v') ||
        path.endsWith('.webm') ||
        path.endsWith('.avi');
  }

  void _openPrevious() {
    if (widget.mediaUrls.length <= 1) return;

    final lastIndex = widget.mediaUrls.length - 1;
    final targetIndex = currentIndex == 0 ? lastIndex : currentIndex - 1;

    _pageController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _openNext() {
    if (widget.mediaUrls.length <= 1) return;

    final lastIndex = widget.mediaUrls.length - 1;
    final targetIndex = currentIndex == lastIndex ? 0 : currentIndex + 1;

    _pageController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.mediaUrls.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 34,
              color: colors.textSecondary.withOpacity(0.35),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ScrollConfiguration(
                    behavior: const _MediaSliderScrollBehavior(),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.mediaUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final rawUrl = widget.mediaUrls[index];
                        final url = normalizeMediaUrl(rawUrl);

                        if (_isVideoUrl(url)) {
                          return ExerciseVideoPlayer(
                            url: url,
                            isActive: index == currentIndex,
                          );
                        }

                        return _ExerciseImagePreview(url: url);
                      },
                    ),
                  ),
                ),

                if (widget.mediaUrls.length > 1) ...[
                  Positioned(
                    left: 14,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _MediaSliderArrowButton(
                        icon: Icons.chevron_left,
                        onPressed: _openPrevious,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _MediaSliderArrowButton(
                        icon: Icons.chevron_right,
                        onPressed: _openNext,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        if (widget.mediaUrls.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.mediaUrls.length, (index) {
              final active = index == currentIndex;

              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? appPrimaryBlue
                      : colors.textSecondary.withOpacity(0.35),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _ExerciseImagePreview extends StatelessWidget {
  final String url;

  const _ExerciseImagePreview({
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colors.surface,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Center(
            child: Icon(
              Icons.image_outlined,
              size: 34,
              color: colors.textSecondary.withOpacity(0.35),
            ),
          );
        },
      ),
    );
  }
}

class _MediaSliderArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MediaSliderArrowButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surface.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Icon(
            icon,
            size: 18,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MediaSliderScrollBehavior extends MaterialScrollBehavior {
  const _MediaSliderScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}