import de.bezier.guido.*;
private static final int NUM_ROWS=20;
private static final int NUM_COLS=20;
private static final int NUM_MINES=50;
private boolean gameOver = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines= new ArrayList <MSButton>();
private int buttonCount=0;
//ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //your code to initialize buttons goes her
      buttons = new MSButton[20][20];
  for (int NUM_ROWS = 0; NUM_ROWS < 20; NUM_ROWS++)
    for (int NUM_COLS = 0; NUM_COLS < 20; NUM_COLS++)
      buttons[NUM_ROWS][NUM_COLS] = new MSButton(NUM_ROWS, NUM_COLS);
    setMines();
}
public void setMines()
{
    while(mines.size()<NUM_MINES){
      int r = (int)(Math.random()*20);
      int c = (int)(Math.random()*20);
      if(mines.contains(buttons[r][c])==false){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
     for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (!mines.contains(button) && !button.isClicked()) {
                return false; // if any non-mine button is unclicked, the game is not won
            }
        }
    }
    return true; // if all non-mine buttons are clicked, the game is won
}
public void displayLosingMessage()
{
    //your code here
    buttons[0][4].setLabel("L");
  buttons[0][5].setLabel("O");
  buttons[0][6].setLabel("S");
  buttons[0][7].setLabel("E");
}
public void displayWinningMessage()
{
    //your code here
    buttons[0][4].setLabel("W");
  buttons[0][5].setLabel("I");
  buttons[0][6].setLabel("N");
}
public boolean isValid(int r, int c)
{
     if (r>=0 && r<10 && c>=0 && c<10)
      return true;
    else
      return false;

}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i =row-1; i<=row+1;i++){
    for (int j= col-1;j<=col+1;j++){
      if (!(i==row && j==col)){
        if (isValid(i,j)&& mines.contains(buttons[i][j])){
          numMines++;
        }
      }
    }
  }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
         if (!gameOver && !clicked) {

      clicked = true;
      if (!mines.contains(this)) { 
        buttonCount++;
      }
      if (mouseButton == RIGHT) {
        flagged=!flagged;
        clicked=false;
      } else if (mines.contains(this)) {
        for (MSButton mineButton : mines) {
          mineButton.clicked = true;
        }
        displayLosingMessage();
        gameOver=true;
      } else if (buttonCount==(NUM_ROWS*NUM_COLS)-NUM_MINES) {
        displayWinningMessage();
        gameOver=true;
      } else if (countMines(myRow, myCol)>0) {
        setLabel(str(countMines(myRow, myCol)));
      } else {
        if (isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked)
          buttons[myRow][myCol-1].mousePressed();
        if (isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked)
          buttons[myRow][myCol+1].mousePressed();
        if (isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked)
          buttons[myRow-1][myCol].mousePressed();
        if (isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked)
          buttons[myRow+1][myCol].mousePressed();
        if (isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].clicked)
          buttons[myRow+1][myCol-1].mousePressed();
        if (isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].clicked)
          buttons[myRow+1][myCol+1].mousePressed();
        if (isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].clicked)
          buttons[myRow-1][myCol+1].mousePressed();
        if (isValid(myRow-1, myCol-1) && !buttons[myRow-1][myCol-1].clicked)
          buttons[myRow-1][myCol-1].mousePressed();
      }
    }
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked() {
  return clicked;
}
}

