import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            AppTextField(
              hintText: 'Поиск врача',
              controller: _search,
              prefixIcon: SvgPicture.asset(AppAssets.searchIcon, fit: BoxFit.scaleDown),
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
                    tileColor: const Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(d.fullName, style: TextStyle(fontSize: 18)),
                    subtitle: Text(d.email, style: TextStyle(fontSize: 16)),
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