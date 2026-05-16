import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

import '../animations/dynamic_island_alert.dart';
import '../focus_mode/focus_mode_widgets.dart';
import '../gamification/grind_controller.dart';
import '../models/grind_state.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  String? _alert;
  late final Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _showAlert(String text) {
    setState(() => _alert = text);
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _alert = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(grindControllerProvider);
    final controller = ref.read(grindControllerProvider.notifier);

    final pages = [
      _homePanel(state, controller),
      _widgetsPanel(state),
      _missionsPanel(state),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.4,
            colors: [Color(0xFF141720), Color(0xFF050506)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Center(child: DynamicIslandAlert(message: _alert)),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: KeyedSubtree(key: ValueKey(_page), child: pages[_page]),
                    ),
                  ),
                  _floatingDock(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homePanel(GrindState state, GrindController controller) {
    final time = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GrindOS // Device Transformation Mode', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Text(time, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text('AI Planner: ${controller.aiInsight}'),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: state.xpProgress,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  color: const Color(0xFFAFC8FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                const SizedBox(height: 8),
                Text('XP ${state.xp} • Level ${state.level} • ${state.rank} Rank'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FocusStateBanner(enabled: state.focusMode),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 168,
                child: DashboardWidget(title: 'Streak Flame', value: '${state.streak} days', subtitle: 'Combo x${(1 + state.streak / 20).toStringAsFixed(1)}'),
              ),
              SizedBox(
                width: 168,
                child: DashboardWidget(title: 'AI Focus Score', value: '${state.focusScore}', subtitle: 'Burnout-safe zone'),
              ),
              const SizedBox(
                width: 168,
                child: DashboardWidget(title: 'JEE Countdown', value: '196 days', subtitle: 'Rank projection active'),
              ),
              const SizedBox(
                width: 168,
                child: DashboardWidget(title: 'Music', value: 'Ambient Flow', subtitle: 'NothingOS calm preset'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: () async {
                        await controller.gainXp(30);
                        _showAlert('+30 XP • Daily mission progress');
                      },
                      child: const Text('+XP'),
                    ),
                    FilledButton.tonal(
                      onPressed: () async {
                        await controller.extendStreak();
                        _showAlert('Streak recovered with flame bonus');
                      },
                      child: const Text('Recover Streak'),
                    ),
                    FilledButton.tonal(
                      onPressed: () async {
                        await controller.toggleFocus();
                        final focusOn = ref.read(grindControllerProvider).focusMode;
                        _showAlert(focusOn ? 'Focus mode enabled' : 'Focus mode disabled');
                      },
                      child: Text(state.focusMode ? 'Disable Focus' : 'Enable Focus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Animation Layer (Lottie + Rive fallback)', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 72,
                  child: Row(
                    children: [
                      Expanded(
                        child: Lottie.network(
                          'https://assets10.lottiefiles.com/packages/lf20_ktwnwv5m.json',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RiveAnimation.network(
                          'https://public.rive.app/community/runtime-files/2195-4346-avatar-pack-use-case.riv',
                          fit: BoxFit.contain,
                          placeHolder: Center(child: Icon(Icons.motion_photos_on, color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetsPanel(GrindState state) {
    final widgets = [
      ('Large Clock', 'Dynamic system clock'),
      ('XP Widget', '${state.xp} XP'),
      ('Current Level', 'Level ${state.level}'),
      ('Focus Timer', '25:00 Pomodoro'),
      ('Goal Tracker', '3 active goals'),
      ('Study Hours Graph', '6.8h today'),
      ('Productivity Heatmap', 'Strong consistency'),
      ('Water Tracker', '2.1L'),
      ('Sleep Tracker', '7h 24m'),
      ('AI Focus Score', '${state.focusScore}'),
      ('Motivation Quote', 'Discipline compounds.'),
      ('Daily Mission', '2/5 complete'),
      ('Habit Tracker', '11 habits active'),
      ('Rank Prediction', 'AIR ~3.4k projection'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: widgets.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
        ),
        itemBuilder: (_, index) => DashboardWidget(
          title: widgets[index].$1,
          value: widgets[index].$2,
          subtitle: 'Movable interactive widget',
        ),
      ),
    );
  }

  Widget _missionsPanel(GrindState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Achievements', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...state.achievements.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $e'),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Goals & Targets', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...state.goals.map((goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(goal.title),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: goal.progress,
                            borderRadius: BorderRadius.circular(999),
                            backgroundColor: Colors.white.withOpacity(0.08),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('RPG System', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Skill Tree • Daily Quests • Weekly Boss Challenge • Unlockable Themes'),
                SizedBox(height: 6),
                Text('Focus Ranks: Bronze → Silver → Gold → Diamond → Mythic'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingDock() {
    final labels = ['Home', 'Widgets', 'Missions'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(labels.length, (index) {
            final selected = _page == index;
            return GestureDetector(
              onTap: () => setState(() => _page = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.14) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(labels[index]),
              ),
            );
          }),
        ),
      ),
    );
  }
}
