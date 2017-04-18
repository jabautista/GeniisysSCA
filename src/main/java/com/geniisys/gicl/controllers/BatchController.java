/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: BatchController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 20, 2011
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.BatchService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="BatchController", urlPatterns={"/BatchController"})
public class BatchController extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{


	private static final long serialVersionUID = 8487873211671712453L;
	private Logger log = Logger.getLogger(BatchController.class);
	public static String percentStatus = "0%";
	public static String messageStatus = "";
	public static String errorStatus = "";
	public static String workflowMsgr = "";
	public static String userId = "";
	public static String genericId =""; //Will hold Batch_dv_id or batch_csr_id
	public static JSONObject GIACBatchDv;
	private String del = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
	
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		System.out.println(BatchController.percentStatus);
		out.print(BatchController.percentStatus+del+BatchController.messageStatus+del+BatchController.errorStatus);
		out.close();	
	}
	
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String message = "";
		String page = "/pages/genericMessage.jsp";
		BatchController.percentStatus = "0%";
		BatchController.messageStatus = "";
		BatchController.errorStatus = "";
		BatchController.workflowMsgr = "";
		String messageTag = null;
		try{
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			String action = request.getParameter("action");
			System.out.println("ACTION: "+action);
			
			BatchService batchService = (BatchService) APPLICATION_CONTEXT.getBean("batchService");
			Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
			GIISUser USER = null;
			if (null != sessionParameters){
				USER = (GIISUser) sessionParameters.get("USER");
			}
			
			if("generateAE".equals(action)){
				message = batchService.generateAe(request, USER);
				if ((!BatchController.workflowMsgr.equals(""))||(BatchController.workflowMsgr.equals(null))){
					Runtime rt=Runtime.getRuntime();
					//rt.exec("C:\\WINDOWS\\NOTEPAD.exe");
					rt.exec(BatchController.workflowMsgr);
				}	
			}else if("approveBatchCsr".equals(action)){
				JSONObject objParams = new JSONObject(request.getParameter("parameters"));
				message = batchService.approveBatchCsr(objParams, USER);
			}else if("postRecovery".equals(action)) {
				JSONObject objParams = new JSONObject(request.getParameter("strParameters"));
				message = batchService.postRecovery(objParams, USER);
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			}
			messageTag = "Y";
			request.setAttribute("message", message);
			page = "/pages/genericMessage.jsp";
			this.getServletContext().getRequestDispatcher(page).forward(request, response);			
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally {			
			session.removeAttribute("POSTING");
			if(messageTag == null) {
				request.setAttribute("message", message+del+BatchController.errorStatus+del+BatchController.GIACBatchDv);
				this.getServletContext().getRequestDispatcher(page).forward(request, response);
			}
		}
	}
}
