class Label {
  String txt;
  color c1;
  int xpos, ypos;
  
  String font;
  
  boolean display = true;
  

  Label(int _x, int _y) {
    xpos = _x;
    ypos = _y;

    //defaults
    txt = "";
    c1 = color(255, 255, 255);
    font = "Helvetica-25.vlw";
    
  }
  
  void display() {
     if (display) {
       fill(c1);
       text(txt, xpos, ypos); 
     }
  }
  
  void setText(String _text) {
    txt = _text; 
  }
  
  void setDisplay(boolean state) {
    display = state; 
  }
}

