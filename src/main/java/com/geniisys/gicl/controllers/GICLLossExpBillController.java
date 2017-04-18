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
import com.geniisys.gicl.service.GICLLossExpBillService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLLossExpBillController", urlPatterns={"/GICLLossExpBillController"})
public class GICLLossExpBillController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossExpBillService giclLossExpBillService = (GICLLossExpBillService) APPLICATION_CONTEXT.getBean("giclLossExpBillService");
		
		try {
			if("showLossExpBillInfo".equals(ACTION)){
				PAGE = "/pages/claims/lossExpenseHistory/pop-ups/billInformation.jsp";
			}else if("getGiclLossExpBillTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				
				Map<String, Object> giclLossExpBill = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpBill = new JSONObject(giclLossExpBill);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpBill", jsonGiclLossExpBill);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/lossExpBillTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpBill.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveLossExpBill".equals(ACTION)){
				giclLossExpBillService.saveLossExpBill(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260LossExpBill".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclLossExpBillTableGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				params.remove("from");
				params.remove("to");
				params.remove("pages");
				
				JSONObject jsonGiclLossExpBill = new JSONObject(params);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonLossExpBill", jsonGiclLossExpBill);
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/lossExpBillListing.jsp";
				}else{
					message = jsonGiclLossExpBill.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("chkGiclLossExpBill".equals(ACTION)){ //Added by: Jerome Bautista 05.28.2015 SR 3646
				Map<String, Object> params = giclLossExpBillService.chkLossExpBill(request);
				JSONObject jsonParams = new JSONObject(params);
				message = jsonParams.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ //Added by Jerome Bautista 05.28.2015 SR 3646
                message = ExceptionHandler.extractSqlExceptionMessage(e); 
                ExceptionHandler.logException(e); 
           } else { 
                message = ExceptionHandler.handleException(e, USER); 
           } 
           PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
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
