/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLAviationDtlController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Oct 5, 2011
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
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
import com.geniisys.gicl.service.GICLAviationDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLAviationDtlController", urlPatterns={"/GICLAviationDtlController"})
public class GICLAviationDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6044846031205658040L;
	private Logger log = Logger.getLogger(GICLAviationDtlController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing :"+this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLAviationDtlService giclAviationDtlService = (GICLAviationDtlService) APPLICATION_CONTEXT.getBean("giclAviationDtlService");
		log.info("INITIALIZING "+this.getClass().getSimpleName());
		try{
			if ("getAviationItemDtl".equals(ACTION)) {
				giclAviationDtlService.getGICLAviationDtlGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/aviation/aviationItemInfo.jsp" : "/pages/genericObject.jsp");
			}else if ("validateClmItemNo".equals(ACTION)) {
				message = giclAviationDtlService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveClmItemAviation".equals(ACTION)) {
				message = giclAviationDtlService.saveClmItemMarineCargo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260AviationItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getAviationItemDtl");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/aviation/aviationItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}
			
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
