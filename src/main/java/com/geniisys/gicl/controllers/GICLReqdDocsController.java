/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLReqdDocsController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 5, 2011
	Description: 
*/

package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClmDocsService;
import com.geniisys.gicl.service.GICLReqdDocsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GICLReqdDocsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7346530649578673213L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLReqdDocsService giclReqdDocsService = (GICLReqdDocsService) APPLICATION_CONTEXT.getBean("giclReqdDocsService");
		
		message = "SUCCESS";
		PAGE = "/pages/genericMessage.jsp";
		
		try {
			if (ACTION.equals("getDocumentTableGridListing")) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("ACTION", ACTION);				
				Map<String, Object> documentTableGrid = TableGridUtil.getTableGrid(request, params);
				documentTableGrid.remove("from"); // added by: Nica 05.10.2013 - to remove pagination
				documentTableGrid.remove("to");
				documentTableGrid.remove("pages");
				JSONObject json = new JSONObject(documentTableGrid);
				System.out.println("Refresh: "+request.getParameter("refresh"));
				
				if ("1".equals(request.getParameter("refresh"))) {
					message = json.toString();
				} else {
					LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
					GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
					Map<String, Object>lovs = new HashMap<String, Object>();
					lovs.put("allIssSource", lovHelper.getList(LOVHelper.ALL_ISSUE_SOURCE));
					lovs.put("allUsers", userService.getGiisUserAllList());
					request.setAttribute("objLovs", new JSONObject(lovs));
					request.setAttribute("docsTableGrid", json);
					request.setAttribute("claimSw", USER.getClaimSw());
					request.setAttribute("systemDate", new java.text.SimpleDateFormat("MM-dd-yyyy").format(new java.util.Date()));
					PAGE = "/pages/claims/claimRequiredDocs/claimRequiredDocs.jsp";
				}
			}else if (ACTION.equals("getDocsList")) {
				GICLClmDocsService docsService = (GICLClmDocsService) APPLICATION_CONTEXT.getBean("giclClmDocsService");
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("ACTION", "getClmDocsList");
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("notIn", request.getParameter("notIn"));
				params.put("findText", StringEscapeUtils.unescapeHtml(request.getParameter("findText")));
				/*List<GICLClmDocs>docsList = docsService.getClmDocsList(params);
				StringFormatter.escapeHTMLInList((docsList));*/
				//request.setAttribute("objDocsList",new JSONArray(docsList));
				
				Map<String, Object> docsList = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(docsList));
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("objDocsList", json);
					PAGE = "/pages/claims/claimRequiredDocs/subPages/claimDocsList.jsp";
				}
				
				
				/*if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/claims/claimRequiredDocs/subPages/claimDocsTg.jsp";
				}else{
					PAGE = "/pages/claims/claimRequiredDocs/subPages/claimDocsList.jsp";
				}
				*/
			}else if ("saveClaimDocs".equals(ACTION)) {
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				giclReqdDocsService.saveClaimDocs(params);
			}else if ("validateClmReqDocs".equals(ACTION)){
				message = giclReqdDocsService.validateClmReqDocs(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260ReqDocumentsListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("ACTION", "getDocumentTableGridListing");				
				Map<String, Object> documentTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(documentTableGrid);
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonReqDocuments", json);
					PAGE = "/pages/claims/inquiry/claimInformation/reqdDocuments/requiredDocuments.jsp";
				}
			}
			
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

}
