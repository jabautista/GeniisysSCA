package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.gipi.controllers.PostParController;
import com.geniisys.giuw.service.PostDistributionService;
import com.seer.framework.util.ApplicationContextReader;

public class PostDistributionController extends javax.servlet.http.HttpServlet
	   implements javax.servlet.Servlet{
	
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PostDistributionController.class);
	public static String percentStatus = "0%";
	public static String messageStatus = "";
	public static String errorStatus = "";
	public static String policyNo = "";
	public static String policyTitle = "";
	public static String workflowMsgr = "";
	public static String userId = "";
	public static String bookingMsg = "";
	private String del = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
	
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		System.out.println(PostParController.percentStatus);
		out.print(PostDistributionController.percentStatus+del+PostDistributionController.messageStatus+del+PostDistributionController.errorStatus
				  +del+PostDistributionController.bookingMsg+del+PostDistributionController.policyNo+del+PostDistributionController.policyTitle);
		out.close();	
	}
	
	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String message = "Posting of distribution Successful.";
		String page = "/pages/genericMessage.jsp";
		PostDistributionController.percentStatus = "0%";
		PostDistributionController.messageStatus = "";
		PostDistributionController.errorStatus = "";
		PostDistributionController.workflowMsgr = "";
		PostDistributionController.bookingMsg = "";
		PostDistributionController.policyNo = "";
		PostDistributionController.policyTitle = "";
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			PostDistributionService postDistServ = (PostDistributionService) APPLICATION_CONTEXT.getBean("postDistributionService");
			String action = request.getParameter("action");
			
			if("postBatchDistribution".equals(action)){
				String batchId = request.getParameter("batchId");
				System.out.println("batchId: " + batchId);
				Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
				GIISUser USER = null;
				if (null != sessionParameters){
					USER = (GIISUser) sessionParameters.get("USER");
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("batchId", batchId);
				params.put("userId", USER.getUserId());
				
				message = postDistServ.postBatchDistribution(params);
			}
				
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			session.removeAttribute("POSTING");
			request.setAttribute("message", message+del+PostParController.errorStatus+del+PostParController.policyId+del+PostParController.bookingMsg);
			this.getServletContext().getRequestDispatcher(page).forward(request, response);
		}
	}
}

