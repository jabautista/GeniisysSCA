package com.geniisys.framework.util;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

public class UserSessionBindingListener implements HttpSessionBindingListener {
	
	@Override
	public void valueBound(HttpSessionBindingEvent event) {
		System.out.println("BOUND:::"+event.getName());
	}

	@Override
	public void valueUnbound(HttpSessionBindingEvent event) {
		System.out.println("UNBOUND:::"+event.getName());	
	}

}
