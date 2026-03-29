import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (s) {
        final q = _search.text.trim().toLowerCase();
        final list = q.isEmpty
            ? s.patients
            : s.patients.where((p) {
          final hay = ('${p.fullName} ${p.email}').toLowerCase();
          return hay.contains(q);
        }).toList();

        return RefreshIndicator(
          onRefresh: () => ref.read(doctorPatientsViewModelProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              AppTextField(
                hintText: 'Найти пациента',
                controller: _search,
                prefixIcon: const Icon(Icons.search),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              ...list.map((p) => _PatientCard(
                name: p.fullName,
                subtitle: p.phoneNumber,
              )),
            ],
          ),
        );
      },
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final String subtitle;

  const _PatientCard({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFEFEFEF),
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}