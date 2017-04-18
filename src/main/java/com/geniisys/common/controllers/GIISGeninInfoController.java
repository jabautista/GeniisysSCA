package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISGeninInfoService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISGeninInfoController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(this.getClass().getSimpleName());
	
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			if ("openSearchInitInfo".equals(ACTION)){
				PAGE = "/pages/pop-ups/searchInitInfo.jsp";
			}else if ("searchInitInfoModal".equals(ACTION)){
				log.info("Getting Initial Info Listing records.");
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giisGeninInfoService.getInitInfoList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				StringFormatter.escapeHTMLJavascriptInList(searchResult);
				JSONArray searchResultJSON = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				
				PAGE = "/pages/pop-ups/searchInitInfoAjaxResult.jsp";
			}else if ("openSearchGenInfo".equals(ACTION)){
				PAGE = "/pages/pop-ups/searchGenInfo.jsp";
			}else if ("searchGenInfoModal".equals(ACTION)){
				log.info("Getting Initial Info Listing records.");
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giisGeninInfoService.getGenInfoList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				StringFormatter.escapeHTMLJavascriptInList(searchResult); // irwin - 10.22.2012
				JSONArray searchResultJSON = new JSONArray( searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				
				PAGE = "/pages/pop-ups/searchGenInfoAjaxResult.jsp";
				
			}else if("showGiiss180".equals(ACTION)){
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				JSONObject json = giisGeninInfoService.showGiiss180(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGeninInfoList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/text/initialGenInfo/initialGenInfo.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRec".equals(ACTION)){
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				giisGeninInfoService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				giisGeninInfoService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss180".equals(ACTION)) {
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				giisGeninInfoService.saveGiiss180(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("allowUpdateGiiss180".equals(ACTION)){
				GIISGeninInfoService giisGeninInfoService = (GIISGeninInfoService) APPLICATION_CONTEXT.getBean("giisGeninInfoService");
				message = giisGeninInfoService.allowUpdate(request.getParameter("geninInfoCd"));
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (SQLException e) {
			/*PAGE = "/pages/genericMessage.jsp";
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);*/
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
	}

}
