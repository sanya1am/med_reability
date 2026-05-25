import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/assets/app_assets.dart';
import '../../domain/entities/clinic.dart';
import '../view_model/auth_view_model.dart';

class ClinicPickerSheet extends ConsumerStatefulWidget {
  const ClinicPickerSheet({super.key});

  @override
  ConsumerState<ClinicPickerSheet> createState() => _ClinicPickerSheetState();
}

class _ClinicPickerSheetState extends ConsumerState<ClinicPickerSheet> {
  final _searchCtrl = TextEditingController();

  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<Clinic> _items = const [];

  @override
  void initState() {
    super.initState();
    _load('');
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _load(_searchCtrl.text);
    });
  }

  Future<void> _load(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final vm = ref.read(authViewModelProvider.notifier);
      final res = await vm.searchClinics(q);

      if (!mounted) return;
      setState(() {
        _items = res;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Не удалось загрузить список клиник';
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchCtrl,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                labelText: 'Поиск клиники',
                labelStyle: Theme.of(context).textTheme.headlineSmall,
                prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: SvgPicture.asset(AppAssets.searchIcon, fit: BoxFit.scaleDown),
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final c = _items[i];
                    return ListTile(
                      title: Text(c.name, style: Theme.of(context).textTheme.headlineSmall),
                      onTap: () => Navigator.of(context).pop<Clinic>(c),
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