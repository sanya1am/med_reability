import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_card.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';
import '../view_model/doctor_patients_view_model.dart';


class DoctorPatientsPage extends ConsumerStatefulWidget {
  const DoctorPatientsPage({super.key});

  @override
  ConsumerState<DoctorPatientsPage> createState() => _DoctorPatientsPageState();
}

class _DoctorPatientsPageState extends ConsumerState<DoctorPatientsPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(doctorPatientsViewModelProvider);
    final colors = context.appColors;

    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Ошибка: $e',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      data: (s) {
        final allPatients = s.patients;

        if (allPatients.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(doctorPatientsViewModelProvider.notifier).refresh(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 40,
                              color: colors.textPrimary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'У вас пока нет пациентов',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        final q = _search.text.trim().toLowerCase();
        final filtered = q.isEmpty
            ? allPatients
            : allPatients.where((p) {
          final hay = ('${p.fullName} ${p.email}').toLowerCase();
          return hay.contains(q);
        }).toList();

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(doctorPatientsViewModelProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
            children: [
              AppTextField(
                hintText: 'Найти пациента',
                controller: _search,
                prefixIcon: Icon(
                  Icons.search,
                  color: colors.textPrimary,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),

              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 40,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'По вашему запросу ничего не найдено',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...filtered.map(
                      (p) => PatientCard(
                    name: p.fullName,
                    subtitle: p.phoneNumber,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}