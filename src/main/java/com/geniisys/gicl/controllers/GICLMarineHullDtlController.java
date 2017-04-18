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
import com.geniisys.gicl.service.GICLMarineHullDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLMarineHullDtlController", urlPatterns={"/GICLMarineHullDtlController"})
public class GICLMarineHullDtlController extends BaseController{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLCasualtyDtlController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLMarineHullDtlService marineHullService = (GICLMarineHullDtlService) APPLICATION_CONTEXT.getBean("giclMarineHullDtlService");
			if("getMarineHullDtl".equals(ACTION)){
				/*log.info("Getting Marine Hull item information...");
				marineHullService.getGiclMarineHullDtlGrid(request, USER);*/
				
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclMarineHullDtlGrid");
				params.put("claimId", claimId);
				Map<String, Object> marineHullItemInfo = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(marineHullItemInfo); 
				
				request.setAttribute("marineHullItemInfo", json);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/marineHull/marineHullItemInfo.jsp" : "/pages/genericObject.jsp");
				
			}else if("validateClmItemNo".equals(ACTION)){
				log.info("Validating item no. ... ");
				message = marineHullService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveClmItemMarineHull".equals(ACTION)){
				message = marineHullService.saveClmItemMarineHull(request, USER);
				PAGE= "/pages/genericMessage.jsp";
			}else if("showGICLS260MarineHullItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclMarineHullDtlGrid");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/marineHull/marineHullItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}
		catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}
		catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}
		finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
