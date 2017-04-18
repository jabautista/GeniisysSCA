package com.geniisys.framework.util;

import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringEscapeUtils;

/**
 * 
 * @author whofeih
 * @dateCreated 09/22/2010
 *
 */
public class FormInputUtil {

	/**
	 * @author Irwin
	 * @dateCreated 09/22/2010
	 * */
	public static Map<String, Object> getFormInputs(HttpServletRequest request) throws Exception {
		@SuppressWarnings("rawtypes")
		Enumeration paramNames = request.getParameterNames();
		Map<String, Object> formInputs = new HashMap<String, Object>();
		String key;
		String value;
		while(paramNames.hasMoreElements()){
			key = (String) paramNames.nextElement();
			value = request.getParameter((String) key);
			if(!key.equals("action")){
				formInputs.put(key, StringEscapeUtils.unescapeHtml(value)); // added unescape - irwin
			}
		}
		
		return formInputs;
	}
	
	/**
	 * @author Niknok
	 * @since 11.14.2011
	 * */
	public static void prepareDateParam(String name, Map<String, Object> params, HttpServletRequest request) throws ParseException{
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		SimpleDateFormat dateTime = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
		try {
			params.put(name, request.getParameter(name) == null || "".equals(request.getParameter(name)) ? null :date.parse(request.getParameter(name)));
		} catch (ParseException e) {
			try {
				params.put(name, request.getParameter(name) == null || "".equals(request.getParameter(name)) ? null :dateTime.parse(request.getParameter(name)));
			} catch (ParseException ee) {
				params.put(name, request.getParameter(name) == null || "".equals(request.getParameter(name)) ? null :df.parse(request.getParameter(name)));
			}
		}
	}
	
	/**
	 * @author d.alcantara
	 * @since 03.06.2012
	 * */
	@SuppressWarnings("rawtypes")
	public static Map<String, Object> formMapFromEntity(Object object) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		Map<String, Object> params = new HashMap<String, Object>();
		Map properties = PropertyUtils.describe(object);
		Iterator i = properties.keySet().iterator();
		while(i.hasNext()) {
			String property = (String) i.next();
			Object objVal = PropertyUtils.getProperty(object, property);
			params.put(property, objVal);
		}
		//System.out.println("Prepared params: "+params);
		return params;
	}
	
}
