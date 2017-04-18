package com.geniisys.giac.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACReinstatedOrService;
import com.geniisys.giac.service.GIACSpoiledOrService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;

public class GIACSpoiledOrController extends BaseController {

	private static final long serialVersionUID = -4613338477745012275L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACSpoiledOrService spoiledOrService = (GIACSpoiledOrService) APPLICATION_CONTEXT.getBean("giacSpoiledOrService");
		
		try {
			if("showEnterSpoiledOR".equals(ACTION)){
				GIACBranchService branchDetailService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");				
				GIACBranch  branchDetails = branchDetailService.getBranchDetails();
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				request.setAttribute("branchDetails", branchDetails);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", Integer.parseInt((request.getParameter("page") == null ? "1" : request.getParameter("page"))));
				params.put("userId", request.getParameter("userId"));
				params.put("fundCd", branchDetails.getGfunFundCd());
				params.put("branchCd", branchDetails.getBranchCd());
				spoiledOrService.getGIACSpoiledOrListing(params);
				request.setAttribute("spoiledOrListing", new JSONObject(params));
				
				Map<String, Object> userDtls =  new HashMap<String, Object>();
				userDtls.put("user", USER.getUserId());
				userDtls.put("funcCode", "RO");
				userDtls.put("moduleName", "GIACS037");
				request.setAttribute("deleteAccess", giacModulesService.validateUserFunc(userDtls));
				
				PAGE = "/pages/accounting/cashReceipts/utilities/enterSpoiledOr.jsp";
			} else if ("refreshSpoiledOR".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				spoiledOrService.getGIACSpoiledOrListing(params);
				JSONObject json = new JSONObject(params);				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("refreshSpoiledOR2".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", 1);
				params.put("filter", request.getParameter("objFilter"));
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				spoiledOrService.getGIACSpoiledOrListing(params);
				//JSONObject json = new JSONObject(params);	
				request.setAttribute("spoiledOrListing", new JSONObject(params));
		
				PAGE = "/pages/accounting/cashReceipts/utilities/spoiledOrTableListing.jsp";
			} else if ("reinstateOr".equals(ACTION)){
				GIACReinstatedOrService reinstatedOrService = (GIACReinstatedOrService) APPLICATION_CONTEXT.getBean("giacReinstatedOrService");	
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
				DateFormat sdf2 = new SimpleDateFormat("MM-dd-yyyy");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", Integer.parseInt(request.getParameter("orNo")));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("spoilDate", sdf.parse(request.getParameter("spoilDate")));
				params.put("prevOrDate", request.getParameter("prevOrDate").equals("") ? null : sdf2.parseObject(request.getParameter("prevOrDate")));
				params.put("prevTranId", request.getParameter("prevTranId").equals("") ? null : Integer.parseInt(request.getParameter("prevTranId")));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("message", request.getParameter("message"));
				params.put("appUser", USER.getUserId());
				
				System.out.println("REINSTATE PARAMETERS: " + params);
				
				String reinstateMsg = reinstatedOrService.reinstateOr(params);
				Debug.print("AFTER insert: " + params);
				message = reinstateMsg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("printReinstated".equals(ACTION)){
				
				PAGE = "/pages/accounting/cashReceipts/utilities/pop-ups/printReinstated.jsp";
			}else if ("saveSpoiledOrDtls".equals(ACTION)) {
				
				spoiledOrService.saveSpoiledOrDtls(request.getParameter("parameter"), USER.getUserId());
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateSpoiledOr".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", request.getParameter("orNo"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				Debug.print("VALIDATE SPOILED OR PARAMS: " + params);
				
				String spoiledMsg = spoiledOrService.validateSpoiledOr(params);
				System.out.println("VALIDATE SPOILED OR MESSAGE: " + spoiledMsg);
				message = spoiledMsg;
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
