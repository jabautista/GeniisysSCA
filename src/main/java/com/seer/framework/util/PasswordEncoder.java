/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.ObjectInputStream;
import java.security.Key;

import org.apache.log4j.Logger;





/**
 * The Class PasswordEncoder.
 */
public class PasswordEncoder
{
    
    /** The filename. */
    protected static String filename;
    
    /** The key. */
    protected static Key key;
    
    /** The param. */
    static java.security.AlgorithmParameters param;
    
    /** The log. */
    protected static Logger log = Logger.getLogger(PasswordEncoder.class);
    
    /** The key file. */
    private static String keyFile;
    
    /** The key dir. */
    private static String keyDir;

    
    
    
    /**
     * Gets the key dir.
     * 
     * @return Returns the keyDir.
     */
    public String getKeyDir()
    {
        return keyDir;
    }

    /**
     * Sets the key dir.
     * 
     * @param keyDir The keyDir to set.
     */
    public void setKeyDir(String keyDir)
    {
        PasswordEncoder.keyDir = keyDir;
    }

    /**
     * Gets the key file.
     * 
     * @return Returns the keyFile.
     */
    public String getKeyFile()
    {
        return keyFile;
    }

    /**
     * Sets the key file.
     * 
     * @param keyFile The keyFile to set.
     */
    public void setKeyFile(String keyFile)
    {
        PasswordEncoder.keyFile = keyFile;
    }
        

    /**
     * Instantiates a new password encoder.
     */
    public PasswordEncoder()
    {
        // filename = "temp.ser";
        // key = null;
    }

    /**
     * Load key.
     */
    private static void loadKey()
    {
        try
        {
            // filename = ProgramAttributes.getProperty("SecretKeyLocation");
            log.info("Password Encoder dir : " + keyDir);
            log.info("Password Encoder filename : " + keyFile);
            ObjectInputStream in = new ObjectInputStream(new FileInputStream(
                    keyDir + File.separator + keyFile));
            key = (Key) in.readObject();
            log.info("KEY " + key);
            in.close();
        } catch (Exception e)
        {
            log.info("Error: PasswordEncoder " + e);
        }
    }

    /**
     * Encrypt.
     * 
     * @param password the password
     * 
     * @return the string
     */
    @SuppressWarnings("static-access")
	public static String encrypt(String password)
    {
        loadKey();
        Encrypt enc = new Encrypt();
        String encPassword = enc.doEncrypt(password, key);        
        log.info("Passed Here with encPassword = " + encPassword);
        return encPassword;
    }

    /**
     * Decrypt.
     * 
     * @param encryptedPassword the encrypted password
     * 
     * @return the string
     */
    @SuppressWarnings("static-access")
	public static String decrypt(String encryptedPassword)
    {
        loadKey();
        Decrypt dec = new Decrypt();
        String decPassword = dec.doDecrypt(encryptedPassword, key); 
        log.info("Passed Here with decPassword = " + decPassword);
        return decPassword;
    }

    /**
     * Verify.
     * 
     * @param password the password
     * @param encryptedPassword the encrypted password
     * 
     * @return true, if successful
     */
    @SuppressWarnings("static-access")
	public static boolean verify(String password, String encryptedPassword)
    {
        Decrypt dec = new Decrypt();
        String decPassword = dec.doDecrypt(encryptedPassword, key);
        if (decPassword.equals(password))
            return true;
        else
            return false;
    }
    
    /**
     * The main method.
     * 
     * @param args the arguments
     */
    public static void main(String args[])
    {
        @SuppressWarnings("unused")
		PasswordEncoder passwordEncoder = (PasswordEncoder)ApplicationContextReader.loadClassPathXmlContext("passwordEncoder");        
        String password = "sscoadmin";
        String encPassword = encrypt(password);
        PasswordEncoder.log.info(password + " = " + encPassword);
        PasswordEncoder.log.info("length = " + encPassword.length());
        String decPassword = decrypt("zkwHv3xgvHLuJU4+NNPlKQ==");
        PasswordEncoder.log.info(password + " = " + decPassword);
    }
}
