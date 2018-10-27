import java.util.*;

public class PointSorter {

    public void sortX(ArrayList<Point> points) {
        Collections.sort(points, new SortAscendingXComparator());
    }

    public void sortY(ArrayList<Point> points) {
        Collections.sort(points, new SortAscendingYComparator());
    }

    public class SortAscendingXComparator implements Comparator<Point> {
        public int compare(Point p1, Point p2) {
            if(p1.x > p2.x) {
                return 1;
            } else if(p1.x < p2.x) {
                return -1;
            } else {
                if(p1.y > p2.y) {
                    return 1;
                } else if(p1.y < p2.y) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }
    }    

    public class SortAscendingYComparator implements Comparator<Point> {
        public int compare(Point p1, Point p2) {
            if(p1.y > p2.y) {
                return 1;
            } else if(p1.y < p2.y) {
                return -1;
            } else {
                if(p1.x > p2.x) {
                    return 1;
                } else if(p1.x < p2.x) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }
    }    
    
}