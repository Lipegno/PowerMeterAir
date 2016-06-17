/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.sql.Timestamp;

/**
 *
 * @author lucaspereira
 */
public class PowerSampleDTO {

    /* Instance Variables */
    double iRMS;
    double vRMS;
    double power;
    double powerAngle = 0;
    int sampleIndex;
    Timestamp timeStamp;
    boolean useConstantTension = false;


    public PowerSampleDTO(double _iRMS, double _vRMS, double _powerAngle, int _sampleIndex) {
        iRMS = _iRMS;
        vRMS = _vRMS;
        powerAngle = _powerAngle;
        sampleIndex = _sampleIndex;
        timeStamp = new Timestamp(SystemConfig.startTime + (_sampleIndex * 20));
    }

    public PowerSampleDTO(double _power, Timestamp _timestamp) {
        power = _power;
        timeStamp = _timestamp;
    }
    
    public PowerSampleDTO(double _iRMS, double _vRMS, double _powerAngle, int _sampleIndex, Timestamp _timestamp) {
        iRMS = _iRMS;
        vRMS = _vRMS;
        powerAngle = _powerAngle;
        sampleIndex = _sampleIndex;
        timeStamp = _timestamp;
    }
    
    public PowerSampleDTO(double _iRMS, double _vRMS, int _sampleIndex) {
        iRMS = _iRMS;
        vRMS = _vRMS;
        useConstantTension = true;
        sampleIndex = _sampleIndex;
        timeStamp = new Timestamp(SystemConfig.startTime + (_sampleIndex * 20));
    }

    public PowerSampleDTO(double _iRMS, double _vRMS, int _sampleIndex, Timestamp _timestamp) {
        iRMS = _iRMS;
        vRMS = _vRMS;
        useConstantTension = true;
        sampleIndex = _sampleIndex;
        timeStamp = _timestamp;
    }

    public boolean UseConstantVoltage() {
        return useConstantTension;
    }

    public double getRealPower() {
      //  double realPower = 0;

        return this.power;
    }

    public double getReactivePower() {
        double reactivePower = 0;
        if(!useConstantTension)
            reactivePower = Math.abs(iRMS * vRMS * Math.sin(powerAngle));
        else
            reactivePower = Math.abs(iRMS * vRMS * 0.34);
        
        return reactivePower;
    }

    public int GetSampleIndex() {
        return sampleIndex;
    }

    public Timestamp GetTimeStamp() {
        return timeStamp;
    }

    public double GetPowerAngle() {
        return powerAngle;
        }

    public double GetIRMS() {
        return iRMS;
    }

    public double GetVRMS() {
        return vRMS;
    }

    public double GetRealPowerB() {
        return 0;
    }

    public double GetReactivePowerB() {
        return 0;
    }




}
