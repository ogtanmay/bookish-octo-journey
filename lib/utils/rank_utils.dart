const focusRanks = ['Bronze', 'Silver', 'Gold', 'Diamond', 'Mythic'];

String rankForLevel(int level) {
  if (level < 3) return focusRanks[0];
  if (level < 6) return focusRanks[1];
  if (level < 10) return focusRanks[2];
  if (level < 15) return focusRanks[3];
  return focusRanks[4];
}
