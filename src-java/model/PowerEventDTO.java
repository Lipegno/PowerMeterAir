/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

/**
 *
 * @author lucaspereira
 */
public class PowerEventDTO {
    
    /* Instance Variables */

    int _id;
    String _eventType;
    String _userID;
    String _userIP;
    String _eventID;
    String _eventSource;
    PowerSampleDTO _priorPower;
    PowerSampleDTO[] _powerSamples;

    public int GetID() {
        return _id;
    }

    public String GetEventType() {
        return _eventType;
    }

    public String GetUserID() {
        return _userID;
    }

    public String GetUserIP() {
        return _userIP;
    }

    public String GetEventID() {
        return _eventID;
    }

    public String GetEventSource() {
        return _eventSource;
    }


    public int GetSampleSize() {
        return _powerSamples.length;
    }

    public PowerSampleDTO[] GetPowerSamples() {
        return _powerSamples;
    }

    public PowerSampleDTO GetPriorPower() {
        return _priorPower;
    }

    
}
