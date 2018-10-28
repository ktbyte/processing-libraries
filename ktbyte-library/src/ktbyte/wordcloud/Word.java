package ktbyte.wordcloud;

/**************************************************************************************************
 *
 * This class is based on the Word class from the book 'Processing 2'  by Ira Greenberg
 * 
 **************************************************************************************************/
public class Word implements Comparable<Word> {
    String text;
    int frequency;
    
    // Constructor
    public Word (String text) {
        this.text = text;
        frequency = 1;
    }
    
    public String getText() {
        return text;
    }
    
    public int getFrequency() {
        return frequency;
    }
    
    public void incrementFrequency() {
        frequency++;
    }
    
    public int compareTo(Word word) {
        return frequency - word.getFrequency();
    }
    
    public String toString() {
        return "[" + text + ":" + frequency + "]";
    }
}
