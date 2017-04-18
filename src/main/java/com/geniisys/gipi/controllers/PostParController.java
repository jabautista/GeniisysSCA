package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.PostParService;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.seer.framework.util.ApplicationContextReader;


public class PostParController extends javax.servlet.http.HttpServlet
	implements javax.servlet.Servlet{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PostParController.class);
	public static String percentStatus = "0%";
	public static String messageStatus = "";
	public static String errorStatus = "";
	public static String policyId = "";
	public static String workflowMsgr = "";
	public static String userId = "";
	public static String bookingMsg = "";
	private String del = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
	
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		System.out.println(PostParController.percentStatus);
		out.print(PostParController.percentStatus+del+PostParController.messageStatus+del+PostParController.errorStatus+del+PostParController.bookingMsg);
		out.close();	
	}	
	
	@Override
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String message = "Posting of record Successful.";
		String page = "/pages/genericMessage.jsp";
		PostParController.percentStatus = "0%";
		PostParController.messageStatus = "";
		PostParController.errorStatus = "";
		PostParController.workflowMsgr = "";
		PostParController.bookingMsg = "";
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			PostParService postParService = (PostParService) APPLICATION_CONTEXT.getBean("postParService");
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
			System.out.println("PARID: " +request.getParameter("parId"));
			int parId = Integer.parseInt(("".equals(request.getParameter("parId")) || request.getParameter("parId") == null) ? "0" : request.getParameter("parId"));
			String action = request.getParameter("action");
			String backEndt = request.getParameter("backEndt");
			
			log.info("PARID: " + parId);
			log.info("ACTION: " + action);
			log.info("BACKENDT: " + backEndt);
		
			if (parId == 0) {
				message = "PAR No. is empty";
				PostParController.errorStatus = message;
				PostParController.percentStatus = "0%";
			} else {
				if ("postPar".equals(action)) {
					log.info("Post PAR...");
					session.setAttribute("POSTING", "POSTING");
					GIPIPARList gipiParList = null;
					gipiParList = gipiParService.getGIPIPARDetails(parId);
					
					Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
					GIISUser USER = null;
					if (null != sessionParameters){
						USER = (GIISUser) sessionParameters.get("USER");
					}
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId",gipiParList.getParId());
					params.put("lineCd",gipiParList.getLineCd());
					params.put("issCd",gipiParList.getIssCd());
					params.put("userId",USER.getUserId());
					params.put("backEndt", backEndt);
					params.put("credBranchConf", request.getParameter("credBranchConf"));
					params.put("chkDfltIntmSw", request.getParameter("chkDfltIntmSw")); //benjo 09.07.2016 SR-5604
					if (request.getParameterMap().containsKey("authenticateCOC")){ // modified by Bert 06.17.2015 - COCAF Web Service Plugin
						params.put("authenticateCOC", request.getParameter("authenticateCOC")); // added by: Nica 10.30.2012 - for COC authentication
						params.put("useDefaultTin", request.getParameter("useDefaultTin"));
					}
					log.info("POST PARAMS :" + params);
					message = postParService.postPar(params);
					
					if ((!PostParController.workflowMsgr.equals(""))||(PostParController.workflowMsgr.equals(null))){
						Runtime rt=Runtime.getRuntime();
						//rt.exec("C:\\WINDOWS\\NOTEPAD.exe");
						rt.exec(PostParController.workflowMsgr);
					}	
				}else if("validateMC".equals(action)){
					log.info("Validating MC before posting...");
					postParService.validateMC(request);
					page = "/pages/genericObject.jsp";
				}else if("postFrps".equals(action)){
					GIUWPolDistService giuwPolDist = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");//+env);
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("lineCd", request.getParameter("lineCd")); 
					params.put("sublineCd", request.getParameter("sublineCd")); 
					params.put("issCd", request.getParameter("issCd")); 
					params.put("issueYy", request.getParameter("issueYy")); 
					params.put("polSeqNo", request.getParameter("polSeqNo")); 
					params.put("renewNo", request.getParameter("renewNo")); 
					params.put("frpsYy", request.getParameter("frpsYy")); 
					params.put("frpsSeqNo", request.getParameter("frpsSeqNo")); 
					params.put("distNo", request.getParameter("distNo")); 
					params.put("distSeqNo", request.getParameter("distSeqNo")); 
					params.put("parPolicyId", request.getParameter("parPolicyId")); 
					
					String postedMessage = giuwPolDist.checkIfPosted(Integer.parseInt(request.getParameter("distNo")));
					//checkIfPosted
					if (postedMessage.equals("Y")){
						Debug.print("postFrps params: " + params);
						log.info("Posting FRPS...");
						session.setAttribute("POSTING", "POSTING");
						
						Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
						
						GIISUser USER = null;
						if (null != sessionParameters){
							USER = (GIISUser) sessionParameters.get("USER");
						}
						
						params.put("userId", USER.getUserId());
						params.put("appUser", USER.getUserId());
						
						message = postParService.postFrps(params);
					}else{
						message = postedMessage;
					}
					
				}else if ("postPackPar".equals(action)) {
					log.info("Post Pack PAR...");
					List<GIPIPARList> gipiParList = gipiParService.getPackPolicyList(parId);
					
					Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
					GIISUser USER = null;
					if (null != sessionParameters){
						USER = (GIISUser) sessionParameters.get("USER");
					}
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("packParId", parId);
					params.put("gipiParList", gipiParList);
					params.put("userId",USER.getUserId());
					params.put("backEndt", backEndt);
					params.put("changeStat", request.getParameter("changeStat"));
					params.put("credBranchConf", request.getParameter("credBranchConf")); // andrew - 08.08.2011
					params.put("chkDfltIntmSw", request.getParameter("chkDfltIntmSw")); //benjo 09.07.2016 SR-5604
					if (request.getParameterMap().containsKey("authenticateCOC")){ // modified by Bert 06.17.2015 - COCAF Web Service Plugin
						params.put("authenticateCOC", request.getParameter("authenticateCOC")); // added by: Nica 10.30.2012 - for COC authentication
						params.put("useDefaultTin", request.getParameter("useDefaultTin"));
					}
					log.info("POST PARAMS :" + params);
					message = postParService.postpackPar(params);
					
					if ((!PostParController.workflowMsgr.equals(""))||(PostParController.workflowMsgr.equals(null))){
						Runtime rt=Runtime.getRuntime();
						rt.exec(PostParController.workflowMsgr);
					}
				}else if("getParCancellationMsg".equals(action)){
					log.info("Getting Cancellation messages...");
					request.setAttribute("object", postParService.getParCancellationMsg(request));
					page = "/pages/genericObject.jsp";
				}	
			}	
		} catch(SQLException e){ //added edgar for handling custom errors 12/12/2014
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e);
			}
			page = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e);
			page = "/pages/genericMessage.jsp";
		} finally {
			session.removeAttribute("POSTING");
			request.setAttribute("message", message+del+PostParController.errorStatus+del+PostParController.policyId+del+PostParController.bookingMsg);
			this.getServletContext().getRequestDispatcher(page).forward(request, response);
		}
	}
}
