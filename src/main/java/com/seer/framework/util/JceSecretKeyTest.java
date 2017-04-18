/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

/**
 * JceSecretKeyTest.java
 * Copyright (c) 2002 by Dr. Herong Yang
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;



/**
 * The Class JceSecretKeyTest.
 */
class JceSecretKeyTest {
   
   /**
    * The main method.
    * 
    * @param a the arguments
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
   public static void main(String[] a) throws InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, IOException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
      if (a.length<3) {
         System.out.println("Usage:");
         System.out.println("java JceSecretKeyTest keySize output"
            +" algorithm");
         //return;
      }
      @SuppressWarnings("unused")
	int keySize = Integer.parseInt("112");//a[0]);
      @SuppressWarnings("unused")
	String output = "c:"+File.separator+"CPI";//a[1];
      @SuppressWarnings("unused")
	String algorithm = "DESede";//a[2]; // Blowfish, DES, DESede, HmacMD5
//      try {
//         writeKey(keySize,output,algorithm);
//         readKey(output,algorithm);
//         System.out.println("finished!");
//      } catch (Exception e) {
//         System.out.println("Exception: "+e);
//         return;
//      }
     /* SecretKey key = loadKey(output, algorithm);
      String encrypted = doEncrypt("mypassword", key);
      System.out.println("encrypted: "+encrypted);
      
      String decrypted = doDecrypt(encrypted, key);
      System.out.println("decrypted: "+decrypted);*/
	   
	   /*write key*/
     try {
		writeKey(112, "sampleKey", "DESede");
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
      
   }
   
   /**
    * Load key.
    * 
    * @param fileName the file name
    * @param algorithm the algorithm
    * 
    * @return the secret key
    * 
    * @throws IOException Signals that an I/O exception has occurred.
    * @throws InvalidKeyException the invalid key exception
    * @throws NoSuchAlgorithmException the no such algorithm exception
    * @throws InvalidKeySpecException the invalid key spec exception
    */
   @SuppressWarnings("unused")
private static SecretKey loadKey(String fileName, String algorithm) throws IOException, InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException{
	   String fl = fileName+".key";
	      File file = new File(fl);
	      FileInputStream fis = new FileInputStream(file);
	      System.out.println("file: ");
	      int kl = fis.available();
	      byte[] kb = new byte[kl];
	      fis.read(kb);
	      fis.close();
	      KeySpec ks = null;
	      SecretKey ky = null;
	      SecretKeyFactory kf = null;
	      
	      if (algorithm.equalsIgnoreCase("DES")) {
	       	 ks = new DESKeySpec(kb);
	          kf = SecretKeyFactory.getInstance("DES");
	          ky = kf.generateSecret(ks);
	       } else if (algorithm.equalsIgnoreCase("DESede")) {
	       	 ks = new DESedeKeySpec(kb);
	          kf = SecretKeyFactory.getInstance("DESede");
	          ky = kf.generateSecret(ks);
	       } else {
	          ks = new SecretKeySpec(kb,algorithm);
	          ky = new SecretKeySpec(kb,algorithm);
	       }

	return ky;
	   
   }
   
   /**
    * Write key.
    * 
    * @param keySize the key size
    * @param output the output
    * @param algorithm the algorithm
    * 
    * @throws Exception if any error occurs during the execution of the method
    */
   private static void writeKey(int keySize, String output, 
         String algorithm) throws Exception {
      KeyGenerator kg = KeyGenerator.getInstance(algorithm);
      kg.init(keySize);
      System.out.println();
      System.out.println("KeyGenerator Object Info: ");
      System.out.println("Algorithm = "+kg.getAlgorithm());
      System.out.println("Provider = "+kg.getProvider());
      System.out.println("Key Size = "+keySize);
      System.out.println("toString = "+kg.toString());

      SecretKey ky = kg.generateKey();
      String fl = output+".key";
      File file = new File(fl);
      FileOutputStream fos = new FileOutputStream(file);
      byte[] kb = ky.getEncoded();
      fos.write(kb);
      fos.close();
      System.out.println();
      System.out.println("SecretKey Object Info: ");
      System.out.println("Algorithm = "+ky.getAlgorithm());
      System.out.println("Saved File = "+fl);
      System.out.println("Size = "+kb.length);
      System.out.println("Format = "+ky.getFormat());
      System.out.println("toString = "+ky.toString());
   }
   
