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
import com.geniisys.gixx.service.GIXXPolwcService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXPolwcController", urlPatterns="/GIXXPolwcController")
public class GIXXPolwcController extends BaseController {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXPolwcController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			//GIXXPolwcService gixxPolwcService = (GIXXPolwcService) APPLICATION_CONTEXT.getBean("gixxPolwcService");
			
			if("getGIXXRelatedWcInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("ACTION", ACTION);
				params.put("extractId", request.getParameter("extractId"));
				params = TableGridUtil.getTableGrid(request, params);
				//gixxPolwcService.getGIXXRelatedWcInfo(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("gipiRelatedWcTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedWcTable.jsp";
				}
			}
			
			
		} catch (SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

	
}
