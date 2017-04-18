/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.Logger;

import com.geniisys.common.exceptions.NoSaltException;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;


/**
 * The Class PasswordEncoder.
 */
public class PasswordEncoder {

	/** The key. */
	protected static SecretKey key;
	
	/** The log. */
	private static Logger log = Logger.getLogger(PasswordEncoder.class);
	
	/** The algorithm. */
	private static String algorithm = "DESede";
	
	/** The file name. */
	private static String fileName = "GENIISYS_WEB.key";
	
	/** The file dir. */
	private static String fileDir = "C:/GENIISYS_WEB/KEY";
	
	/** The key size. */
	private static String keySize = "122";

	/**
	 * Verify.
	 * 
	 * @param str the str
	 * @param enc the enc
	 * @return true, if successful
	 * @throws Exception the exception
	 */
	public static boolean verify(String str, String enc) throws Exception {
		if (str.equals(doDecrypt(enc))) {
			return true;
		} else {
			return false;
		}

	}

	/**
	 * Load key.
	 * 
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws InvalidKeyException the invalid key exception
	 * @throws NoSuchAlgorithmException the no such algorithm exception
	 * @throws InvalidKeySpecException the invalid key spec exception
	 */
	public static void loadKey() throws IOException, InvalidKeyException,
			NoSuchAlgorithmException, InvalidKeySpecException {
		File file = new File(fileDir + File.separator + fileName);
		//System.out.println("KEY (load key): " + key);
		FileInputStream fis = new FileInputStream(file);
		int kl = fis.available();
		byte[] kb = new byte[kl];
		fis.read(kb);
		fis.close();
		KeySpec ks = null;
		SecretKeyFactory kf = null;
		if (algorithm.equalsIgnoreCase("DES")) {
			ks = new DESKeySpec(kb);
			kf = SecretKeyFactory.getInstance("DES");
			key = kf.generateSecret(ks);
		} else if (algorithm.equalsIgnoreCase("DESede")) {
			ks = new DESedeKeySpec(kb);
			kf = SecretKeyFactory.getInstance("DESede");
			key = kf.generateSecret(ks);
		} else {
			ks = new SecretKeySpec(kb, algorithm);
			key = new SecretKeySpec(kb, algorithm);
		}
		//System.out.println("KEY: " + key);
	}

	/**
	 * Do encrypt.
	 * 
	 * @param string the string
	 * @return the string
	 * @throws Exception the exception
	 */
	public static String doEncrypt(String string) throws Exception {
		if (null == key) {
			loadKey();
		}
		Cipher des = Cipher.getInstance("DESede", "SunJCE");
		des.init(Cipher.ENCRYPT_MODE, key);
		/* Convert Password to Byte Array */
		byte bb[] = new byte[1024];
		bb = string.getBytes();

		/* Encrypt */
		byte[] ciphertext = des.doFinal(bb);

		sun.misc.BASE64Encoder encoder = new BASE64Encoder();
		String base64 = encoder.encode(ciphertext);

		return base64;
	}

	/**
	 * Do decrypt.
	 * 
	 * @param encryptedPassword the encrypted password
	 * @return the string
	 * @throws Exception the exception
	 */
	public static String doDecrypt(String encryptedPassword) throws Exception {
		if (null == key) {
			loadKey();
		}
		sun.misc.BASE64Decoder decoder = new BASE64Decoder();
		byte[] ciphertext = decoder.decodeBuffer(encryptedPassword);

		/* Create the cipher */
		Cipher des = Cipher.getInstance("DESede", "SunJCE");

		/* Initialize the cipher for Decryption */
		des.init(Cipher.DECRYPT_MODE, key);

		/* Decrypt */
		byte[] decrypted = des.doFinal(ciphertext);
		String decryptedPassword = new String(decrypted, "UTF8");

		return decryptedPassword;
	}

	/**
	 * Generate key.
	 * 
	 * @param path the path
	 */
	public void generateKey() {
		try {

			KeyGenerator keyGen = KeyGenerator.getInstance(algorithm);
			Integer keyInt = new Integer(keySize);
			log.info("generating key: algo: " + algorithm + ", keySize: " + keyInt);
			keyGen.init(112);

			SecretKey key = keyGen.generateKey();
			String fl = "/GENIISYS_WEB.key";
			File file = new File(fileDir + fl);
			FileOutputStream fos = new FileOutputStream(file);
			byte[] kb = key.getEncoded();
			fos.write(kb);
			fos.close();
			log.info("key successfully generated!");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}

	}

