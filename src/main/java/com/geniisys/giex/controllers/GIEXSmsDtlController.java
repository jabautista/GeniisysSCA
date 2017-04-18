package com.geniisys.giex.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXSmsDtlService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXSmsDtlController", urlPatterns={"/GIEXSmsDtlController"})
public class GIEXSmsDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIEXSmsDtlService giexSmsDtlService = (GIEXSmsDtlService) APPLICATION_CONTEXT.getBean("giexSmsDtlService");
		
		try{
			if("showMessageDtlsOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getMessageDtls");
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> messageDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(messageDtlsTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("messageDtlsTableGrid", json);
					PAGE = "/pages/sms/sendMessageForRenewal/popups/messageDetails.jsp";
				}
			}else if("showPolicyDtlsOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getSMSPolicyDtls");
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				Map<String, Object> policyDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(policyDtlsTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("policyDtlsTableGrid", json);
					PAGE = "/pages/sms/sendMessageForRenewal/popups/policyDetails.jsp";
				}
			}else if("showClaimDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getSMSClaimDtls");
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				Map<String, Object> claimDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(claimDtlsTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("claimDtlsTableGrid", json);
					PAGE = "/pages/sms/sendMessageForRenewal/popups/claimDetails.jsp";
				}
			}else if("checkSMSAssured".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giexSmsDtlService.checkSMSAssured(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkSMSIntm".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giexSmsDtlService.checkSMSIntm(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateSMSTags".equals(ACTION)){
				giexSmsDtlService.updateSMSTags(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("sendSMS".equals(ACTION)){
				giexSmsDtlService.sendSMS(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveSMS".equals(ACTION)){
				giexSmsDtlService.saveSMS(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			}else{
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}	
}