   /**
    * Read key.
    * 
    * @param input the input
    * @param algorithm the algorithm
    * 
    * @throws Exception if any error occurs during the execution of the method
    */
   @SuppressWarnings("unused")
private static void readKey(String input, String algorithm) 
      throws Exception {
      String fl = input+".key";
      File file = new File(fl);
      FileInputStream fis = new FileInputStream(file);
      System.out.println("file: ");
      int kl = fis.available();
      byte[] kb = new byte[kl];
      fis.read(kb);
      fis.close();
      KeySpec ks = null;
      SecretKey ky = null;
      SecretKeyFactory kf = null;
      if (algorithm.equalsIgnoreCase("DES")) {
      	 ks = new DESKeySpec(kb);
         kf = SecretKeyFactory.getInstance("DES");
         ky = kf.generateSecret(ks);
      } else if (algorithm.equalsIgnoreCase("DESede")) {
      	 ks = new DESedeKeySpec(kb);
         kf = SecretKeyFactory.getInstance("DESede");
         ky = kf.generateSecret(ks);
      } else {
         ks = new SecretKeySpec(kb,algorithm);
         ky = new SecretKeySpec(kb,algorithm);
      }

      System.out.println();
      System.out.println("KeySpec Object Info: ");
      System.out.println("Saved File = "+fl);
      System.out.println("Length = "+kb.length);
      System.out.println("toString = "+ks.toString());

      System.out.println();
      System.out.println("SecretKey Object Info: ");
      System.out.println("Algorithm = "+ky.getAlgorithm());
      System.out.println("toString = "+ky.toString());
   }
   
   /**
    * Do encrypt.
    * 
    * @param password the password
    * @param key the key
    * 
    * @return the string
    * 
    * @throws NoSuchAlgorithmException the no such algorithm exception
    * @throws NoSuchProviderException the no such provider exception
    * @throws NoSuchPaddingException the no such padding exception
    * @throws InvalidKeyException the invalid key exception
    * @throws IllegalBlockSizeException the illegal block size exception
    * @throws BadPaddingException the bad padding exception
    */
   public static String doEncrypt(String password, SecretKey key) throws NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException
   {
	   
	   Cipher des=Cipher.getInstance("DESede", "SunJCE");
	   des.init(Cipher.ENCRYPT_MODE, key);
	   /*Convert Password to Byte Array*/
	     byte bb[] = new byte[1024];
	     bb = password.getBytes();
	     
	     /*Encrypt*/
	     byte[] ciphertext = des.doFinal(bb);
	     
	     sun.misc.BASE64Encoder encoder = new BASE64Encoder();
	     String base64 = encoder.encode(ciphertext);
	     
	   return base64;
   }
   
   /**
    * Do decrypt.
    * 
    * @param encryptedPassword the encrypted password
    * @param key the key
    * 
    * @return the string
    * 
    * @throws IOException Signals that an I/O exception has occurred.
    * @throws NoSuchAlgorithmException the no such algorithm exception
    * @throws NoSuchProviderException the no such provider exception
    * @throws NoSuchPaddingException the no such padding exception
    * @throws InvalidKeyException the invalid key exception
    * @throws IllegalBlockSizeException the illegal block size exception
    * @throws BadPaddingException the bad padding exception
    */
   public static String doDecrypt(String encryptedPassword, Key key) throws IOException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException
   {
	   sun.misc.BASE64Decoder decoder = new BASE64Decoder();
	      byte[] ciphertext = decoder.decodeBuffer(encryptedPassword);
	      
	      /*Create the cipher*/
	      Cipher des=Cipher.getInstance("DESede","SunJCE");
	      
	      /*Initialize the cipher for Decryption*/
	      des.init(Cipher.DECRYPT_MODE, key);
	      
	      /*Decrypt*/
	      byte[] decrypted = des.doFinal(ciphertext);
	      String decryptedPassword = new String(decrypted, "UTF8");
	      
	      return decryptedPassword;
   }
}


