import '../../domain/entities/rehabilitation_program_template.dart';

class RehabilitationProgramTemplatesState {
  final String scopeId;
  final List<RehabilitationProgramWeekTemplate> weekTemplates;
  final List<RehabilitationProgramDayTemplate> dayTemplates;
  final String? errorMessage;

  const RehabilitationProgramTemplatesState({
    required this.scopeId,
    required this.weekTemplates,
    required this.dayTemplates,
    required this.errorMessage,
  });

  factory RehabilitationProgramTemplatesState.initial({
    required String scopeId,
  }) {
    return RehabilitationProgramTemplatesState(
      scopeId: scopeId,
      weekTemplates: const [],
      dayTemplates: const [],
      errorMessage: null,
    );
  }

  bool get hasWeekTemplates => weekTemplates.isNotEmpty;

  bool get hasDayTemplates => dayTemplates.isNotEmpty;

  RehabilitationProgramTemplatesState copyWith({
    String? scopeId,
    List<RehabilitationProgramWeekTemplate>? weekTemplates,
    List<RehabilitationProgramDayTemplate>? dayTemplates,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RehabilitationProgramTemplatesState(
      scopeId: scopeId ?? this.scopeId,
      weekTemplates: weekTemplates ?? this.weekTemplates,
      dayTemplates: dayTemplates ?? this.dayTemplates,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}