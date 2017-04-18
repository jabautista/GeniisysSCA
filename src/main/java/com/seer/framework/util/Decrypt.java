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

import sun.misc.BASE64Decoder;





/**
 * The Class Decrypt.
 */
public class Decrypt
{
  
  /**
   * Instantiates a new decrypt.
   */
  public Decrypt()
  {
  }
  
  /**
   * Do decrypt.
   * 
   * @param encryptedPassword the encrypted password
   * @param key the key
   * 
   * @return the string
   */
  public static String doDecrypt(String encryptedPassword, Key key)
  {
    try
    {
      sun.misc.BASE64Decoder decoder = new BASE64Decoder();
      byte[] ciphertext = decoder.decodeBuffer(encryptedPassword);

      /*Create the cipher*/
      //Cipher des=Cipher.getInstance("DES-EDE3/ECB/PKCS#5","Cryptix");
      Cipher des=Cipher.getInstance("DESede","SunJCE");
      
      /*Initialize the cipher for Decryption*/
      //des.initDecrypt(key);
      des.init(Cipher.DECRYPT_MODE, key);
      
      /*Decrypt*/
      //byte[] decrypted = des.crypt(ciphertext);
      byte[] decrypted = des.doFinal(ciphertext);
      String decryptedPassword = new String(decrypted, "UTF8");

      //System.out.println("DecryptedPasswordByte: "+decrypted);
      //System.out.println("DecryptedPassword: "+decryptedPassword);

      return decryptedPassword;
    }
    catch(Exception e)
    {
      return null;
    }
  }
}
