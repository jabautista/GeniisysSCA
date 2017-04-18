/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.controllers
	File Name: GIISPrincipalSignatoryController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 23, 2011
	Description: 
*/


package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISPrincipalRes;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISCosignorResService;
import com.geniisys.common.service.GIISPrincipalSignatoryService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISPrincipalSignatoryController extends BaseController{

	private static final long serialVersionUID = -9027976613593562571L;
	private static Logger log = Logger.getLogger(GIISPrincipalSignatoryController.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPrincipalSignatoryService giisPrincipalSignatoryService = (GIISPrincipalSignatoryService) APPLICATION_CONTEXT.getBean("giisPrincipalSignatoryService");
		GIISCosignorResService giisCosignorResService = (GIISCosignorResService) APPLICATION_CONTEXT.getBean("giisCosignorResService");
		try{
			if ("showPrincipalSignatory".equals(ACTION)) {				
				JSONObject json = giisPrincipalSignatoryService.getGiiss022Principal(request, USER.getUserId());				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("assdNo", request.getParameter("assdNo"));
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("callingForm", request.getParameter("callingForm"));
					JSONObject json2 = giisPrincipalSignatoryService.getPrincipalSignatories(request, USER.getUserId());
					JSONObject json3 = giisCosignorResService.getCosignorRes(request, USER.getUserId());
					
					request.setAttribute("giiss022Principal", json);
					request.setAttribute("principalSignatoryObj", json2);
					request.setAttribute("cosignorResObj", json3);
					PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/principalSignatory/principalSignatory.jsp";
				}	
			}else if ("showPrincipalSignatoryFromBondPolicy".equalsIgnoreCase(ACTION)) {
				JSONObject json = giisPrincipalSignatoryService.getGiiss022Principal(request, USER.getUserId());	
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("assdNo", request.getParameter("assdNo"));
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("callingForm", request.getParameter("callingForm"));
					JSONObject json2 = giisPrincipalSignatoryService.getPrincipalSignatories(request, USER.getUserId());
					JSONObject json3 = giisCosignorResService.getCosignorRes(request, USER.getUserId());
					
					request.setAttribute("giiss022Principal", json);
					request.setAttribute("principalSignatoryObj", json2);
					request.setAttribute("cosignorResObj", json3);
					PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/principalSignatory/principalSignatory.jsp";
				}	
			}else if ("getPrincipalSignatory".equals(ACTION)) {
				Integer assdNo = Integer.parseInt(("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? "0" : (request.getParameter("assdNo")));
				JSONObject json = giisPrincipalSignatoryService.getPrincipalSignatories(request, USER.getUserId());
				request.setAttribute("principalSignatoryObj", json);
				//request.setAttribute("prinIdList", giisPrincipalSignatoryService.getPrinSignatoryIDList(assdNo)); --marco - 10.16.2014 - comment out; not used in page
				PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/principalSignatory/subPages/principalSignatoryTableGrid.jsp";
			}else if("refreshPrincipalSignatory".equals(ACTION)){
				JSONObject json = giisPrincipalSignatoryService.getPrincipalSignatories(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCosignorRes".equals(ACTION)) {
				Integer assdNo = Integer.parseInt(("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? "0" : (request.getParameter("assdNo")));
				JSONObject json = giisCosignorResService.getCosignorRes(request, USER.getUserId());
				request.setAttribute("cosignorResObj", json);
				//request.setAttribute("coSignIdList", giisCosignorResService.getCoSignatoryIDList(assdNo)); --marco - 10.16.2014 - comment out; not used in page
				PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/principalSignatory/subPages/cosignorResTableGrid.jsp";
			}else if("refreshCosignRes".equals(ACTION)){
				JSONObject json = giisCosignorResService.getCosignorRes(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getAssuredPrincipalResInfo".equals(ACTION)) {
				Integer assdNo = Integer.parseInt(("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? "0" : (request.getParameter("assdNo")));
				GIISPrincipalRes principalRes = giisPrincipalSignatoryService.getAssuredPrincipalResInfo(assdNo);
				StringFormatter.replaceQuotesInObject(principalRes);
				JSONObject object = new JSONObject(principalRes == null ? "" : principalRes);
				request.setAttribute("object", object == null ? "[]" : object);
				PAGE = "/pages/genericObject.jsp";
			}else if ("validatePrincipalORCoSignorId".equals(ACTION)) {
				Map<String, Object> params= FormInputUtil.getFormInputs(request);
				System.out.println(params.get("id"));
				message = giisPrincipalSignatoryService.validatePrincipalORCoSignorId(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateCTCNo".equals(ACTION)) {
				String ctcNo = request.getParameter("ctcNo") == null ?"" : request.getParameter("ctcNo");
				System.out.println("CTC NO:"+ctcNo);
				System.out.println("test " +  giisPrincipalSignatoryService.validateCTCNo(ctcNo));
				message = giisPrincipalSignatoryService.validateCTCNo(ctcNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateCTCNo2".equals(ACTION)) { //added by steven 4.23.2012
				message = giisPrincipalSignatoryService.validateCTCNo2(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("savePrincipalSignatory".equals(ACTION)) {
				giisPrincipalSignatoryService.savePrincipalSignatory(request,USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showAllGiiss022".equals(ACTION)){
				JSONObject json = giisPrincipalSignatoryService.showAllGiiss022(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} 
			
		} catch (SQLException e) {
//			message = ExceptionHandler.handleException(e, USER);
//			PAGE = "/pages/genericMessage.jsp";
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
//	private JSONArray prepareSwitchesForTableGrid(JSONArray rows) throws JSONException{
//		for (int i = 0; i < rows.length(); i++) {
//			JSONObject p = rows.getJSONObject(i);
//			rows.getJSONObject(i).put("tbgBondSw", p.getString("bondSw").equals("Y") ? true : false);
//			rows.getJSONObject(i).put("tbgIndemSw", p.getString("indemSw").equals("Y") ? true : false);
//			rows.getJSONObject(i).put("tbgAckSw", p.getString("ackSw").equals("Y") ? true : false);
//			rows.getJSONObject(i).put("tbgCertSw", p.getString("certSw").equals("Y") ? true : false);
//			rows.getJSONObject(i).put("tbgRiSw", p.getString("riSw").equals("Y") ? true : false);
//		}
//		return rows;
//	}
//	private JSONArray prepareCustomFieldsForTableGrid(JSONArray rows, String table) throws JSONException{
//		for (int i = 0; i < rows.length(); i++) {
//			JSONObject p = rows.getJSONObject(i);
//			if ("PrincipalSignatory".equals(table)){
//				rows.getJSONObject(i).put("idNumber", p.getString("controlTypeDesc") + (p.get("resCert").equals(null) ? "" : "-" + p.getString("resCert")));				
//			} else if ("CoSignatory".equals(table)){
//				rows.getJSONObject(i).put("idNumber", p.getString("controlTypeDesc") + (p.get("cosignResNo").equals(null) ? "" : "-" + p.getString("cosignResNo")));
//			}
//		}
//		return rows;
//	}
}
