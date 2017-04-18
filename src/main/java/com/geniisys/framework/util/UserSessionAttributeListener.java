package com.geniisys.framework.util;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;


public class UserSessionAttributeListener extends HttpServlet implements HttpSessionAttributeListener {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6769401582684457094L;

	@Override
	public void attributeAdded(HttpSessionBindingEvent ev) {	
		
	}

	@Override
	public void attributeRemoved(HttpSessionBindingEvent ev) {		

	}

	@Override
	public void attributeReplaced(HttpSessionBindingEvent ev) {

	}

}
