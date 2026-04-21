import 'package:flutter/material.dart';
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.mediaUrls.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 32,
            color: colors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaUrls.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final url = widget.mediaUrls[index];

                return Container(
                  color: colors.surface,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 32,
                          color: colors.textSecondary,
                        ),
                      );
                    },
                  ),
                );
              },
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
                      : colors.textSecondary.withOpacity(0.4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}