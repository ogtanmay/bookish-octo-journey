import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ai/ai_planner_service.dart';
import '../models/grind_state.dart';
import '../services/local_storage_service.dart';

final grindControllerProvider = NotifierProvider<GrindController, GrindState>(GrindController.new);

class GrindController extends Notifier<GrindState> {
  final _planner = AIPlannerService();

  String get aiInsight => _planner.dailyInsight(state.focusScore);

  @override
  GrindState build() {
    final saved = LocalStorageService.instance.loadState();
    return saved == null ? GrindState.fallback : GrindState.fromJson(saved);
  }

  Future<void> gainXp(int amount) async {
    final newXp = state.xp + amount;
    state = state.copyWith(xp: newXp, level: (newXp ~/ 500) + 1);
    await _persist();
  }

  Future<void> toggleFocus() async {
    state = state.copyWith(focusMode: !state.focusMode, focusScore: state.focusMode ? 84 : 92);
    await _persist();
    await LocalStorageService.instance.addAnalytics('focus_toggle', state.focusMode ? 1 : 0);
  }

  Future<void> extendStreak() async {
    state = state.copyWith(streak: state.streak + 1);
    await gainXp(40);
  }

  Future<void> _persist() async {
    await LocalStorageService.instance.saveState(state.toJson());
  }
}
