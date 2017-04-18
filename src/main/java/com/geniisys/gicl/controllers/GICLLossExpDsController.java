package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLLossExpDsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLLossExpDsController", urlPatterns={"/GICLLossExpDsController"})
public class GICLLossExpDsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLLossExpDsService giclLossExpDsService = (GICLLossExpDsService) APPLICATION_CONTEXT.getBean("giclLossExpDsService");
			
			if("getGiclLossExpDsList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				
				Map<String, Object> giclLossExpDs = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpDs = new JSONObject(giclLossExpDs);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpDs", jsonGiclLossExpDs);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/giclLossExpDsTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpDs.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showDistributionDate".equals(ACTION)){
				request.setAttribute("distDate", request.getParameter("distDate"));
				PAGE = "/pages/claims/lossExpenseHistory/pop-ups/distributionDate.jsp";
			}else if("checkXOL".equals(ACTION)){
				Map<String, Object> params = giclLossExpDsService.checkXOL(request, USER);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("distributeLossExpHistory".equals(ACTION)){
				message = giclLossExpDsService.distributeLossExpHistory(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("redistributeLossExpHistory".equals(ACTION)){
				message = giclLossExpDsService.redistributeLossExpHistory(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("negateLossExpHistory".equals(ACTION)){
				message = giclLossExpDsService.negateLossExpenseHistory(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260LossExpDist".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclLossExpDsList");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("userId", USER.getUserId());
				
				Map<String, Object> giclLossExpDs = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpDs = new JSONObject(giclLossExpDs);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonLossExpDS", jsonGiclLossExpDs);
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					request.setAttribute("calledFrom", request.getParameter("calledFrom"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/viewDistribution.jsp";
				}else{
					message = jsonGiclLossExpDs.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
