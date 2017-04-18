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
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.service.GIACBranchService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACBranchController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** The logger */
	private static Logger log = Logger.getLogger(GIACBranchController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader
				.getServletContext(getServletContext());

		PAGE = "/pages/genericMessage.jsp";

		try {
			if ("showCloseDCBBranchCdLOV".equals(ACTION)) {
				request.setAttribute("gfunFundCd",
						request.getParameter("gfunFundCd"));
				request.setAttribute("moduleId",
						request.getParameter("moduleId"));

				PAGE = "/pages/accounting/dcb/pop-ups/showBranchCdLOV.jsp";
			} else if ("getCloseDCBBranchCdListing".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT
						.getBean("giacBranchService");
				String keyword = request.getParameter("keyword");
				String gfunFundCd = request.getParameter("gfunFundCd");
				String controlModule = request.getParameter("moduleId");
				Map<String, Object> params = new HashMap<String, Object>();

				if (null == keyword) {
					keyword = "";
				}

				PaginatedList searchResult = null;
				Integer pageNo = 0;

				if (null != request.getParameter("pageNo")) {
					if (!"undefined".equals(request.getParameter("pageNo"))) {
						pageNo = new Integer(request.getParameter("pageNo")) - 1;
					}
				}

				params.put("gfunFundCd", gfunFundCd);
				params.put("controlModule", controlModule);
				params.put("keyword", keyword);
				params.put("appUser", USER.getUserId());

				System.out.println("fundCd: " + gfunFundCd);
				System.out.println("controlModule: " + controlModule);
				System.out.println("keyword: " + keyword);
				System.out.println("appUser: " + USER.getUserId());
				searchResult = giacBranchService.getBranchCdLOV(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex() + 1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());

				PAGE = "/pages/accounting/dcb/pop-ups/searchBranchCdLOVAjaxResult.jsp";
			} else if ("showLOVBranches".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT
						.getBean("giacBranchService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage",
						Integer.parseInt(request.getParameter("page")));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("keyword", request.getParameter("keyword"));
				giacBranchService.getBranchLOV(params);

				// if(request.getParameter("refresh") != null &&
				// request.getParameter("refresh").equals("1")) {
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				// } else {
				// request.setAttribute("giacBranchLOV", new
				// JSONObject(params));
				// PAGE =
				// "/pages/accounting/cashReceipts/utilities/lovBranches.jsp";
				// }
			} else if("validateGIACBranchCd".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT
						.getBean("giacBranchService");
				request.setAttribute("object", giacBranchService.validateGIACBranchCd(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIACS178BranchCd".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT
						.getBean("giacBranchService");
				request.setAttribute("object", giacBranchService.validateGIACS178BranchCd(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			} else if("showGiacs303".equals(ACTION)){
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				JSONObject result = giacBranchService.showGiacs303(request, USER.getUserId());
				
				if(request.getParameter("fundCd") == null) {
					request.setAttribute("jsonGIACS303", result);
					PAGE = "/pages/accounting/maintenance/branches/branches.jsp";
				} else {
					message = result.toString();
					PAGE = "/pages/genericMessage.jsp";
				}				
			} else if("valDeleteBranch".equals(ACTION)){
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				giacBranchService.valDeleteBranch(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiacs303".equals(ACTION)){
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				giacBranchService.saveGiacs303(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateBranchCdInAcctrans".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				giacBranchService.validateBranchCdInAcctrans(request, USER.getUserId());
				PAGE = "/pages/genericObject.jsp";
			}
			
			
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
