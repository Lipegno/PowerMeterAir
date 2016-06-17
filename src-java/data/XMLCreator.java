/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package data;

import java.io.IOException;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import model.GoalSampleDTO;
import model.PowerSampleDTO;
import model.VoteSampleDTO;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
/**
 *
 * @author lucaspereira
 */

public class XMLCreator {
     
    private Document _doc = null;
    private boolean _templateLoaded = false;
    private String templatePath;

    public XMLCreator(String templatePath) {
    	this.templatePath = templatePath;
        if((_doc = LoadTemplate(templatePath)) == null) {
            System.out.println("Error on Parsing XML");
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

    public void CreateXML(PowerSampleDTO[] powerSamples) {

        NodeList root = _doc.getElementsByTagName("daily_power");
        

        for(int i = 0; i < powerSamples.length; i++) {
            root.item(0).appendChild(CreatePowerSampleElement(powerSamples[i]));
        }

        root = _doc.getElementsByTagName("daily_power");

        printNode(root.item(0),"\n");
        
    }
    
    public void CreateXML(GoalSampleDTO[] goalSamples) {

        NodeList root = _doc.getElementsByTagName("daily_power");
        

        for(int i = 0; i < goalSamples.length; i++) {
            root.item(0).appendChild(CreateGoalSampleElement(goalSamples[i]));
        }

        root = _doc.getElementsByTagName("daily_power");

        printNode(root.item(0),"\n");
        
    }
    
    public void CreateXML(VoteSampleDTO[] goalSamples) {

        NodeList root = _doc.getElementsByTagName("daily_power");
        

        for(int i = 0; i < goalSamples.length; i++) {
            root.item(0).appendChild(CreateVoteSampleElement(goalSamples[i]));
        }

        root = _doc.getElementsByTagName("daily_power");

        printNode(root.item(0),"\n");
        
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
        timestamp.setNodeValue((Long.toString(powerSample.GetTimeStamp().getTime())));
        powerSampleElem.setAttributeNode(timestamp);

        return powerSampleElem;
    }
    
    public Element CreateGoalSampleElement(GoalSampleDTO goalSample) {
        Element powerSampleElem = _doc.createElement("goalSample");
        
	        Attr  pA= _doc.createAttribute("goal");
	        pA.setNodeValue(goalSample.get_goal());
	        powerSampleElem.setAttributeNode(pA);
	        Attr qA = _doc.createAttribute("timestamp");
	        qA.setNodeValue((Long.toString(goalSample.get_date().getTime())));
	        powerSampleElem.setAttributeNode(qA); 
        return powerSampleElem;
    }
    
    public Element CreateVoteSampleElement(VoteSampleDTO voteSample) {
        Element powerSampleElem = _doc.createElement("goalSample");
        
	        Attr  goal= _doc.createAttribute("goal");
	        goal.setNodeValue(voteSample.get_goal());
	        powerSampleElem.setAttributeNode(goal);
	        
	        Attr  vote= _doc.createAttribute("vote");
	        vote.setNodeValue(voteSample.get_vote()+"");
	        powerSampleElem.setAttributeNode(vote);
	        
	        Attr role = _doc.createAttribute("role");
	        role.setNodeValue(voteSample.get_role());
	        powerSampleElem.setAttributeNode(role); 
	        
        return powerSampleElem;
    }
    
    public String getXMLString() throws TransformerConfigurationException, TransformerException, IOException {

        TransformerFactory factory = TransformerFactory.newInstance();
        Transformer transformer = factory.newTransformer();
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        Source source = new DOMSource(_doc);
        transformer.transform(source, result);
        writer.close();
        String xml = writer.toString();
        
        return xml;

    }

    private static void printNode(Node node, String indent)  {
        switch (node.getNodeType()) {
            case Node.DOCUMENT_NODE:
               // System.out.println("<xml version=\"1.0\">\n");
                // recurse on each child
                NodeList nodes = node.getChildNodes();
                if (nodes != null) {
                    for (int i=0; i<nodes.getLength(); i++) {
                        printNode(nodes.item(i), "");
                    }
                }
                break;
            case Node.COMMENT_NODE:
               // System.out.println(indent + "<!--" + node.getNodeValue()+"-->");
                break;
            case Node.ELEMENT_NODE:
                String name = node.getNodeName();
                System.out.print(indent + "<" + name);
                NamedNodeMap attributes = node.getAttributes();
                for (int i=0; i<attributes.getLength(); i++) {
                    Node current = attributes.item(i);
                    System.out.print(
                        " " + current.getNodeName() +
                        "=\"" + current.getNodeValue() +
                        "\"");
                }
                System.out.print(">");

                // recurse on each child
                NodeList children = node.getChildNodes();
                if (children != null) {
                    for (int i=0; i<children.getLength(); i++) {
                        printNode(children.item(i), indent + "  ");
                    }
                }

                System.out.print("</" + name + ">");
                break;

            case Node.TEXT_NODE:
                System.out.print(node.getNodeValue());
                break;
        }
    }


    

}
