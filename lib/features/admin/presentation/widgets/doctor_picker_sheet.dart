import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';

class DoctorPickerSheet extends ConsumerStatefulWidget {
  const DoctorPickerSheet({super.key});

  @override
  ConsumerState<DoctorPickerSheet> createState() => _DoctorPickerSheetState();
}

class _DoctorPickerSheetState extends ConsumerState<DoctorPickerSheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersViewModelProvider).valueOrNull;
    final doctors = data?.doctors ?? const [];
    final colors = context.appColors;

    final q = _search.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? doctors
        : doctors.where((d) {
      final s = '${d.fullName} ${d.email}'.toLowerCase();
      return s.contains(q);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hintText: 'Поиск инструктора',
              controller: _search,
              prefixIcon: SvgPicture.asset(
                AppAssets.searchIcon,
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                  colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final d = filtered[i];
                  return ListTile(
                    tileColor: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      d.fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      d.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: colors.textSecondary,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, d),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}