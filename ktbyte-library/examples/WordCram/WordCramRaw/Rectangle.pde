public class Rectangle {
    public int h, w, id;
    public Point bottomLeft, bottomRight, topLeft, topRight;
    
    public Rectangle(int h, int w){
        this.h = h;
        this.w = w;
    }

    public Rectangle(Point bottomLeft, int h, int width){
        this.h = h;
        this.w = w;
        setBottomLeft(bottomLeft);
    }

    public void setTopLeft(Point topLeft){
        this.topLeft = topLeft;
        this.topRight = new Point(topLeft.x + w, topLeft.y);
        this.bottomLeft = new Point(topLeft.x, topLeft.y + h);
        this.bottomRight = new Point(topLeft.x + w, topLeft.y + h);
    }

    public void setTopRight(Point topRight){
        this.topRight = topRight;
        this.topLeft=new Point(this.topRight.x-h,this.topRight.y);
        this.bottomLeft=new Point(this.topLeft.x,this.topLeft.y+w);
        this.bottomRight=new Point(this.bottomLeft.x+w,this.bottomLeft.y);
    }

    public void setBottomLeft(Point bottomLeft){
        this.bottomLeft=bottomLeft;
        this.bottomRight=new Point(this.bottomLeft.x+h,this.bottomLeft.y);
        this.topLeft=new Point(this.bottomLeft.x,this.bottomLeft.y-w);
        this.topRight=new Point(this.topLeft.x+h,this.topLeft.y);
    }

    public void setBottomRight(Point bottomRight){
        this.bottomRight = bottomRight;
        this.bottomLeft = new Point(this.bottomRight.x - h, this.bottomRight.y);
        this.topLeft = new Point(this.bottomLeft.x, this.bottomLeft.y - w);
        this.topRight = new Point(this.topLeft.x + h, this.topLeft.y);
    }
    public void reset(){
        this.topLeft = new Point(0,0);
        this.topRight = new Point(0,0);
        this.bottomLeft = new Point(0,0);
        this.bottomRight = new Point(0,0);
    }
    public void rotate(){
        int temp=this.h;
        this.h=this.w;
        this.w=temp;
    }

    public boolean intersects(Rectangle r){
      return !(r.bottomLeft.x > bottomRight.x || 
               r.bottomRight.x < bottomLeft.x || 
               r.topLeft.y > bottomLeft.y ||
               r.bottomLeft.y < topLeft.y);
    }

    public boolean intersects(ArrayList<Rectangle> rect){
        boolean intersects = false;
        for(Rectangle r : rect) {
            if(intersects(r)) {
                intersects = true;
                break;
            }
        }
        return intersects;
    }

    public String toString(){
        return "("+id+" L="+h+", W="+this.w+", TL="+topLeft+",TR="+topRight+",BL="+bottomLeft+",BR="+bottomRight+")";
    }

}
