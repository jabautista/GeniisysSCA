package com.geniisys.framework.util;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

public class UserSessionListener implements HttpSessionListener {

	private static List<HttpSession> userSessions;
	private static Logger log = Logger.getLogger(UserSessionListener.class);
	
	public UserSessionListener(){	
		userSessions = new ArrayList<HttpSession>();
	}
	
	/*
	 * (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionListener#sessionCreated(javax.servlet.http.HttpSessionEvent)
	 */
	@Override
	public void sessionCreated(HttpSessionEvent event) {
		userSessions.add(event.getSession());
	}

	/*
	 * (non-Javadoc)
	 * @see javax.servlet.http.HttpSessionListener#sessionDestroyed(javax.servlet.http.HttpSessionEvent)
	 */
	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		userSessions.remove(event.getSession());
	}
	
	public static void invalidateSessions(){
		log.info("Invalidating all sessions...");		
		for(HttpSession session: userSessions){
			session.invalidate();
		}
	}
	
	@SuppressWarnings("rawtypes")
	public static void printAllSessions(){
		String attrName;
		for(HttpSession session: userSessions){
			System.out.println("SESSION ID : " + session.getId());
			Enumeration attributes = session.getAttributeNames();
			while(attributes.hasMoreElements()){
				attrName = (String) attributes.nextElement();
				System.out.println(attrName.toUpperCase() + " : " + session.getAttribute(attrName));
			}
		}
	}
	
	public static List<HttpSession> getUserSessions(){
		return userSessions;
	}
	
	/**
	 * 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Integer getActiveLoginCount(String userId){
		Integer count = 0;
		for(HttpSession session: userSessions){
			Map<String, Object> params = (Map<String, Object>) session.getAttribute("PARAMETERS");			
			if(null != params){				
				if( params.get("userId").equals(userId)){
					count++;
				}
			}
		}
		return count;
	}
}
