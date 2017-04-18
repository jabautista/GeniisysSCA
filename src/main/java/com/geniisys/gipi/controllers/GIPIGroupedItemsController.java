package com.geniisys.gipi.controllers;

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
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.geniisys.gipi.service.GIPIGroupedItemsService;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIGroupedItemsController extends BaseController {	
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIGroupedItemsController.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			/* default attributes */			
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			if("getGroupedItemsForEndt".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);				
				
				request.setAttribute("object", new JSONArray(groupedItemsService.getGIPIGroupedItemsForEndt(params)));
				message = "SUCCESS";
				PAGE = "/pages/genericObject.jsp";
			}else if("checkIfGroupItemIsZeroOutOrNegated".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parameters", request.getParameter("parameters"));
				
				message = groupedItemsService.checkIfGroupItemIsZeroOutOrNegated(params);				
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkIfPrincipalEnrollee".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				
				message = groupedItemsService.checkIfPrincipalEnrollee(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("negateDeleteItemGroup".equals(ACTION)){
				GIPIWItmperlGroupedService itmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("userId", USER.getUserId());
				params.put("request", request);
				
				itmperlGroupedService.negateDeleteItemGroup(params);				
				
				params.put("gipiWItmperlGrouped", new JSONArray((List<GIPIWItmperlGrouped>)params.get("groupGIPIWItmperlGrouped")));
				params.put("gipiWItmperl", new JSONArray((List<GIPIWItemPeril>) params.get("gipiWItmPerl")));
				request.setAttribute("object", new JSONObject(params));
				message = "SUCCESS";
				PAGE = "/pages/genericObject.jsp";				
			}else if("untagDeleteItemGroup".equals(ACTION)){
				GIPIWItmperlGroupedService itmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("request", request);
				
				itmperlGroupedService.untagDeleteItemGroup(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if("checkIfBackEndt".equals(ACTION)){
				GIPIWItmperlGroupedService itmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("request", request);				
				
				message = itmperlGroupedService.checkIfBackEndt(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCasualtyGroupedItems".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params = groupedItemsService.getCasualtyGroupedItems(params);

				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("casualtyGroupedItems", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/casualtyGroupedItemsTable.jsp";
				}
				
			}else if("getAccidentGroupedItems".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				JSONObject json = groupedItemsService.getAccidentGroupedItems(request);

				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("accidentGroupedItems", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentGroupedItemsTable.jsp";
				}
				
			}else if("showGipis212".equals(ACTION)){ // Added by J. Diago 10.08.2013
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				JSONObject json = groupedItemsService.showGipis212(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGroupedItemInfo", json);
					PAGE = "/pages/underwriting/policyInquiries/paInquiries/viewEnrolleeInformation/viewEnrolleeInformation.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGipis212GroupedItemDtl".equals(ACTION)){ // Added by J. Diago 10.08.2013
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				JSONObject json = groupedItemsService.showGipis212GroupedItemDtl(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCoveragesOverlay".equals(ACTION)){
				GIPIGroupedItemsService groupedItemsService = (GIPIGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiGroupedItemsService");
				JSONObject json = groupedItemsService.getCoverageDtls(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCoverageDtls", json);
					PAGE = "/pages/underwriting/policyInquiries/paInquiries/viewEnrolleeInformation/enrolleeCoverageOverlay.jsp";			
				}
				request.setAttribute("policyId", request.getParameter("policyId"));
				request.setAttribute("groupedItemNo", request.getParameter("groupedItemNo"));
				request.setAttribute("itemNo", request.getParameter("itemNo"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
	}

}