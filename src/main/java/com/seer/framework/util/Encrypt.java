/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.security.Key;

import javax.crypto.Cipher;

import sun.misc.BASE64Encoder;

/**
 * The Class Encrypt.
 */
public class Encrypt {

	/**
	 * Instantiates a new encrypt.
	 */
	public Encrypt() {
	}

	/**
	 * Do encrypt.
	 * 
	 * @param password
	 *            the password
	 * @param key
	 *            the key
	 * 
	 * @return the string
	 */
	public static String doEncrypt(String password, Key key) {
		try {			
			/* Create the cipher */
			// Cipher des=Cipher.getInstance("DES-EDE3/ECB/PKCS#5","Cryptix");
			Cipher des = Cipher.getInstance("DESede", "SunJCE");

			/* Initialize the cipher for Encryption */
			// des.initEncrypt(key);
			des.init(Cipher.ENCRYPT_MODE, key);

			/* Convert Password to Byte Array */
			byte bb[] = new byte[1024];
			bb = password.getBytes();

			/* Encrypt */
			// byte[] ciphertext = des.crypt(bb);
			byte[] ciphertext = des.doFinal(bb);

			sun.misc.BASE64Encoder encoder = new BASE64Encoder();
			String base64 = encoder.encode(ciphertext);

			return base64;
		} catch (Exception e) {
			System.out.println("EncryptError: " + e);
			return null;
		}
	}
}
