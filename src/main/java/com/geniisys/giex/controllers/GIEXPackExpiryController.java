package com.geniisys.giex.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giex.service.GIEXPackExpiryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXPackExpiryController", urlPatterns={"/GIEXPackExpiryController"})
public class GIEXPackExpiryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXPackExpiryService giexPackExpiryService = (GIEXPackExpiryService) APPLICATION_CONTEXT.getBean("giexPackExpiryService");
			
			if("checkPackPolicyIdGiexs006".equals(ACTION)){
				Integer packPolicyId = Integer.parseInt(request.getParameter("packPolicyId"));
				message = giexPackExpiryService.checkPackPolicyIdGiexs006(packPolicyId);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPackPolicyId".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("frRnSeqNo", request.getParameter("frRnSeqNo"));
				params.put("toRnSeqNo", request.getParameter("toRnSeqNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}		
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				//Date eDate = df.parse(request.getParameter("endDate"));
				//String endDate = df.format(eDate);
				params.put("startDate", request.getParameter("startDate"));
				params.put("endDate", request.getParameter("endDate"));
				params.put("renewFlag", request.getParameter("renewFlag"));
				
				params.put("userId", USER.getUserId());
				params.put("reqRenewalNo", request.getParameter("reqRenewalNo"));
				Debug.print("getPackPolicyId params:" + params);
				
				List<Integer> resultParams = (List<Integer>) giexPackExpiryService.getPackPolicyId(params);
				Debug.print("getPackPolicyId resultParams:" + resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPackRecordUser".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", request.getParameter("policyId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}	
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				//Date eDate = df.parse(request.getParameter("endDate"));
				//String endDate = df.format(eDate);
				params.put("startDate", request.getParameter("startDate"));
				params.put("endDate", request.getParameter("endDate"));
				
				params.put("frRnSeqNo", request.getParameter("frRnSeqNo"));
				params.put("toRnSeqNo", request.getParameter("toRnSeqNo"));
				params.put("userId", USER.getUserId());
				
				Debug.print("checkRecordUser params:" + params);
				message = giexPackExpiryService.checkPackRecordUser(params);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
