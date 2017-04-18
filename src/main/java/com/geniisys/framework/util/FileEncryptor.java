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
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.Logger;

/**
 * The Class FileEncryptor.
 */
public class FileEncryptor {
	
	/** The log. */
	private static Logger log = Logger.getLogger(FileEncryptor.class);
	
	/** The key. */
	protected static SecretKey key;

	/** The algorithm. */
	private static String algorithm = "DESede";

	/** The file name. */
	private static String fileName = "pos.key";

	/** The file dir. */
	private static String fileDir = "/home/oliever";

	/** The key size. */
	@SuppressWarnings("unused")
	private static String keySize = "122";

	/**
	 * Encrypt file.
	 * 
	 * @param file the file
	 * 
	 * @return the file
	 * 
	 * @throws Exception if any error occurs during the execution of the method
	 */
	public File encryptFile(File file) throws Exception {
		FileInputStream fis = new FileInputStream(file);
		int kl = fis.available();
		byte[] fileBytes =  new byte[kl];
		fis.read(fileBytes);
		fis.close();
		byte[] encryptedBytes = doEncrypt(fileBytes);
		
		File encryptedFile = File.createTempFile("encrypted", ".tmp");
		FileOutputStream fos = new FileOutputStream(encryptedFile);
		fos.write(encryptedBytes);
		return encryptedFile;
	}
	
	/**
	 * Do encrypt.
	 * 
	 * @param fileBytes the file bytes
	 * 
	 * @return the byte[]
	 * 
	 * @throws InvalidKeyException the invalid key exception
	 * @throws NoSuchAlgorithmException the no such algorithm exception
	 * @throws InvalidKeySpecException the invalid key spec exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws NoSuchProviderException the no such provider exception
	 * @throws NoSuchPaddingException the no such padding exception
	 * @throws IllegalBlockSizeException the illegal block size exception
	 * @throws BadPaddingException the bad padding exception
	 */
	private static byte[] doEncrypt(byte[] fileBytes) throws InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, IOException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException{
		loadKey();
		Cipher des = Cipher.getInstance(algorithm);
		des.init(Cipher.ENCRYPT_MODE, key);
		byte[] cipherFile = des.doFinal(fileBytes);
		return cipherFile;
	}
	
	/**
	 * Do decrypt.
	 * 
	 * @param fileBytes the file bytes
	 * 
	 * @return the byte[]
	 */
	private static byte[] doDecrypt(byte[] fileBytes) {
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
		Cipher des = null;
		try {
			des = Cipher.getInstance(algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		try {
			System.out.println("key: "+key);
			des.init(Cipher.DECRYPT_MODE, key);
			System.out.println("mode: "+des.getAlgorithm());
			System.out.println(des.getIV());
		} catch (InvalidKeyException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		byte[] decrypted = null;
		try {
			System.out.println("filebytes: "+fileBytes.length);
			decrypted = des.doFinal(fileBytes);
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (BadPaddingException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return decrypted;
	}
	
	/**
	 * Load key.
	 * 
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws InvalidKeyException the invalid key exception
	 * @throws NoSuchAlgorithmException the no such algorithm exception
	 * @throws InvalidKeySpecException the invalid key spec exception
	 */
	private static void loadKey() throws IOException, InvalidKeyException,
			NoSuchAlgorithmException, InvalidKeySpecException {
		File file = new File(fileDir + File.separator + fileName);
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
		System.out.println("key loaded: "+key.getAlgorithm());
	}
	
	/**
	 * The main method.
	 * 
	 * @param args the arguments
	 * 
	 * @throws InvalidKeyException the invalid key exception
	 * @throws NoSuchAlgorithmException the no such algorithm exception
	 * @throws InvalidKeySpecException the invalid key spec exception
	 * @throws NoSuchProviderException the no such provider exception
	 * @throws NoSuchPaddingException the no such padding exception
	 * @throws IllegalBlockSizeException the illegal block size exception
	 * @throws BadPaddingException the bad padding exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public static void main(String[] args) throws InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, IOException {
		File file = new File("/home/oliever/testFile");
		FileInputStream fis = new FileInputStream(file);
		int kl = fis.available();
		byte[] fileBytes =  new byte[kl];
		fis.read(fileBytes);
		fis.close();
		byte[] encryptedBytes = doEncrypt(fileBytes);
		System.out.println("enc length: "+encryptedBytes.length);
		File encFile = new File("/home/oliever/testFileEnc.txt");
		FileOutputStream fos = new FileOutputStream(encFile);
		fos.write(encryptedBytes);
		fos.close();
		
		
		//load the encripted file again
		File file2 = new File("/home/oliever/testFileEnc.txt");
		FileInputStream fis2 = new FileInputStream(file2);
		int kl2 = fis2.available();
		byte[] fileBytes2 = new byte[kl2];
		fis2.read();
		fis2.close();
		byte[] decryptedBytes = doDecrypt(fileBytes2);
		System.out.println("dec length: "+decryptedBytes.length);
		File decFile = new File("/home/oliever/testFileDec.txt");
		FileOutputStream fos2 = new FileOutputStream(decFile);
		fos2.write(decryptedBytes);
		fos2.close();
		
		
	}
}
