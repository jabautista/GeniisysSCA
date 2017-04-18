/**
 * 
 */
package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACCreditAndCollectionUtilitiesService;
import com.geniisys.giac.service.GIACModulesService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */

@WebServlet (name="GIACCreditAndCollectionUtilitiesController", urlPatterns={"/GIACCreditAndCollectionUtilitiesController"})
public class GIACCreditAndCollectionUtilitiesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2928783358111983846L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACCreditAndCollectionUtilitiesService giacCreditAndCollectionUtilitiesService = (GIACCreditAndCollectionUtilitiesService) APPLICATION_CONTEXT.getBean("giacCreditAndCollectionUtilitiesService");
			
			if("showCancelledPolicies".equals(ACTION)){
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");	// start FGIC SR-4266 : shan 05.21.2015
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", USER.getUserId());
				param.put("funcCode", "RP");
				param.put("moduleName", "GIACS412");
				String userAccessRP = giacModulesService.validateUserFunc(param);	// end FGIC SR-4266 : shan 05.21.2015
				
				JSONObject jsonCancelledPol = giacCreditAndCollectionUtilitiesService.showCancelledPolicies(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCancelledPol.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCancelledPol", jsonCancelledPol);
					request.setAttribute("userAccessRP", userAccessRP);	// FGIC SR-4266 : shan 05.21.2015
					PAGE = "/pages/accounting/creditAndCollection/utilities/processCancelledPolicies/processCancelledPolicies.jsp";				
				} 
			}else if("showEndorsement".equals(ACTION)){
				JSONObject jsonEndorsement = giacCreditAndCollectionUtilitiesService.showEndorsement(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonEndorsement.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonEndorsement", jsonEndorsement);
					PAGE = "/pages/accounting/creditAndCollection/utilities/processCancelledPolicies/pop-ups/endorsementOverlay.jsp";				
				} 
			}else if (ACTION.equals("getAllCancelledPol")) {
				JSONArray jsonArrayBatchOS = new JSONArray(giacCreditAndCollectionUtilitiesService.getAllCancelledPol(request,USER)); 
				message = jsonArrayBatchOS.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if (ACTION.equals("processCancelledPol")) {
				giacCreditAndCollectionUtilitiesService.processCancelledPol(request,USER); 
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGIACS150".equals(ACTION)){
				PAGE = "/pages/accounting/creditAndCollection/utilities/ageBills/ageBills.jsp";
			}else if("ageBills".equals(ACTION)){
				giacCreditAndCollectionUtilitiesService.ageBills(request, USER.getUserId()); 
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPoliciesForReverse".equals(ACTION)){	// start FGIC SR-4266 : shan 05.21.2015
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACS412PoliciesForReverse");
				params.put("userId", USER.getUserId());
				Map<String, Object> polForReverseMap = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonPolForReverse = new JSONObject(polForReverseMap);
				message = jsonPolForReverse.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if("getPoliciesForReverseByParam".equals(ACTION)){
				JSONArray records = giacCreditAndCollectionUtilitiesService.getPoliciesForReverseByParam(request, USER.getUserId());
				//System.out.println("length: " +records.length());
				request.setAttribute("object", records);
				PAGE = "/pages/genericObject.jsp";	
			}else if("reverseProcessedPolicies".equals(ACTION)){
				giacCreditAndCollectionUtilitiesService.reverseProcessedPolicies(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} 	// end FGIC SR-4266 : shan 05.21.2015
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}
}