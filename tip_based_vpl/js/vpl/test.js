var executeEnemyProgram, executePlayerProgram, getEnemyProgram, getPlayerProgram, loadEnemyProgram, loadPlayerProgram, saveEnemyProgram, savePlayerProgram, showEnemyProgram, showPlayerProgram, test;

getPlayerProgram = function() {
  return Game.instance.octagrams.getInstance(Game.instance.currentScene.world.playerProgramId);
};

getEnemyProgram = function() {
  return Game.instance.octagrams.getInstance(Game.instance.currentScene.world.enemyProgramId);
};

executePlayerProgram = function() {
  return getPlayerProgram().execute();
};

executeEnemyProgram = function() {
  return getEnemyProgram().execute();
};

savePlayerProgram = function() {
  return getPlayerProgram().save("player");
};

saveEnemyProgram = function() {
  return getEnemyProgram().save("enemy");
};

loadPlayerProgram = function() {
  return getPlayerProgram().load("player");
};

loadEnemyProgram = function() {
  return getEnemyProgram().load("enemy");
};

showPlayerProgram = function() {
  return Game.instance.octagrams.show(Game.instance.currentScene.world.playerProgramId);
};

showEnemyProgram = function() {
  return Game.instance.octagrams.show(Game.instance.currentScene.world.enemyProgramId);
};

test = function() {
  var enemyProgram, playerProgram;
  playerProgram = Game.instance.currentScene.world.playerProgram;
  enemyProgram = Game.instance.currentScene.world.enemyProgram;
  playerProgram.load("test");
  enemyProgram.load("test");
  playerProgram.execute();
  return enemyProgram.execute();
};
