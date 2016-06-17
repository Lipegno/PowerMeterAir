package socket;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.net.UnknownHostException;


public class SocketDemo  {

	/**
	 * @param args
	 */
	
	protected String hostIp; 
	protected int hostPort; 
	protected ObjectInputStream in; 
	static boolean quit = false;
	public double currentP;
	public SocketDemo(String host, int port) {
		this.hostIp = host;
		this.hostPort = port;
	} 
	

	public double getPower() {
	 double	power=20;
		try {
			Socket client = new Socket(hostIp, hostPort); 
			in = new ObjectInputStream(client.getInputStream());
			try {
				power = (Double) in.readObject();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}			
			
			} catch (UnknownHostException e) { 
				System.out.println("Error setting up socket connection: unknown host at " + hostIp);
			} catch (IOException e) { System.out.println("Error setting up socket connection: " + e);
			}

		return power;
	}

}
