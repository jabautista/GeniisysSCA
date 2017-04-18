package com.geniisys.common.controllers;

import java.io.IOException;
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
import com.geniisys.common.service.GIISReinsurerService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISReinsurerController extends BaseController {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIISReinsurerController.class);
	
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
		PAGE = "/pages/genericMessage.jsp";		
		try {
			if ("openSearchReinsurer".equals(ACTION)) {				
				PAGE = "/pages/pop-ups/searchReinsurer.jsp";
			} else if ("getReinsurerListing".equals(ACTION)) {				
				String keyword = request.getParameter("keyword");				
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
				searchResult = giisReinsurerService.getGiisReinsurerList(pageNo, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());				
				PAGE = "/pages/pop-ups/searchReinsurerAjaxResult.jsp";
			} else if("getReinsurerVatRt".equals(ACTION)) {				
				message = giisReinsurerService.getInputVatRate(request.getParameter("riCd"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("getReinsurerByRiCd".equals(ACTION)){				
				Integer riCd = Integer.parseInt(request.getParameter("riCd") == null || "".equals(request.getParameter("riCd"))? null : request.getParameter("riCd"));
				JSONObject reinsurer = new JSONObject(StringFormatter.escapeHTMLInObject(giisReinsurerService.getGiisReinsurerByRiCd(riCd)));
				request.setAttribute("object", reinsurer == null ? "[]" : reinsurer);
				PAGE = "/pages/genericObject.jsp";
			}else if("showGiiss030".equals(ACTION)){	
				JSONObject json = giisReinsurerService.showGiiss030(request);
				request.setAttribute("riBaseList", giisReinsurerService.getRIBaseList());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonReinsurerList", json);
					PAGE = "/pages/underwriting/fileMaintenance/reinsurance/reinsurer/reinsurer.jsp";		
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("validateGIISS030MobileNo".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisReinsurerService.validateGIISS030MobileNo(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIISS030MaxRiCd".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();			
				params = giisReinsurerService.getGIISS030MaxRiCd();	
				JSONObject result = new JSONObject(params);
				System.out.println(result);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valAddRec".equals(ACTION)){
				giisReinsurerService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if("saveGiiss030".equals(ACTION)){
				giisReinsurerService.saveGiiss030(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			}else if("getAllReinsurer".equals(ACTION)){		
				JSONObject json = giisReinsurerService.getAllReinsurer(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";	
			}
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
