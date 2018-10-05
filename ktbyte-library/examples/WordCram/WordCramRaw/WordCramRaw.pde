ArrayList<Point> al;

void setup() {
    size(400, 400);
    noLoop();
    
    al = new ArrayList<Point>();
    al.add(new Point(0, 0));
    al.add(new Point(10, 10));
    al.add(new Point(-10, -10));
    
    println(al);
    
    PointSorter ps = new PointSorter();
    ps.sortX(al);

    println(al);
}