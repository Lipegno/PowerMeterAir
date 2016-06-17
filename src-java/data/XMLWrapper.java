/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package data;

import java.io.IOException;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import model.PowerEventDTO;
import model.PowerSampleDTO;
/**
 *
 * @author lucaspereira
 */

public class XMLWrapper {
    
    private Document _doc = null;
    private boolean _templateLoaded = false;

    public XMLWrapper(String templatePath) {
        if((_doc = LoadTemplate(templatePath)) != null) {

        }

    }

    private Document LoadTemplate(String templatePath) {
        Document d = null;
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setIgnoringElementContentWhitespace(true);
            factory.setCoalescing(true);
            DocumentBuilder parser = factory.newDocumentBuilder();
            try {
                d = parser.parse(templatePath);
                _templateLoaded = true;
            }
            catch(SAXException e) {
               System.err.println(e);
            }
        }
        catch(IOException e) {
            System.err.println(e);
        }
        catch (ParserConfigurationException e) {
          System.err.println(
           "No parser suporting JAXP could be found in the local class path.");
        }
        return d;
    }

    public boolean UpdateXML(PowerEventDTO powerEvent) {
        boolean updated = false;

        if(_templateLoaded) {

            NodeList styleNodes = _doc.getElementsByTagName("source");
            NamedNodeMap sourceAttributes = styleNodes.item(0).getAttributes();
            sourceAttributes.getNamedItem("type").setNodeValue(powerEvent.GetEventSource());
            sourceAttributes.getNamedItem("user_id").setNodeValue(powerEvent.GetEventID());
            sourceAttributes.getNamedItem("ipAddress").setNodeValue(powerEvent.GetUserIP());
            sourceAttributes.getNamedItem("sampleSize").setNodeValue(Integer.toString(powerEvent.GetSampleSize()));
            sourceAttributes.getNamedItem("timestamp").setNodeValue(powerEvent.GetPowerSamples()[0].GetTimeStamp().toString());

            NodeList priorPowerNodes = _doc.getElementsByTagName("priorPower");
            priorPowerNodes.item(0).appendChild(CreatePowerSampleElement(powerEvent.GetPriorPower()));

            NodeList eventPowerNodes = _doc.getElementsByTagName("eventPower");
            for(int i = powerEvent.GetSampleSize(); i > 0; i--)
                eventPowerNodes.item(0).appendChild(CreatePowerSampleElement(powerEvent.GetPowerSamples()[i-1]));
        }
        return updated;
    }

    public Element CreatePowerSampleElement(PowerSampleDTO powerSample) {
        Element powerSampleElem = _doc.createElement("powerSample");
        
        Attr  pA= _doc.createAttribute("pA");
        pA.setNodeValue(Double.toString(powerSample.getRealPower()));
        powerSampleElem.setAttributeNode(pA);
        Attr qA = _doc.createAttribute("qA");
        qA.setNodeValue(Double.toString(powerSample.getReactivePower()));
        powerSampleElem.setAttributeNode(qA); 
        Attr pB = _doc.createAttribute("pB");
        pB.setNodeValue(Double.toString(powerSample.GetRealPowerB()));
        powerSampleElem.setAttributeNode(pB);
        Attr qB = _doc.createAttribute("qB");
        qB.setNodeValue(Double.toString(powerSample.GetReactivePowerB()));
        powerSampleElem.setAttributeNode(qB);
        Attr angle = _doc.createAttribute("angle");
        angle.setNodeValue(Double.toString(powerSample.GetPowerAngle()));
        powerSampleElem.setAttributeNode(angle);
        Attr timestamp = _doc.createAttribute("timestamp");
        timestamp.setNodeValue((powerSample.GetTimeStamp().toString()));
        powerSampleElem.setAttributeNode(timestamp);

        return powerSampleElem;
    }

    

}
