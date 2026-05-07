import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rehabilitation_program_day.dart';
import '../../domain/entities/rehabilitation_program_template.dart';
import '../state/rehabilitation_program_templates_state.dart';

class RehabilitationProgramTemplatesViewModel
    extends AutoDisposeFamilyNotifier<RehabilitationProgramTemplatesState, String> {
  @override
  RehabilitationProgramTemplatesState build(String scopeId) {
    return RehabilitationProgramTemplatesState.initial(
      scopeId: scopeId,
    );
  }

  void saveWeekTemplate({
    required String name,
    required List<RehabilitationProgramDay> days,
  }) {
    final hasContent = days.any(_isDayFilled);

    if (!hasContent) {
      state = state.copyWith(
        errorMessage: 'Нельзя сохранить пустую неделю как шаблон',
      );
      return;
    }

    final template = RehabilitationProgramWeekTemplate(
      id: _makeLocalId(),
      name: _normalizeTemplateName(
        name: name,
        fallback: 'Шаблон недели ${state.weekTemplates.length + 1}',
      ),
      days: days,
    );

    state = state.copyWith(
      weekTemplates: [
        ...state.weekTemplates,
        template,
      ],
      clearErrorMessage: true,
    );
  }

  void saveDayTemplate({
    required String name,
    required RehabilitationProgramDay day,
  }) {
    if (!_isDayFilled(day)) {
      state = state.copyWith(
        errorMessage: 'Нельзя сохранить пустой день как шаблон',
      );
      return;
    }

    final template = RehabilitationProgramDayTemplate(
      id: _makeLocalId(),
      name: _normalizeTemplateName(
        name: name,
        fallback: 'Шаблон дня ${state.dayTemplates.length + 1}',
      ),
      day: day,
    );

    state = state.copyWith(
      dayTemplates: [
        ...state.dayTemplates,
        template,
      ],
      clearErrorMessage: true,
    );
  }

  void deleteWeekTemplate(String templateId) {
    state = state.copyWith(
      weekTemplates: state.weekTemplates
          .where((template) => template.id != templateId)
          .toList(),
      clearErrorMessage: true,
    );
  }

  void deleteDayTemplate(String templateId) {
    state = state.copyWith(
      dayTemplates: state.dayTemplates
          .where((template) => template.id != templateId)
          .toList(),
      clearErrorMessage: true,
    );
  }

  void clearError() {
    state = state.copyWith(
      clearErrorMessage: true,
    );
  }

  bool _isDayFilled(RehabilitationProgramDay day) {
    final hasNotes = day.notes != null && day.notes!.trim().isNotEmpty;

    return day.isRestDay || day.exercises.isNotEmpty || hasNotes;
  }

  String _normalizeTemplateName({
    required String name,
    required String fallback,
  }) {
    final normalized = name.trim();

    if (normalized.isEmpty) {
      return fallback;
    }

    return normalized;
  }

  String _makeLocalId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

final rehabilitationProgramTemplatesViewModelProvider =
NotifierProvider.autoDispose.family<
    RehabilitationProgramTemplatesViewModel,
    RehabilitationProgramTemplatesState,
    String>(
  RehabilitationProgramTemplatesViewModel.new,
);