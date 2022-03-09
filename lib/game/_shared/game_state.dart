enum GameState {
  gettingReady,
  ready,
  inProgress,
  paused,
  completed,
}

extension GameStateExtension on GameState {
  bool get inProgress => this == GameState.inProgress;
  bool get isCompleted => this == GameState.completed;
  bool get paused => this == GameState.paused;
  bool get canInteract => this != GameState.gettingReady;
}
