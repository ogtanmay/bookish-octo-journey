class AIPlannerService {
  String dailyInsight(int focusScore) {
    if (focusScore > 90) {
      return 'AI Insight: Maintain your current deep work cycles and schedule a boss challenge today.';
    }
    if (focusScore > 75) {
      return 'AI Insight: Add one extra pomodoro block to push into the next rank tier.';
    }
    return 'AI Insight: Recover with backlog planner, hydration break, and lighter adaptive tasks.';
  }
}
