/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;


/**
 * The Class PropertiesUtil.
 */
public class PropertiesUtil {
	
	/**
	 * Gets the property.
	 * 
	 * @param ctx the ctx
	 * @param path the path
	 * @return the property
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private Properties getProperty(ServletContext ctx, String path) throws IOException{		 
		InputStream inStream = ctx.getResourceAsStream(path);
		Properties prop = new Properties();
		prop.load(inStream);		
		return prop;
	}
	
	/**
	 * Gets the database environments.
	 * 
	 * @param ctx the ctx
	 * @return the database environments
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public Map<String, String> getDatabaseEnvironments(ServletContext ctx) throws IOException{
		Map<String, String> env = new HashMap<String, String>();
		Properties prop = getProperty(ctx,"/WEB-INF/jdbc.properties");
		env.put("PROD", prop.getProperty("jdbc.prod.db"));
		env.put("UAT", prop.getProperty("jdbc.uat.db"));
		env.put("DEVT", prop.getProperty("jdbc.devt.db"));
		return env;
	}
	
}