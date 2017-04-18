/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLAdviceController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 9, 2011
	Description: 
*/
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

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLAdviceService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="GICLAdviceController", urlPatterns={"/GICLAdviceController"})
public class GICLAdviceController extends BaseController{

	private static final long serialVersionUID = 4449240134443292273L;
	private static Logger log = Logger.getLogger(GICLAdviceController.class);
	public static Integer percentStatus = 0;
	public static String comment = "";
	public static String file = "";
	public static String genAccMessage = "";
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLAdviceController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("getGiacs086AdviseList".equals(ACTION)) {
				
			}else if("showGicls043AdviceListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String insertTag = request.getParameter("insertTag");
				Integer batchCsrId = Integer.parseInt(request.getParameter("batchCsrId") == null ? "0" : request.getParameter("batchCsrId"));
				request.setAttribute("batchCsrId", batchCsrId);
				
				if(insertTag.equals("1")){
					params.put("batchCsrId", batchCsrId);
					params.put("ACTION", "getGicls043AdviceList");
				}else{
					params.put("ACTION", "getGicls043AdviceListForAdd");
				}
				
				params.put("moduleId", request.getParameter("moduleId") == null ? "GICLS043" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("pageSize", 5);
				Map<String, Object> giclAdviceTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclAdvice = new JSONObject(giclAdviceTableGrid);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclAdvice", jsonGiclAdvice);
					PAGE = "/pages/claims/batchCsr/batchCsrAdviceListing.jsp";
				}else{
					message = jsonGiclAdvice.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showGICLS032ClaimAdvice".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				JSONObject json = giclAdviceService.showGICLAdvice(request, USER.getUserId());
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");				
					request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
					PAGE = "/pages/claims/generateAdvice/generateAdvice/claimAdviceMain.jsp";
				}
			} else if("gicls032GenerateAdvice".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				message = giclAdviceService.gicls032GenerateAdvice(request, USER.getUserId());				
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032CheckRequestExists".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				message = giclAdviceService.gicls032CheckRequestExists(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("createOverrideRequest".equals(ACTION)) {
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032CreateOverrideRequest(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showAdviceForeignCurrency".equals(ACTION)){
				PAGE = "/pages/claims/generateAdvice/generateAdvice/subPages/foreignCurrencyAmounts.jsp";
			} else if("gicls032EnableDisableButtons".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				message = giclAdviceService.gicls032EnableDisableButtons(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032CheckTsi".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032CheckTsi(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032ComputeAmounts".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				JSONObject result = giclAdviceService.gicls032ComputeAmounts(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032WhenCurrencyChanged".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				JSONObject result = giclAdviceService.gicls032WhenCurrencyChanged(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032CancelAdvice".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032CancelAdvice(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls032ApproveCsr".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032ApproveCsr(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if("gicls032GenerateAcc".equals(ACTION)){			
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032GenerateAcc(request, USER.getUserId());
				PAGE = "/pages/claims/generateAdvice/generateAdvice/subPages/generateAccProgress.jsp";
			} else if("gicls032SaveRemarks".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.gicls032SaveRemarks(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCancelledAdviceList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				
				Map<String, Object> cancelledAdvices = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonCancelledAdvices = new JSONObject(cancelledAdvices);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonCancelledAdvices", jsonCancelledAdvices);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/cancelledAdviceTableGridListing.jsp";
				}else{
					message = jsonCancelledAdvices.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showGenerateAccProgress".equals(ACTION)){
				Map<String, String> progress = new HashMap<String, String>();
				progress.put("percentStatus", percentStatus.toString()+"%");				
				progress.put("comment", comment);
				progress.put("file", file);
				progress.put("genAccMessage", genAccMessage);
				PAGE = "/pages/genericMessage.jsp";
				message = new JSONObject(progress).toString();
			}else if("showGICLS260LEAdvicePage".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("histSeqNo", request.getParameter("histSeqNo"));
				request.setAttribute("jsonAdvice", new JSONObject(giclAdviceService.getGICLS260Advice(params)));
				PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/advicePage.jsp";
			}else if("showGICLS260CancelledAdvice".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getCancelledAdviceList");
				params.put("claimId", request.getParameter("claimId"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(params);
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonCancelledAdviceList", json);
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/cancelledAdviceListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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