package com.geniisys.giac.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.service.GIACCollnBatchService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACCollnBatchController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACCollnBatchController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		PAGE = "/pages/genericMessage.jsp";

		try {
			if ("showDCBDateLOV".equals(ACTION)) {
				request.setAttribute("gfunFundCd", request.getParameter("gfunFundCd"));
				request.setAttribute("gibrBranchCd", request.getParameter("gibrBranchCd"));
				
				PAGE = "/pages/accounting/dcb/pop-ups/showDCBDateLOV.jsp";
			} else if ("getDCBDateListing".equals(ACTION)) {
				GIACCollnBatchService collnBatchService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				String keyword = request.getParameter("keyword");
				String gfunFundCd = request.getParameter("gfunFundCd");
				String gibrBranchCd = request.getParameter("gibrBranchCd");
				Map<String, Object> params = new HashMap<String, Object>();
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				params.put("gfunFundCd", gfunFundCd);
				params.put("gibrBranchCd", gibrBranchCd);
				params.put("keyword", keyword);
				
				searchResult = collnBatchService.getDCBDateLOV(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchDCBDateLOVAjaxResult.jsp";
			} else if ("showDCBNoLOV".equals(ACTION)) {
				request.setAttribute("gfunFundCd", request.getParameter("gfunFundCd"));
				request.setAttribute("gibrBranchCd", request.getParameter("gibrBranchCd"));
				request.setAttribute("dcbDate", request.getParameter("dcbDate"));
				request.setAttribute("dcbYear", request.getParameter("dcbYear"));
				
				PAGE = "/pages/accounting/dcb/pop-ups/showDCBNoLOV.jsp";
			} else if ("getDCBNoListing".equals(ACTION)) {
				GIACCollnBatchService collnBatchService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				String keyword = request.getParameter("keyword");
				String gfunFundCd = request.getParameter("gfunFundCd");
				String gibrBranchCd = request.getParameter("gibrBranchCd");
				String dcbDate = request.getParameter("dcbDate");
				String dcbYear = request.getParameter("dcbYear");
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				params.put("gfunFundCd", gfunFundCd);
				params.put("gibrBranchCd", gibrBranchCd);
				params.put("dcbDate", dcbDate);
				params.put("dcbYear", dcbYear);
				params.put("keyword", keyword);
				
				searchResult = collnBatchService.getDCBNoLOV(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchDCBNoLOVAjaxResult.jsp";
			} 
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
