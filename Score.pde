class Score {
  int shipScore; 
  int highScore = 999;
  HighScoreHolder [] topScores;
  int lives;
  int level; 
  int topScoreIndicator;
  int maxTopScores = 10;
  int transportStart; 

  Score() {
    shipScore = 0;
    lives = 3;
    level = 1; 
    topScoreIndicator = -1;
    transportStart = 0;
    extractHighscore();
  }

  void displayTopHighscore( int baseHeight ) { 
    rectMode(CORNER);
    textAlign(CENTER); 
    textLeading(20); 
    textFont(Akashi24);
    noStroke();
    for ( int i = 0; i < topScores.length; i++){
      if( topScoreIndicator == i && int(transportTime()/500) % 2 == 0  ) fill(240, 207, 41);
      else if( topScoreIndicator == i ) fill(0);
      else fill(255);
      text( (i + 1) + "   " + topScores[i].name + ": ",  WIDTH_/4, baseHeight + (40 * i) - int(transportTime()/30) , WIDTH_/3, height);
      text( str(topScores[i].score) , WIDTH_/4 + 10, baseHeight + (40 * i) - int(transportTime()/30), 2*WIDTH_/3, height);
    }
    fill(0);
    rect(WIDTH_/2 - 130, baseHeight - 70, 240, 65);
    fill(0);
    rect(WIDTH_/2 - 130, baseHeight + 180, 240, 45);
  }

  void extractHighscore() {
    String currentHighScore[] = loadStrings("d.txt");
    highScore = 0;
    topScores = new HighScoreHolder[0];
    if(!(currentHighScore == null)){
      for ( int i = 0; i < currentHighScore.length; i++){
        String[] split = splitTokens(currentHighScore[i]);
        String name = (split.length > 1 ? trim(split[1]).replace("\n", "") : "");
        int score = int(split[0]);
        if ( i == 0 ) highScore = score;
        topScores = (HighScoreHolder [])append( topScores, new HighScoreHolder( name, score));
      }
    }
  }

  void saveHighScore() {
    extractHighscore();
    int yourScorePosition = 0; 
    for( int i = 0; i < topScores.length ; i++){
      if( shipScore <= topScores[i].score ) yourScorePosition++;
    }
    if(yourScorePosition < maxTopScores){
      topScoreIndicator = yourScorePosition;
      HighScoreHolder addition = new HighScoreHolder( gameControls.nameInput, shipScore);
      topScores = (HighScoreHolder [])splice(topScores, addition, yourScorePosition);
      if(yourScorePosition == 0) highScore = shipScore;
      topScores = (HighScoreHolder [])subset(topScores, 0, maxTopScores);
      exportTopScores();
    }
  }
  
  void exportTopScores(){
    String [] exportString = new String[0];
    for( int i = 0; i < topScores.length; i++){
      exportString = (String [])append( exportString, topScores[i].score + " " + topScores[i].name );
    }
    saveStrings("d.txt", exportString);
    extractHighscore();
  }

  boolean isFinalLevel() {  
    return level == 3;
  }

  void nextLevel() { 
    level += 1;
  }

  void normalKill() { 
    shipScore = shipScore + 40;
  }

  void display() {
    stroke(255);
    rectMode(CORNER);
    fill(255);
    textFont(Akashi24);
    text(shipScore, 100, 30);
    stroke(255, 100, 100);
    text("HI-SCORE", WIDTH_/2 - 50, 30);
    stroke(255);
    if (shipScore > highScore ) text(shipScore, WIDTH_/2 + 100, 30);
    else text(highScore, WIDTH_/2 + 100, 30);

    if (lives >= 1) livesIcon( new PVector(WIDTH_ -80, 20));
    if (lives >= 2) livesIcon( new PVector(WIDTH_ -100, 20));
    if (lives >= 3) livesIcon( new PVector(WIDTH_ -120, 20));
  }

  void livesIcon(PVector origin) {
    fill(255, 100, 100);
    stroke(255, 100, 100);
    ellipse(origin.x, origin.y, 6, 6);
    fill(255); 
    stroke(255);
    ellipse(origin.x, origin.y, 2, 2);
  }

  void setTransportStart() { 
    transportStart = millis();
  }
  void clearTransport() { 
    transportStart = 0;
  }
  int transportTime() { 
    return millis() - transportStart;
  } 
  boolean transportDone() { 
    return transportTime() > 10000;
  }// 10 sec 

  void deathHandler() {
    if (lives > 0) {
      lives--; 
      shipObj = new Ship(false);
      shipObj.slideIn();
    } else {
      gameControls.gameLoseName(); 
      loseScreenName();
    }
  }
}

