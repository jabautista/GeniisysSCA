package com.geniisys.gixx.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXDeductiblesController", urlPatterns="/GIXXDeductiblesController")
public class GIXXDeductiblesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXDeductiblesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			log.info("Initializing " + this.getClass().getSimpleName());
			//ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			//GIXXDeductiblesService gixxDeductiblesService = (GIXXDeductiblesService) APPLICATION_CONTEXT.getBean("gixxDeductiblesService");
			
			if ("getGIXXItemDeductibles".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("appUser", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				//params = gixxDeductiblesService.getGIXXDeductibles(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("itemDeductibles", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemDeductiblesTable.jsp";
				}
			} else if ("getGIXXEnDeductibles".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", request.getParameter("extractId") == null ? -1 : Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", request.getParameter("itemNo") == null ? -1 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("ACTION", ACTION);
				params = TableGridUtil.getTableGrid(request, params);
				
				//params = gixxDeductiblesService.getGIXXDeductibles(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("enItem", new JSONObject(request.getParameter("enItem")));
					request.setAttribute("enDeductibles", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/engineeringItemAddtlInfoOverlay.jsp";
				}
			}
			
		} catch (SQLException e){
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
