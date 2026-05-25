import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_route_names.dart';
import 'package:med_reability/utils/widgets/app_breadcrumbs.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';

const double rehabilitationPlanDesktopBreakpoint = 900;

bool isRehabilitationPlanDesktopLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= rehabilitationPlanDesktopBreakpoint;
}

List<AppBreadcrumbItem> rehabilitationPlanBreadcrumbs(
    BuildContext context,
    List<String> labels,
    ) {
  return [
    AppBreadcrumbItem(
      label: 'Пациенты',
      onTap: () {
        context.goNamed(AppRouteNames.doctorPatients);
      },
    ),
    ...labels.map(
          (label) => AppBreadcrumbItem(label: label),
    ),
  ];
}

void defaultRehabilitationPlanBack(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
    return;
  }

  if (context.canPop()) {
    context.pop();
    return;
  }

  context.goNamed(AppRouteNames.doctorPatients);
}

class RehabilitationPlanAdaptiveHeader extends StatelessWidget {
  final List<AppBreadcrumbItem> breadcrumbs;
  final VoidCallback? onBack;

  const RehabilitationPlanAdaptiveHeader({
    super.key,
    required this.breadcrumbs,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = isRehabilitationPlanDesktopLayout(context);

    if (isDesktop) {
      return AppBreadcrumbs(
        onBack: onBack ?? () => defaultRehabilitationPlanBack(context),
        items: breadcrumbs,
      );
    }

    return AppTopActionsBar(
      onBack: onBack ?? () => Navigator.pop(context),
    );
  }
}

class RehabilitationPlanPageLayout extends StatelessWidget {
  final List<AppBreadcrumbItem> breadcrumbs;
  final List<Widget> children;
  final VoidCallback? onBack;
  final EdgeInsets desktopPadding;
  final EdgeInsets mobilePadding;
  final double desktopHeaderSpacing;
  final double mobileHeaderSpacing;

  const RehabilitationPlanPageLayout({
    super.key,
    required this.breadcrumbs,
    required this.children,
    this.onBack,
    this.desktopPadding = const EdgeInsets.fromLTRB(28, 20, 28, 32),
    this.mobilePadding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
    this.desktopHeaderSpacing = 28,
    this.mobileHeaderSpacing = 18,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = isRehabilitationPlanDesktopLayout(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: isDesktop ? desktopPadding : mobilePadding,
          children: [
            RehabilitationPlanAdaptiveHeader(
              breadcrumbs: breadcrumbs,
              onBack: onBack,
            ),
            SizedBox(
              height: isDesktop ? desktopHeaderSpacing : mobileHeaderSpacing,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}