	/**
	 * Archive key.
	 */
	public void archiveKey() {
		SimpleDateFormat f = new SimpleDateFormat("dd-MM-yyyy_kk-mm-ss");
		String fl = "/ARCHIVE/GENIISYS_WEB_" + f.format(new Date()) + ".key";
		File file2 = new File(fileDir + fl);
		FileOutputStream fos;
		try {
			fos = new FileOutputStream(file2);
			byte[] kb = key.getEncoded();
			log.info("saving old key to " + file2 + "...");
			fos.write(kb);
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/**
	 * Rebuild user security.
	 */
	public void rebuildUserSecurity() {
		generateKey();
		try {
			loadKey();
		} catch (InvalidKeyException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/**
	 * The main method.
	 * 
	 * @param args the arguments
	 */
	public static void main(String args[]) {
		try {
			System.out.println(doDecrypt("60158058614520325400296104254055742540089"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Gets the algorithm.
	 * 
	 * @return the algorithm
	 */
	public String getAlgorithm() {
		return algorithm;
	}

	/**
	 * Sets the algorithm.
	 * 
	 * @param algorithm the new algorithm
	 */
	public void setAlgorithm(String algorithm) {
		PasswordEncoder.algorithm = algorithm;
	}

	/**
	 * Gets the file dir.
	 * 
	 * @return the file dir
	 */
	public String getFileDir() {
		return fileDir;
	}

	/**
	 * Sets the file dir.
	 * 
	 * @param fileDir the new file dir
	 */
	public void setFileDir(String fileDir) {
		PasswordEncoder.fileDir = fileDir;
	}

	/**
	 * Gets the file name.
	 * 
	 * @return the file name
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * Sets the file name.
	 * 
	 * @param fileName the new file name
	 */
	public void setFileName(String fileName) {
		PasswordEncoder.fileName = fileName;
	}

	/**
	 * Gets the key.
	 * 
	 * @return the key
	 */
	public SecretKey getKey() {
		return key;
	}

	/**
	 * Sets the key.
	 * 
	 * @param key the new key
	 */
	public void setKey(SecretKey key) {
		PasswordEncoder.key = key;
	}

	/**
	 * Gets the key size.
	 * 
	 * @return the key size
	 */
	public String getKeySize() {
		return keySize;
	}

	/**
	 * Sets the key size.
	 * 
	 * @param keySize the new key size
	 */
	public void setKeySize(String keySize) {
		PasswordEncoder.keySize = keySize;
	}
	
	public static byte[] createHash(String password, String algorithm, 
			byte[] salt, Integer iterations){
		
		byte[] hash = {};
		
		try {
			MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
			messageDigest.update(salt);
			hash = messageDigest.digest(password.getBytes("UTF-8"));
			
			for (int i = 0; i < iterations; i++) {
	    		messageDigest.reset();
	    		hash = messageDigest.digest(hash);
	    	}
			
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return hash;
	}
	
	public static byte[] generateSalt(Integer saltByteSize) throws NoSuchAlgorithmException {
		byte[] salt = new byte[saltByteSize];
		
		try {
			SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
			secureRandom.nextBytes(salt);
		} catch (NoSuchAlgorithmException e) {
			throw e;
		}
		
		return salt;
	}
	
	public static String toBase64(byte[] b) {
    	BASE64Encoder base64Encoder = new BASE64Encoder();
    	return base64Encoder.encode(b);
    }
	
	public static byte[] base64ToByte(String s) throws IOException {
        BASE64Decoder decoder = new BASE64Decoder();
        return decoder.decodeBuffer(s);
    }

	public static boolean comparePassword(String enteredPassword, String storedPassword, String salt, Map<String, Object> hashingParams) throws NoSuchAlgorithmException, IOException, NoSaltException {
		if(salt == null || salt.isEmpty()) {
			throw new NoSaltException("Salt was not generated, please contact your administrator.");
		}
		
		MessageDigest md = MessageDigest.getInstance(hashingParams.get("ALGORITHM").toString());
		md.update(base64ToByte(salt));
		
		byte[] hash = md.digest(enteredPassword.getBytes("UTF-8"));
		
		for (int i = 0; i < Integer.parseInt(hashingParams.get("NO_OF_ITERATIONS").toString()); i++) {
    		md.reset();
    		hash = md.digest(hash);
    	}
		
		return Arrays.equals(hash, base64ToByte(storedPassword));
	}
}
