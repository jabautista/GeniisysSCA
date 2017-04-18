package com.geniisys.event.listeners;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.geniisys.framework.util.ContextParameters;

public class GeniisysSessionListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent event) {
		Integer timeout = ContextParameters.SESSION_TIMEOUT;
		if(timeout != null && timeout != 0){
			event.getSession().setMaxInactiveInterval(timeout*60);
		}
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent arg0) {
		// TODO Auto-generated method stub
		
	}

}
