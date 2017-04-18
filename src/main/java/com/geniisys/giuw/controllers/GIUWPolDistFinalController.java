package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.geniisys.giuw.service.GIUWPolDistFinalService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIUWPolDistFinalController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIUWPolDistFinalController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIUWPolDistFinalService giuwPolDistFinalServ = (GIUWPolDistFinalService) APPLICATION_CONTEXT.getBean("giuwPolDistFinalService");
		
		try{
			if("createItemsGIUWS010".equals(ACTION)){
				Map<String,Object> params = new HashMap<String, Object>();
				Integer distNo = request.getParameter("distNo")== null ? null : Integer.parseInt(request.getParameter("distNo"));
				Integer policyId = request.getParameter("policyId")== null ? null : Integer.parseInt(request.getParameter("policyId"));
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				String packPolFlag = request.getParameter("packPolFlag");
				String delDistTable = request.getParameter("delDistTable");
				
				params.put("distNo", distNo);
				params.put("policyId", policyId);
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", issCd);
				params.put("packPolFlag", packPolFlag);
				params.put("delDistTable", delDistTable);
				params.put("userId", USER.getUserId());
				
				giuwPolDistFinalServ.createItemsGiuws010(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("compareGIPIItemItmperilGIUWS010".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer policyId = request.getParameter("policyId")== null ? null : Integer.parseInt(request.getParameter("policyId"));
				String packPolFlag = request.getParameter("packPolFlag");
				String lineCd = request.getParameter("lineCd");
				params.put("policyId", policyId);
				params.put("packPolFlag", packPolFlag);
				params.put("lineCd", lineCd);
				Debug.print(params);
				params = giuwPolDistFinalServ.compareGIPIItemItmperil(params);
				
				message = (String) params.get("vMsgAlert");
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveSetUpGroupsForDistrFinalItem".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer distNo = request.getParameter("distNo")== null ? null : Integer.parseInt(request.getParameter("distNo"));
				Integer policyId = request.getParameter("policyId")== null ? null : Integer.parseInt(request.getParameter("policyId"));
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				String packPolFlag = request.getParameter("packPolFlag");
				Debug.print(params);
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				List<GIUWWitemds> giuwWitemdsList =  (List<GIUWWitemds>) JSONUtil.prepareObjectListFromJSON(setRows, USER.getUserId(), GIUWWitemds.class);
				
				params.put("distNo", distNo);
				params.put("policyId", policyId);
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", issCd);
				params.put("packPolFlag", packPolFlag);
				params.put("userId", USER.getUserId());
				params.put("setRows", giuwWitemdsList);
				
				giuwPolDistFinalServ.saveSetUpGroupsForDistrFinalItem(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("compareGIPIItemItmperilGIUWS018".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				giuwPolDistFinalServ.compareGIPIItemItmperilGiuws018(params);
				message = (String) params.get("vMsgAlert");
				PAGE = "/pages/genericMessage.jsp";
			}else if("createItemsGIUWS018".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("USER", USER);
				giuwPolDistFinalServ.createItemsGiuws018(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveSetUpPerilGrpDistFinal".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params. put("request", request);
				params.put("USER", USER);
				giuwPolDistFinalServ.saveSetUpPerilGrpDistFinal(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPostBatchDistOverlay".equals(ACTION)){
				request.setAttribute("title", "Policy No.");
				request.setAttribute("policyNo", "01-0263598");
				PAGE = "/pages/underwriting/distribution/batchDistribution/postBatchDistOverlay.jsp"; 
			}else if("checkPostedBinder".equals(ACTION)){  //added action for checking Posted binders edgar 09/11/2014
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = giuwPolDistFinalServ.checkPostedBinder(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}	else if("validateSetupDistPerAction".equals(ACTION)){  //added action by jhing for validating distribution related issues during setup of distribution ( giuws010, giuws018) [ FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871 ]
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				String selectedAction = new String ((request.getParameter("selectedAction") == null) ? "" : (request.getParameter("selectedAction").isEmpty() ? "" : request.getParameter("selectedAction")));
				String moduleId = new String ((request.getParameter("moduleId") == null) ? "" : (request.getParameter("moduleId").isEmpty() ? "" : request.getParameter("moduleId"))); 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("selectedAction", selectedAction);
				params.put("moduleId", moduleId);
				giuwPolDistFinalServ.validateSetupDistPerAction(params);
				message = "SUCCESS";	
				PAGE = "/pages/genericMessage.jsp";
			}  
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){   // added by jhing 12.05.2014
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
