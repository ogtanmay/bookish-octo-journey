class GoalItem {
  const GoalItem({required this.title, required this.progress});

  final String title;
  final double progress;
}

class GrindState {
  const GrindState({
    required this.xp,
    required this.level,
    required this.streak,
    required this.focusMode,
    required this.rank,
    required this.focusScore,
    required this.achievements,
    required this.goals,
  });

  final int xp;
  final int level;
  final int streak;
  final bool focusMode;
  final String rank;
  final int focusScore;
  final List<String> achievements;
  final List<GoalItem> goals;

  double get xpProgress => (xp % 500) / 500;

  GrindState copyWith({
    int? xp,
    int? level,
    int? streak,
    bool? focusMode,
    String? rank,
    int? focusScore,
    List<String>? achievements,
    List<GoalItem>? goals,
  }) {
    return GrindState(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      focusMode: focusMode ?? this.focusMode,
      rank: rank ?? this.rank,
      focusScore: focusScore ?? this.focusScore,
      achievements: achievements ?? this.achievements,
      goals: goals ?? this.goals,
    );
  }

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'level': level,
        'streak': streak,
        'focusMode': focusMode,
        'rank': rank,
        'focusScore': focusScore,
      };

  factory GrindState.fromJson(Map<dynamic, dynamic> json) {
    return GrindState(
      xp: (json['xp'] as num?)?.toInt() ?? 1200,
      level: (json['level'] as num?)?.toInt() ?? 3,
      streak: (json['streak'] as num?)?.toInt() ?? 9,
      focusMode: json['focusMode'] as bool? ?? false,
      rank: json['rank'] as String? ?? 'Silver',
      focusScore: (json['focusScore'] as num?)?.toInt() ?? 88,
      achievements: const [
        'Backlog Killer',
        'Night Grinder',
        'Focus God',
        'Consistency Master',
        'No Distraction',
      ],
      goals: const [
        GoalItem(title: 'Daily Deep Work', progress: 0.72),
        GoalItem(title: 'Weekly Revision Sprint', progress: 0.58),
        GoalItem(title: 'Monthly JEE Target', progress: 0.41),
      ],
    );
  }

  static const fallback = GrindState(
    xp: 1200,
    level: 3,
    streak: 9,
    focusMode: false,
    rank: 'Silver',
    focusScore: 88,
    achievements: [
      'Backlog Killer',
      'Night Grinder',
      'Focus God',
      'Consistency Master',
      'No Distraction',
    ],
    goals: [
      GoalItem(title: 'Daily Deep Work', progress: 0.72),
      GoalItem(title: 'Weekly Revision Sprint', progress: 0.58),
      GoalItem(title: 'Monthly JEE Target', progress: 0.41),
    ],
  );
}
