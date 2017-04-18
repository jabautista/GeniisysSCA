package com.geniisys.framework.util;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.event.listeners.ContextListener;

public class ServletFilter implements Filter{	
	
	private FilterConfig filterConfig = null;
	
	@Override
	public void destroy() {
		this.filterConfig = null;	
	}

	@SuppressWarnings("unchecked")
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		if(!ContextListener.isConnectedToDatabase){
			req.getRequestDispatcher("/pages/errorPages/databaseConnectionFailed.jsp").forward(request, response);
			return;
		}
		
		if(ContextParameters.UNDER_MAINTENANCE){
			HttpSession session = req.getSession();
			Map<String, Object> params = (Map<String, Object>) session.getAttribute("PARAMETERS");
			if(params == null){
				req.getRequestDispatcher("/pages/errorPages/scheduledMaintenance.jsp").forward(request, response);
				return;
			} else {
				GIISUser user = (GIISUser) params.get("USER");			
				if(user == null || !user.getMisSw().equals("Y")){
					req.getRequestDispatcher("/pages/errorPages/scheduledMaintenance.jsp").forward(request, response);
					return;
				}
			}
						
		}		
		if(filterConfig == null){
			return;
		}
		
/*		String host = null;
		String referer = null;
				
		if(req.getHeader("referer") == null){
			Enumeration<String> names = req.getHeaderNames();
			System.out.println("WHEN NULL");
			while(names.hasMoreElements()){				
				String name = names.nextElement();
				System.out.println("NAME : " +name + " ::: " + req.getHeader(name));
			}
		}
		
		host = req.getHeader("host");
		referer = "http://"+ host + "/Geniisys/";
		System.out.println(referer + " |||||||||| " + req.getHeader("referer"));*/
		if(ContextParameters.ENABLE_BROWSER_VALIDATION.equals("Y") && !req.getHeader("user-agent").toUpperCase().contains("PRISM")){
			req.getRequestDispatcher("").forward(request, response);
		} else {
			chain.doFilter(request, response);
		}
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.filterConfig = config;
	}
}
