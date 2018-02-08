import processing.sound.*;
import java.util.Arrays;

String[] lines;
String path = "ideas.txt";
PrintWriter output;
int index = 0;
PImage img;
SoundFile file;
int time;

enum State{
  start,
  clicked,
  finish,
  flush,
  end
}
State state;

void setup()
{
  size(800,800);
  background(50);
  lines = loadStrings(path);
  output = createWriter(path);
  img = loadImage("magic.png");
  file = new SoundFile(this, "chest.mp3");
  frameRate(10);
  state = State.start; 
}

void draw()
{
  background(50);
  imageMode(CENTER);
  image(img,width/2,height/2);
  textAlign(CENTER);
  textSize(32);
  
 switch(state)
 {
  case start:
    fill(255, 0, 0);
    rectMode(CENTER);
    rect(width/2, height/2+300, 200, 55);
    fill(0);
    text("Start", width/2, height/2+310);
    break;
    
  case clicked:
    if(index == lines.length)
      index = 0;
      
    textSize(20);
    text(lines[index], width/2, height/2+125);
    
    if(millis()-time > 7525)
    {
      state = State.finish; 
    }
    index = (int)random(0,lines.length);
    if(index == lines.length)
      index = lines.length-1;
    break;
  
  case finish:
    textSize(20);
    text(lines[index], width/2, height/2+125);
    fill(255,0,0);
    rect(width/2, height/2+300, 200, 55);
    fill(0);
    textSize(32);
    text("finish!", width/2, height/2+310);
    break;
  
  case flush:
    output.flush();
    output.close();
    state = State.end;
    break;
  
  case end:
    break;
  
  default:
    break;
 }
}

void mouseClicked()
{
   switch(state)
   {
    case start:
      if((mouseX >= width/2 - 100) && (mouseX <= width/2 + 100) && (mouseY >= height/2+300 - 27) && (mouseY <= height/2+300 + 27))
      {
        file.play();
        println("Inside! " + mouseX + " " + mouseY);
        state = State.clicked;
        time = millis();
      }
      break;
      
    case finish:
      if((mouseX >= width/2 - 100) && (mouseX <= width/2 + 100) && (mouseY >= height/2+300 - 27) && (mouseY <= height/2+300 + 27))
      {
        ArrayList<String> list = new ArrayList<String>(Arrays.asList(lines));
        list.remove(lines[index]);
        lines = list.toArray(lines);
        
        for(int i = 0; i < lines.length; i++)
        {
          if(lines[i] != null)
           output.println(lines[i]); 
        }
        
        state = State.flush;
      }

    default:
      break;
   }
}