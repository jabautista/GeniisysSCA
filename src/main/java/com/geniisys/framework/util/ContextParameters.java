package com.geniisys.framework.util;

import java.util.Map;

import org.apache.log4j.Logger;

/**
 * Geniisys parameters
 * @author andrew robes
 * @date 06/17/2011
 */
public final class ContextParameters {

	public static Integer PASSWORD_EXPIRY;
	public static Integer NO_OF_LOGIN_TRIES;
	public static String CLIENT_BANNER;
	public static String DEFAULT_COLOR;
	public static String ENABLE_MAC_VALIDATION;
	public static String ENABLE_CON_LOGIN_VALIDATION;
	public static Integer NO_OF_APP_PER_USER;
	public static String ENABLE_DETAILED_EXCEPTION_MESSAGE;
	public static String ENABLE_BROWSER_VALIDATION;
	public static String DEFAULT_LANGUAGE;
	public static String ENABLE_EMAIL_NOTIFICATION;
	public static Boolean UNDER_MAINTENANCE = false;
	public static String ENDT_BASIC_INFO_SW; // temporary parameter until newly created endt basic info is ready for deployment
	public static String ITEM_TABLEGRID_SW; // temporary parameter until item tablegrid screens are ready for deployment
	public static String AD_HOC_URL;
	public static Integer SESSION_TIMEOUT;
	public static Integer NEW_PASSWORD_VALIDITY;	
	public static String TEXT_EDITOR_FONT;
	
	private static Logger log = Logger.getLogger(ContextParameters.class);
	
	public static void setContextParameters(Map<String, Object> contextParams){
		log.info("Initializing context parameters : " + contextParams);
		if(contextParams.get("PASSWORD_EXPIRY") != null) ContextParameters.PASSWORD_EXPIRY = Integer.parseInt(contextParams.get("PASSWORD_EXPIRY").toString());
		ContextParameters.CLIENT_BANNER = (String) contextParams.get("CLIENT_BANNER");
		ContextParameters.DEFAULT_COLOR = (String) contextParams.get("DEFAULT_COLOR");
		ContextParameters.ENABLE_BROWSER_VALIDATION = (String) contextParams.get("ENABLE_BROWSER_VALIDATION");
		ContextParameters.ENABLE_CON_LOGIN_VALIDATION = (String) contextParams.get("ENABLE_CON_LOGIN_VALIDATION");
		ContextParameters.ENABLE_DETAILED_EXCEPTION_MESSAGE = (String) contextParams.get("ENABLE_DETAILED_EXCEPTION_MSG");
		ContextParameters.ENABLE_MAC_VALIDATION = (String) contextParams.get("ENABLE_MAC_VALIDATION");
		ContextParameters.ENABLE_EMAIL_NOTIFICATION = (String) contextParams.get("ENABLE_EMAIL_NOTIFICATION");
		if(contextParams.get("NO_OF_APP_PER_USER") != null) ContextParameters.NO_OF_APP_PER_USER = Integer.parseInt(contextParams.get("NO_OF_APP_PER_USER").toString());
		if(contextParams.get("NO_OF_LOGIN_TRIES") != null) ContextParameters.NO_OF_LOGIN_TRIES = Integer.parseInt(contextParams.get("NO_OF_LOGIN_TRIES").toString());
		ContextParameters.DEFAULT_LANGUAGE = (String) contextParams.get("DEFAULT_LANGUAGE");
		ContextParameters.ENDT_BASIC_INFO_SW = (String) contextParams.get("ENDT_BASIC_INFO_SW");
		ContextParameters.ITEM_TABLEGRID_SW = (String) contextParams.get("ITEM_TABLEGRID_SW");
		ContextParameters.AD_HOC_URL = (String) contextParams.get("AD_HOC_URL");
		ContextParameters.SESSION_TIMEOUT = Integer.parseInt(contextParams.get("SESSION_TIMEOUT").toString());
		ContextParameters.NEW_PASSWORD_VALIDITY = Integer.parseInt(contextParams.get("NEW_PASSWORD_VALIDITY") != null ? contextParams.get("NEW_PASSWORD_VALIDITY").toString() : "0");
		ContextParameters.TEXT_EDITOR_FONT = (String) contextParams.get("TEXT_EDITOR_FONT");
		
		LocaleHelper.setDefaultLocale(ContextParameters.DEFAULT_LANGUAGE);
	}
	
}
