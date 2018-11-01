class BoundBox {
 float xpos = new Float(width/3);
 float ypos = new Float(height/2);
 float radius = new Float( .75*height);
 float opacity = new Float (10);
 PVector bbCenter = new PVector(xpos, ypos);

  
  void display(){
    fill(255, opacity);
    ellipse(xpos,ypos,radius,radius);
  
  }
  
  void initiate(){
   fill(255,255);
   ellipse(xpos,ypos,radius,radius);
    
  }
  
  
  
}
