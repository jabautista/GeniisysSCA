package com.geniisys.framework.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Class with methods to get the MAC Address/es of the network card/s
 * 
 */
public final class MacAddress {

	static private Pattern macPattern = Pattern.compile(".*((:?[0-9a-f]{2}[-:]){5}[0-9a-f]{2}).*", Pattern.CASE_INSENSITIVE);

	//static final String[] linuxCommand = { "/sbin/ifconfig", "-a" };

	/**
	 * Search the MAC addresses of all network cards
	 * 
	 * @return the list of MAC addresses
	 * @throws IOException
	 */
/*	public final static List getMacAddresses() throws IOException {
		final List macAddressList = new ArrayList();

		// Extract the MAC addresses from stdout
		BufferedReader reader = getMacAddressesReader();
		System.out.println("reader:"+reader);
		for (String line = null; (line = reader.readLine()) != null;) {
			Matcher matcher = macPattern.matcher(line);
			if (matcher.matches()) {
				macAddressList.add(matcher.group(1).replaceAll("[-:]", ""));
			}
		}
		reader.close();

		return macAddressList;
	}*/

	/**
	 * Search the MAC address of the network card number=index
	 * 
	 * @param nicIndex
	 *            the number of the network card (0 is the first index)
	 * 
	 * @return a MAC address
	 * @throws IOException
	 */
	public final static String getMacAddress(String ipAddress) throws IOException {
		// Extract the MAC addresses from stdout		
		BufferedReader reader = getMacAddressesReader(ipAddress);
		for (String line = null; (line = reader.readLine()) != null;) {
			Matcher matcher = macPattern.matcher(line);
			if (matcher.matches()) {				
				reader.close();
				return matcher.group(1);
			}
		}
		reader.close();
		return null;
	}

	private static BufferedReader getMacAddressesReader(String ipAddress) throws IOException {
		final String[] windowsCommand = {"nbtstat", "-a", ipAddress};
		final String[] command;
		final String os = System.getProperty("os.name");
		if (os.startsWith("Windows")) {
			command = windowsCommand;
		} else {
			throw new IOException("Unknown operating system: " + os);
		}

		final Process process = Runtime.getRuntime().exec(command);

		// Discard the stderr
		new Thread() {
			public void run() {
				try {
					InputStream errorStream = process.getErrorStream();
					while (errorStream.read() != -1) {
					};
					errorStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}.start();

		//Extract the MAC addresses from stdout
		return new BufferedReader(new InputStreamReader(process.getInputStream()));
	}
	
	public final static String getMacAddressByArp(String ipAddress) throws IOException {
		// Extract the MAC addresses from stdout		
		BufferedReader reader = getMacAddressesReaderByArp(ipAddress);
		for (String line = null; (line = reader.readLine()) != null;) {
			Matcher matcher = macPattern.matcher(line);
			if (matcher.matches()) {				
				reader.close();
				return matcher.group(1);
			}
		}
		reader.close();
		return null;
	}

	private static BufferedReader getMacAddressesReaderByArp(String ipAddress) throws IOException {
		final String[] windowsCommand = {"arp", "-a", ipAddress};
		final String[] command;
		final String os = System.getProperty("os.name");
		if (os.startsWith("Windows")) {
			command = windowsCommand;
		} else {
			throw new IOException("Unknown operating system: " + os);
		}

		final Process process = Runtime.getRuntime().exec(command);

		// Discard the stderr
		new Thread() {
			public void run() {
				try {
					InputStream errorStream = process.getErrorStream();
					while (errorStream.read() != -1) {
					};
					errorStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}.start();

		//Extract the MAC addresses from stdout
		return new BufferedReader(new InputStreamReader(process.getInputStream()));
	}
}