/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

/**
 *
 * @author lucaspereira
 */
public class StereoSamplesDTO {

    double[] leftSamples; // leftSamples will hold the Current values
    double[] rightSamples; // rightSamples will hold the Tension values

    public StereoSamplesDTO(double [] _i, double[] _v) {
        leftSamples = _i;
        rightSamples = _v;
    }
    
    public double[] GetLeftSamples() {
        return leftSamples;
    }
    
    public double[] GetRightSamples() {
        return rightSamples;
    }

    public int GetSize() {
        if(leftSamples.length == rightSamples.length)
            return leftSamples.length;
        else
            return 0;
    }
}
