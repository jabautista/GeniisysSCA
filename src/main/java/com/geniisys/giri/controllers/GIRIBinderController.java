package com.geniisys.giri.controllers;

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
import com.geniisys.giri.service.GIRIBinderService;
import com.seer.framework.util.ApplicationContextReader;

public class GIRIBinderController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIRIBinderController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIRIBinderService giriBinderService = (GIRIBinderService) APPLICATION_CONTEXT.getBean("giriBinderService");
		try{
			
			if ("saveBinderDtlsGiris026".equals(ACTION)){
				giriBinderService.updateGiriBinderGiris026(request.getParameter("modifiedRows"), USER.getUserId());
				
				message = "SUCCESS";
			}else if ("checkIfBinderExists".equals(ACTION)){
				String parId = request.getParameter("parId");
				message = giriBinderService.checkIfBinderExists(parId);
				log.info("Binder exists? " +message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateRevSwRevDate".equals(ACTION)){
				log.info("Updating binder info...");
				giriBinderService.updateRevSwRevDate(request.getParameter("parId"));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRiAgreementBond".equals(ACTION)){
				PAGE = "/pages/underwriting/reInsurance/printFrps/reinsuranceAgreementBond.jsp";
			}else if("updateAcceptanceInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("riEndtNo", request.getParameter("riEndtNo"));
				params.put("riPolicyNo", request.getParameter("riPolicyNo"));
				params.put("riBinderNo", request.getParameter("riBinderNo"));
				params.put("origTSIAmt", request.getParameter("origTSIAmount"));
				params.put("origPremAmt", request.getParameter("origPremAmount"));
				params.put("remarks", request.getParameter("remarks"));
				params.put("userId", USER.getUserId());
				giriBinderService.updateAcceptanceInfo(params);
				message = "SUCCESS";
			}else if("getBinders".equals(ACTION)){
				List<Map<String, Object>> binders = giriBinderService.getBinders(Integer.parseInt(request.getParameter("policyId")));
				System.out.println("SIZE : " + binders.size());
				request.setAttribute("object", new JSONArray(binders));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateBinderPrintDateCnt".equals(ACTION)){
				giriBinderService.updateBinderPrintDateCnt(Integer.parseInt(request.getParameter("fnlBinderId")));
			}else if("updateBinderStatusGIUTS012".equals(ACTION)){ // Added by J. Diago 08.16.2013
				message = giriBinderService.updateBinderStatusGIUTS012(request, USER.getUserId());
				PAGE = "/pages/genericObject.jsp";
			}else if("showViewRIPlacements".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giriBinderService.getRIPlacements(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					PAGE = "/pages/underwriting/riInquiries/viewRIPlacements/viewRIPlacements.jsp";
				}
			}else if("getPolicyFrps".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giriBinderService.getPolicyFrps(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("showViewBinder".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giriBinderService.getBinderPerils(request);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					PAGE = "/pages/underwriting/riInquiries/viewBinder/viewBinder.jsp";
				}
			}else if("showBinderDetails".equals(ACTION)){
				PAGE = "/pages/underwriting/riInquiries/viewBinder/popups/binderAdditionalInfo.jsp";
			}else if("getBinder".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giriBinderService.getBinder(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			} else if("getOutwardRiList".equals(ACTION)){
				JSONObject json = giriBinderService.getOutwardRiList(request, USER.getUserId());
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("binderList", json);
					PAGE = "/pages/underwriting/riInquiries/viewOutwardRI/viewOutwardRI.jsp";
				}				
			}else if("showPolWithPremPayments".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giriBinderService.showPolWithPremPayments(request, USER);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					PAGE = "/pages/underwriting/riInquiries/polWithPremPayments/polWithPremPayments.jsp";
				}
			}else if("showGiris055".equals(ACTION)){
				JSONObject json = giriBinderService.showGiris055(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					request.setAttribute("jsonGiris055BinderStatList", json);
					PAGE = "/pages/underwriting/riInquiries/viewBinderStatus/viewBinderStatus.jsp";
				}
			}else if("showDistPerilOverLay".equals(ACTION)){
				JSONObject json = giriBinderService.getDistPerilOverlayDtls(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBinderDistPerilDtls", json);
					PAGE = "/pages/underwriting/riInquiries/viewBinderStatus/distByPerilOverlay.jsp";			
				}
				request.setAttribute("fnlBinderId", request.getParameter("fnlBinderId"));
			}else if("showInwardRIMenu".equals(ACTION)){
				JSONObject json = giriBinderService.showInwardRIMenu(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("binderList", json);
					PAGE = "/pages/underwriting/riInquiries/viewInwardRI/viewInwardRI.jsp";
				}				
			}else if("checkBinderAccess".equals(ACTION)){
				giriBinderService.checkBinderAccess(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkRIPlacementAccess".equals(ACTION)){ //benjo 07.20.2015 UCPBGEN-SR-19626
				giriBinderService.checkRIPlacementAccess(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
