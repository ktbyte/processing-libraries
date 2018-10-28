package ktbyte.wordcram;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import processing.core.PApplet;

/**************************************************************************************************
 *
 * This class is based on the WordFreq class from the book 'Processing 2'  by Ira Greenberg.
 * A Frequency table class for Words.
 **************************************************************************************************/
public class WordFrequency {
    ArrayList<Word> wordFrequency;
    String[]        stopWords;
    PApplet         pa;

    public WordFrequency(PApplet pa, String[] words) { // Constructor
        this.pa = pa;

        stopWords = pa.loadStrings("stopwords.txt");
        wordFrequency = new ArrayList<Word>();

        PApplet.println("Start importing words ....");
        // Compute the wordFrequency table using tokens
        for (String word : words) {
            PApplet.print(word + ", ");
            if (!isStopWord(word)) {
                // See if token t is already a known word
                int index = search(word, wordFrequency);
                if (index >= 0) {
                    Word aWord = wordFrequency.get(index);
                    aWord.incrementFrequency();
                    PApplet.print(", " + aWord.getFrequency() + "th occurance ");
                } else {
                    wordFrequency.add(new Word(word));
                    PApplet.print(", first occurance ");
                }
                PApplet.println(" found, adding.");
            }
            PApplet.println(" is stop word ... skipping.");
        }
        PApplet.println("Stop importing words.");
    }

    public void tabulate() {
        PApplet.println("There are " + wordFrequency.size() + " entries.");
        for (Word word : wordFrequency) {
            PApplet.println(word);
        }
    }

    public String[] samples() {
        String[] k = new String[wordFrequency.size()];
        int i = 0;
        for (Word word : wordFrequency) {
            k[i] = word.getText();
            i++;
        }
        return k;
    }

    public int[] counts() {
        PApplet.println("------------------------------------------------------------");
        PApplet.println(wordFrequency.contains(new Word("war")));
        PApplet.println("------------------------------------------------------------");
        int[] arr = new int[wordFrequency.size()];
        PApplet.println("------------------------------------------------------------");
        for (int i = 0; i < arr.length; i++) {
            Word word = wordFrequency.get(i);
            int freq = word.getFrequency();
            arr[i++] = freq;
            System.out.printf("%-20s:%4d\n", word, freq);
        }
        return arr;
    }

    public int maxFrequency() {
        return PApplet.max(counts());
    }

    // search for word in wordList.
    public int search(String word, ArrayList<Word> wordList) {
        // Returns index of w in L if found, -1 o/w
        for (int i = 0; i < wordList.size(); i++) {
            if (wordList.get(i).getText().equals(word)) {
                return i;
            }
        }
        return -1;
    }

    // check if the particular word contained in list of stop words
    public boolean isStopWord(String word) {
        for (String stopWord : stopWords) {
            if (word.equals(stopWord)) {
                return true;
            }
        }
        return false;
    }

    public void sort() {
        Collections.sort(wordFrequency, new Comparator<Word>() {
            @Override
            public int compare(Word w1, Word w2) {
                return w1.compareTo(w2);
            }
        });
    }

    public String toString() {
        return "Word Frequency Table with" + wordFrequency.size() + " entries.";
    }
}
