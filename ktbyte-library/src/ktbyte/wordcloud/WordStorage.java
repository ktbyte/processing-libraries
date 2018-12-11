package ktbyte.wordcloud;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import processing.core.PApplet;

/**************************************************************************************************
 * A Frequency table class for Words.
 * This class is based on the WordFreq class from the book 'Processing 2'  by Ira Greenberg.
 * http://apress.com/9781430244646
 **************************************************************************************************/
public class WordStorage {
    ArrayList<Word> wordFrequencyTable;
    String[]        stopWords;
    PApplet         pa;
    int             maxFrequency = 1;

    // Constructor
    public WordStorage(PApplet pa) {
        this.pa = pa;
        wordFrequencyTable = new ArrayList<Word>();
        initStopWords("stopwords.txt");
    }

    public WordStorage(PApplet pa, String[] words) {
        this.pa = pa;
        wordFrequencyTable = new ArrayList<Word>();
        initStopWords("stopwords.txt");
        initStorage(words);
    }

    public void initStopWords(String fileName) {
        try {
            stopWords = pa.loadStrings(fileName);
        } catch (Exception e) {
            System.out.println("Cannot open file [" + fileName + "]");
        }
    }

    public void initStorage(String[] words) {
        //PApplet.println("Start importing words ....");
        // Compute the wordFrequency table using tokens
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            //System.out.printf("[%-5d]:", i);
            //System.out.printf("[%20s]%-5s", word, ",");
            if (!isStopWord(word)) {
                // See if token t is already a known word
                int index = search(word, wordFrequencyTable);
                if (index >= 0) {
                    Word aWord = wordFrequencyTable.get(index);
                    aWord.incrementFrequency();
                    if (aWord.getFrequency() > maxFrequency)
                        maxFrequency = aWord.getFrequency();
                    // PApplet.print(" " + aWord.getFrequency() + "th occurance ");
                } else {
                    wordFrequencyTable.add(new Word(word));
                    //PApplet.print(" first occurance ");
                }
                //PApplet.println(" found, adding.");
            } else {
                //PApplet.println(" is stop word ... skipping.");
            }
        }
        //PApplet.println("Stop importing words.");
    }

    public ArrayList<Word> getTable() {
        return wordFrequencyTable;
    }

    public void printTable() {
        PApplet.println("There are " + wordFrequencyTable.size() + " entries.");
        for (Word word : wordFrequencyTable) {
            PApplet.println(word);
        }
    }

    //    public String[] getSamples() {
    ////        String[] samples = new String[wordFrequencyTable.size()];
    ////        
    ////        for (int i = 0; i < wordFrequencyTable.size(); i++) {
    ////            Word word = wordFrequencyTable.get(i);
    ////            samples[i] = word.getText();
    ////            i++;
    ////        }
    //        return (String[]) wordFrequencyTable.toArray();
    //    }

//    public int[] counts() {
//        int[] arr = new int[wordFrequencyTable.size()];
//        for (int i = 0; i < arr.length; i++) {
//            Word word = wordFrequencyTable.get(i);
//            int freq = word.getFrequency();
//            arr[i++] = freq;
//        }
//        return arr;
//    }

    public int getMaxFrequency() {
        return maxFrequency;
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

    public void sortAscending() {
        Collections.sort(wordFrequencyTable, new Comparator<Word>() {
            @Override
            public int compare(Word w1, Word w2) {
                return w1.compareTo(w2);
            }
        });
    }
    
    public void sortDescending() {
        Collections.sort(wordFrequencyTable, new Comparator<Word>() {
            @Override
            public int compare(Word w1, Word w2) {
                return w2.compareTo(w1);
            }
        });
    }

    public String toString() {
        return "Word Frequency Table with" + wordFrequencyTable.size() + " entries.";
    }
}
