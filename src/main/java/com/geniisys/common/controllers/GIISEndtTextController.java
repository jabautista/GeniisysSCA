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
import com.geniisys.common.service.GIISEndtTextService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;

public class GIISEndtTextController extends BaseController{
	         
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
			GIISEndtTextService giisEndtTextService = (GIISEndtTextService) APPLICATION_CONTEXT.getBean("giisEndtTextService");
			/*end of default attributes*/
			System.out.println(ACTION);
			if ("openSearchEndtText".equals(ACTION)){	
				PAGE = "/pages/pop-ups/searchEndtText.jsp";
			}else if ("searchEndtTextModal".equals(ACTION)){
				log.info("Getting Endorsement Text Listing records.");
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if (null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giisEndtTextService.getEndtTextList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				JSONArray searchResultJSON = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				
				PAGE = "/pages/pop-ups/searchEndtTextAjaxResult.jsp";
			} else if("showGiiss104".equals(ACTION)){
				JSONObject json = giisEndtTextService.showGiiss104(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonEndtTextList", json);
					PAGE = "//pages/underwriting/fileMaintenance/general/text/endorsementText/endorsementText.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giisEndtTextService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss104".equals(ACTION)) {
				giisEndtTextService.saveGiiss104(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDelRec".equals(ACTION)){	//Gzelle 02062015
				giisEndtTextService.valDelRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
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
