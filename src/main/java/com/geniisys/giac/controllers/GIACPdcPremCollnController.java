package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACPdcPremCollnService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACPdcPremCollnController", urlPatterns={"/GIACPdcPremCollnController"})
public class GIACPdcPremCollnController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2842950758498565500L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIACPdcPremCollnService premCollnService = (GIACPdcPremCollnService) appContext.getBean("giacPdcPremCollnService"); //benjo 11.08.2016 SR-5802
		
		try {			
			if("getGIACPdcPremCollnListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pdcId", request.getParameter("pdcId"));
				params.put("pageSize", 500);
				params.put("ACTION", ACTION);
				params = TableGridUtil.getTableGrid(request, params);
				message = new JSONObject(params).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if("getPremCollnUpdateValues".equals(ACTION)){
				//GIACPdcPremCollnService premCollnService = (GIACPdcPremCollnService) appContext.getBean("giacPdcPremCollnService"); //benjo 11.08.2016 SR-5802
				JSONObject json = premCollnService.getPremCollnUpdateValues(request); 
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showDatedChecksOverlay".equals(ACTION)){Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("ACTION", "getDatedChksDtlsTG");
				Map<String, Object> datedCheckTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(datedCheckTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("datedCheckTG", json);
					PAGE = "/pages/pop-ups/showDatedCheckOverlay.jsp";
				}
			}else if("getRefPolNo".equals(ACTION)){ //benjo 11.08.2016 SR-5802
				message = premCollnService.getRefPolNo(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePolicy".equals(ACTION)){ //benjo 11.08.2016 SR-5802
				message = premCollnService.validatePolicy(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPolicyInvoices".equals(ACTION)){//benjo 11.08.2016 SR-5802
				List<Map <String, Object>> policyInvoices = premCollnService.getPolicyInvoices(request);
				JSONArray jsonPolicyInvoices = new JSONArray(policyInvoices);
				request.setAttribute("object", jsonPolicyInvoices);
				PAGE = "/pages/genericObject.jsp";
			}else if("getPackInvoices".equals(ACTION)){//benjo 11.08.2016 SR-5802
				Map<String, Object> packInvoicesTG = premCollnService.getPackInvoices(request);
				JSONObject json = new JSONObject(packInvoicesTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("packInvoicesTG", json);
					PAGE = "/pages/accounting/PDCPayment/pop-ups/pdcPackInvoices.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
}
