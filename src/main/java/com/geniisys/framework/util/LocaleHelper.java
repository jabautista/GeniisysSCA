/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.util.Locale;

import org.apache.log4j.Logger;


/**
 * The Class LocaleHelper.
 */
public class LocaleHelper {

	/** The helper. */
	private static LocaleHelper helper;
	
	/** The locale. */
	private Locale locale;
	
	/** The log. */
	private static Logger log = Logger.getLogger(LocaleHelper.class);
	
	/** The DE f_ language. */
	private static String DEF_LANGUAGE = "en";
	
	/** The DE f_ country. */
	private static String DEF_COUNTRY = "US";
	
	/**
	 * Instantiates a new locale helper.
	 */
	private LocaleHelper(){		
	}
	
	/**
	 * Gets the single instance of LocaleHelper.
	 * 
	 * @return single instance of LocaleHelper
	 */
	public static synchronized LocaleHelper getInstance(){
		if(null==helper){
			helper = new LocaleHelper();
		}
		helper.init();
		return helper;
	}
	
	/**
	 * Inits the.
	 */
	private void init(){
		if(null==locale){
			locale = new Locale(DEF_LANGUAGE, DEF_COUNTRY);
		}
	}
	
	/**
	 * Sets the locale.
	 * 
	 * @param code the new locale
	 */
	public void setLocale(String code){
		if("PH".equalsIgnoreCase(code)){
			log.info("Locale Philippines");
			locale = new Locale("ph", "PH");
		} else if("US".equalsIgnoreCase(code)){
			log.info("Locale USA");
			locale = new Locale("en", "US");
		} else if("CN".equalsIgnoreCase(code)){
			log.info("Locale China");
			locale = new Locale("cn", "CN");
		} else {
			locale = new Locale(DEF_LANGUAGE, DEF_COUNTRY);
		}
	}
	
	/**
	 * Sets the default.
	 */
	public void setDefault(){
		locale = new Locale(DEF_LANGUAGE, DEF_COUNTRY);
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#clone()
	 */
	@Override
	public Object clone() throws CloneNotSupportedException {
		throw new CloneNotSupportedException(); 
    }

	/**
	 * Gets the locale.
	 * 
	 * @return the locale
	 */
	public Locale getLocale() {
		return locale;
	}
	
	public static void setDefaultLocale(String defaultLanguage){
		if (defaultLanguage != null && !defaultLanguage.trim().equals("")){
			String str[] = defaultLanguage.split("_");
			if(str[0] != null && !str[0].trim().equals("")){
				DEF_LANGUAGE = str[0];
				if(str[1] != null && !str[1].trim().equals("")){
					DEF_COUNTRY = str[1];		
				}
			} 
		}
	}
}
