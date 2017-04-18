package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLClaimTableMaintenanceService;
import com.geniisys.giuw.controllers.GIUWPolDistController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLClaimTableMaintenanceController", urlPatterns={"/GICLClaimTableMaintenanceController"})
public class GICLClaimTableMaintenanceController extends BaseController{

	/**
	 * 
	 */
	private Logger log = Logger.getLogger(GIUWPolDistController.class);
	private static final long serialVersionUID = -5149745550734999239L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLClaimTableMaintenanceService giclClaimTableMaintenanceService = (GICLClaimTableMaintenanceService) APPLICATION_CONTEXT.getBean("giclClaimTableMaintenanceService"); //03.03.2013 fons
			PAGE = "/pages/genericMessage.jsp";
			if("showMenuClaimPayeeClass".equals(ACTION)){
				JSONObject jsonClmPayeeClass = giclClaimTableMaintenanceService.showMenuClaimPayeeClass(request);
				JSONObject jsonClmPayeeInfo = giclClaimTableMaintenanceService.showMenuClaimPayeeInfo(request, "");		
				request.setAttribute("payeeClassCd", request.getParameter("payeeClassCd"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmPayeeClass.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmPayeeClass", jsonClmPayeeClass);
					request.setAttribute("jsonClmPayeeInfo", jsonClmPayeeInfo);
					PAGE = "/pages/claims/tableMaintenance/claimPayee/claimPayee.jsp";				
				}			
			}else if("showMenuClaimPayeeInfo".equals(ACTION)){
				String payeeClassCd = request.getParameter("payeeClassCd");
				JSONObject jsonClmPayeeInfo = giclClaimTableMaintenanceService.showMenuClaimPayeeInfo(request, payeeClassCd);
				message = jsonClmPayeeInfo.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("showBankAcctDtls".equals(ACTION)){
					request.setAttribute("payeeClassCd", request.getParameter("payeeClassCd"));
					request.setAttribute("payeeNo", request.getParameter("payeeNo"));			
					PAGE = "/pages/claims/tableMaintenance/claimPayee/bankAccountDetails.jsp";
				
			}else if("getBankAcctHstryField".equals(ACTION)){
				JSONObject jsonBankAcctHstryField = giclClaimTableMaintenanceService.getBankAcctHstryField(request);
				JSONObject jsonBankAcctHstryValue = giclClaimTableMaintenanceService.getBankAcctHstryValue(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBankAcctHstryField.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBankAcctHstryField", jsonBankAcctHstryField);
					request.setAttribute("jsonBankAcctHstryValue", jsonBankAcctHstryValue);
					request.setAttribute("payeeClassCd", request.getParameter("payeeClassCd"));
					request.setAttribute("payeeNo", request.getParameter("payeeNo"));						
					PAGE = "/pages/claims/tableMaintenance/claimPayee/bankAccountHistory.jsp";
				}			
			}else if("getBankAcctHstryValue".equals(ACTION)){
				JSONObject jsonBankAcctHstryValue = giclClaimTableMaintenanceService.getBankAcctHstryValue(request);
				message = jsonBankAcctHstryValue.toString();										
				PAGE = "/pages/genericMessage.jsp";
					
			}else if("showBankAcctApprovals".equals(ACTION)){
				JSONObject jsonBankAcctApprovals = giclClaimTableMaintenanceService.showBankAcctApprovals(request);
											
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBankAcctApprovals.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBankAcctApprovals", jsonBankAcctApprovals);
					request.setAttribute("payeeClassCd", request.getParameter("payeeClassCd"));					
					PAGE = "/pages/claims/tableMaintenance/claimPayee/bankAccountApprovals.jsp";
				}								
			}else if("validateMobileNo".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclClaimTableMaintenanceService.validateMobileNo(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateUserFunc".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclClaimTableMaintenanceService.validateUserFunc(request, USER);	
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGicls150".equals(ACTION)){
				log.info("Saving Claim Payee...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclClaimTableMaintenanceService.saveGicls150(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if("saveBankAcctDtls".equals(ACTION)){
				log.info("Saving Bank Account Details...");
				Map<String, Object> params = new HashMap<String, Object>();
				System.out.println(request.getParameter("parameters"));
				params = giclClaimTableMaintenanceService.saveBankAcctDtls(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}
			else if("approveBankAcctDtls".equals(ACTION)){
				log.info("Approving Bank Account Details...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclClaimTableMaintenanceService.approveBankAcctDtls(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";					
			}else if ("getBankAcctDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclClaimTableMaintenanceService.getBankAcctDtls(request);	
				JSONObject json = new JSONObject(params);
				message = json.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}
}
