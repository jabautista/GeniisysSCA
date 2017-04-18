package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACDCBUserService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACOtherBranchORController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACOtherBranchORController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
		HttpServletResponse response, GIISUser USER, String ACTION,
		HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing Other Branch OR...");
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			GIACBranchService gbService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
			if("showBranchOR".equals(ACTION)) {
				
				/*Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("currentPage", page);
				grid = gbService.getOtherBranchOR("GIACS156", USER.getUserId(), grid);
				request.setAttribute("branchAccess", request.getParameter("otherBranchAccess"));
				request.setAttribute("branchORTableGrid", new JSONObject(grid));
				PAGE="/pages/accounting/cashReceipts/otherBranchOR/otherBranchOR.jsp";*/
				
				/*Modified by pol cruz, 10.14.2013 for GIACS156*/
				
				JSONObject jsonGIACS156Branches = gbService.getGIACS156Branches(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIACS156Branches.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("branchORTableGrid", jsonGIACS156Branches);
					PAGE="/pages/accounting/cashReceipts/otherBranchOR/otherBranchOR.jsp";
					request.setAttribute("branchAccess", request.getParameter("otherBranchAccess"));
				}
				
				
			} else if ("refreshBranchOR".equals(ACTION)) {
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("currentPage", page);
				grid = gbService.getOtherBranchOR("GIACS156", USER.getUserId(), grid);
				JSONObject json = new JSONObject(grid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateBranchOR".equals(ACTION)) {
				GIACDCBUserService dcbUserServ = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService");
				//String tranSource = request.getParameter("tranSource");
				//String opReqTag = request.getParameter("opReqTag");
				String orTag = request.getParameter("orTag");
				//String opTag = request.getParameter("orCancellation");
				String orCancel = request.getParameter("orCancellation");
				String fundCd = request.getParameter("selFundCd");
				String branchCd = request.getParameter("selBranchCd");

				Map<String, Object> params = dcbUserServ.getValidUSerInfo(orTag, orCancel, fundCd, branchCd, USER.getUserId()); 
				params.put("orCancellation", orCancel);
				params.put("orTag", orTag);
				request.setAttribute("object", new JSONObject(params));
				System.out.println("validateBranchOR - "+params);
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
}
