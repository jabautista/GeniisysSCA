package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.GIPICAUploadService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PropertyFloaterUploadController", urlPatterns={"/PropertyFloaterUploadController"})
public class PropertyFloaterUploadController extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3214889762903744889L;
	
	private static Logger log = Logger.getLogger(PropertyFloaterUploadController.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = null;
		FileUploadListener listener = null;
		long contentLength = 0;

		if (((session = request.getSession()) == null) || ((listener = (FileUploadListener) session.getAttribute("LISTENER")) == null) || ((contentLength = listener.getContentLength()) < 1)) {
			out.write("");
			out.close();
			return;
		}

		response.setContentType("text/html");
		long percentComplite = ((100 * listener.getBytesRead()) / contentLength);
		out.print(percentComplite);
		out.close();
	}
	
	@SuppressWarnings({ "unchecked" })
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		String action = request.getParameter("action");
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
		}
		
		String PAGE = "";
		String message = "";
		HttpSession session = request.getSession();
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		String filePath = (String) appContext.getBean("uploadPath");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPICAUploadService gipiCaUploadService = (GIPICAUploadService) APPLICATION_CONTEXT.getBean("gipiCaUploadService");
		
		try{
			if ("validateUploadPropertyFloater".equals(action)) {
				String fileName = request.getParameter("fileName");
				String myFullFileName = fileName;
				String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
				int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
				PAGE = "/pages/genericMessage.jsp";
				message = "";
				
				String isExist = gipiCaUploadService.validateUploadPropertyFloater(myFullFileName.substring(lastIndexOfSlash+1));
				if (!("".equals(isExist)) && isExist != null) {
					message = isExist;
				}
			}else if("uploadPropertyFloater".equals(action)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("APPLICATION_CONTEXT", APPLICATION_CONTEXT);
				params.put("servletContext", getServletContext());
				params.put("request", request);
				params.put("response", response);
				params.put("session", session);
				params.put("userId", USER.getUserId());
				
				gipiCaUploadService.uploadFloater(params);
				
			} else if ("showCaErrorLog".equals(action)) {
				message = "SUCCESS";
				
				JSONObject jsonCaErrorLog = gipiCaUploadService.showCaErrorLog(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCaErrorLog.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("jsonCaErrorLog", jsonCaErrorLog);
					PAGE = "/pages/underwriting/overlay/propertyFloater/errorLogPropertyFloater.jsp";
				}
			}
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";		
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";	
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} finally {
			if("uploadPropertyFloater".equals(action)){
				session.removeAttribute("LISTENER");
				FileUtil.deleteDirectory(filePath);
			}else{
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
		}
	}
}