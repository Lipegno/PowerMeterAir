/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.sql.Timestamp;
import javax.sound.sampled.AudioFormat;

/**
 *
 * @author lucaspereira
 */
public class SystemConfig {

    /*
     * This is the timestamp for the initial start of the capture
     */

    //public static Timestamp startTime;
    
    public static long startTime;

    /*
     * This can change, in my Mac the line in ID is 1. in Adrian's MacBook Pro is 2
     */
    public static int deviceID = 1;


    /*
     * Set this to TRUE if you are NOT using the transformer to read tension
     */
    public static boolean useContantTension = true;

    
    /*
     * Set this to a value that is multiple of SampleRate / Signal Frequency
     * e.g. for a sample rate of 44100 samples per second, on a signal frequency of 50 hz, this value
     * must be multiple of 50! ZERO is NOT allowed
     */
    public static int averagePoints = 5;

    public static boolean isUS = false;

    /*
     * This values are used to calibrate the Current and Tension that are read by the sound card
     * If using constant Tension vCC is not used!
     */
    public static double iCC = 26.315;
    public static double vCC = 376;

    /*
     * These values are used in the event detection! Changing them may change the results of the event detection
     */
    public static int preEventWindowSize = 6;
    public static int detectionWindowSize = 10;


    /*
     * These values are used to set the vertical scale in the Power Chart
     */
    public static double minPowerRange = 0;
    public static double maxPowerRange = 300;

    public static AudioFormat GetAudioFormat() {
        float sampleRate = 44100.0F;
        //8000,11025,16000,22050,44100
        int sampleSizeInBits = 16;
        //8,16
        int channels = 2;
        //1,2
        boolean signed = true;
        //true,false
        boolean bigEndian = true;
        //true,false
        return new AudioFormat(sampleRate, sampleSizeInBits, channels,
                          signed, bigEndian);
    }

    public static int GetFramesPerPeriod(int frequency) {
        return (int)GetAudioFormat().getSampleRate() / frequency;
    }
}
