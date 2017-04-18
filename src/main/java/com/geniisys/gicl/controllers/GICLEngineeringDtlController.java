package com.geniisys.gicl.controllers;

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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLEngineeringDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GICLEngineeringDtlController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The Logger **/
	private Logger log = Logger.getLogger(GICLEngineeringDtlController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing: " + this.getClass().getSimpleName() + "...");
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLEngineeringDtlService giclEngineeringDtlService = (GICLEngineeringDtlService) APPLICATION_CONTEXT.getBean("giclEngineeringDtlService");
			
			if ("getEngineeringDtl".equals(ACTION)) {
				log.info("Getting engineering item information...");
				Map<String, Object> params = new HashMap<String, Object>();
				Integer claimId = (request.getParameter("claimId") == null) ? 0 : (request.getParameter("claimId").isEmpty() ? 0 : Integer.parseInt(request.getParameter("claimId")));
				
				params.put("claimId", claimId);				
				giclEngineeringDtlService.loadEngineeringItemInfoItems(params);
				
				giclEngineeringDtlService.getGiclEngineeringDtlGrid(request, USER, APPLICATION_CONTEXT);
				
				request.setAttribute("engineeringItemInfoMap", new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString());
				
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/engineering/engineeringItemInfo.jsp" : "/pages/genericObject.jsp");
			}else if ("saveClmItemEngineering".equals(ACTION)){
				message = giclEngineeringDtlService.saveClmItemEngineering(request, USER);
				PAGE= "/pages/genericMessage.jsp";
			}else if("validateClmItemNo".equals(ACTION)){
				log.info("Validating item no. ... ");
				message = giclEngineeringDtlService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260EngineeringItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclEngineeringDtlGrid");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/engineering/engineeringItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}

	}

}
