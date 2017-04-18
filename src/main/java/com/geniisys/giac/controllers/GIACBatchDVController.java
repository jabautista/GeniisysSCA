/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.controllers
	File Name: GIACBatchDVController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 8, 2011
	Description: 
*/


package com.geniisys.giac.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.giac.service.GIACAcctEntriesService;
import com.geniisys.giac.service.GIACBatchDVService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.service.GICLAdviceService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACBatchDVController", urlPatterns={"/GIACBatchDVController"})
public class GIACBatchDVController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 826708816541814803L;
	private static Logger log = Logger.getLogger(GIACBatchDVController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GIACBatchDVController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACBatchDVService giacBatchDVService = (GIACBatchDVService) APPLICATION_CONTEXT.getBean("giacBatchDVService");
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("getSpecialCSRListing".equals(ACTION)) {
				giacBatchDVService.getSpecialCSRListing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/specialClaimSettlementRequest/specialCSRListing.jsp";
				}
			}else if ("getSpecialCSRInfo".equals(ACTION)) {
				GICLAdviceService giclAdviceService = (GICLAdviceService) APPLICATION_CONTEXT.getBean("giclAdviceService");
				giclAdviceService.getGiacs086AdviseList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
					request.setAttribute("overrideParameter", giacParamService.getParamValueV2("OVERRIDE_APPROVE_CSR"));
					PAGE = "/pages/claims/specialClaimSettlementRequest/subpages/specialCSRInfo.jsp";
				}
			}else if("cancelGIACBatch".equals(ACTION)){
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				giacBatchDVService.cancelGIACBatch(params);
				message = "SUCCESS";
			}else if("getGIACS086AcctTransTableGrid".equals(ACTION)){
				giacBatchDVService.getGIACS086AcctTransTableGrid(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/specialClaimSettlementRequest/subpages/specialCSRAccountingTrans.jsp";
				}
			}else if ("getGIACS086AcctEntriesTableGrid".equals(ACTION)) {
				GIACAcctEntriesService acctEntriesService = APPLICATION_CONTEXT.getBean(GIACAcctEntriesService.class);
				acctEntriesService.getGIACS086AcctEntriesTableGrid(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					String moduleId = request.getParameter("moduleId");
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("tranId", request.getParameter("tranId"));
					params.put("branchCd", request.getParameter("branchCd"));
					giacBatchDVService.getGIACS086AcctEntPostQuery(params);
					request.setAttribute("totalDebitAmt", params.get("totalDebitAmt"));
					request.setAttribute("totalCreditAmt", params.get("totalCreditAmt"));
					
					if ("GIACS016".equals(moduleId)) { // resue nalang for giacs016 - irwin
						request.setAttribute("dvTranId", request.getParameter("tranId"));
						PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/subpages/accountingEntries.jsp";
					}else{
						PAGE = "/pages/claims/specialClaimSettlementRequest/subpages/specialCSRAccountingEntries.jsp";
					}
					
				}
			}else if("printCSR".equals(ACTION)){
//				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
//				String[] userId = {USER.getUserId()};
//				List<LOV> printers = helper.getList(LOVHelper.PRINTER_LISTING_PER_USER_ACCESS,userId);
//				request.setAttribute("printers", printers);	
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);//installed printers ang gamitin - steven - 02.05.2013			
				request.setAttribute("printers", printers);
				request.setAttribute("adviceLength", request.getParameter("adviceLength"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				PAGE = "/pages/claims/specialClaimSettlementRequest/subpages/printSCsrDialog.jsp";
			}else if ("showGIACS087".equals(ACTION)) {
				JSONObject json = giacBatchDVService.getGIACS087Listing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("specialCSRList", json);
					PAGE = "/pages/claims/inquiry/specialCSRInquiries/specialCSRInquiries.jsp";
				}
			}else if ("showGIACS087BatchDetails".equals(ACTION)) {
				JSONObject json = giacBatchDVService.getGIACS087BatchDetails(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("batchDetailsList", json);
					request.setAttribute("batchDvId", request.getParameter("batchDvId"));
					PAGE = "/pages/claims/inquiry/specialCSRInquiries/popup/batchDetails.jsp";
				}
			}else if ("showGIACS087AcctEntries".equals(ACTION)) {
				JSONObject json = giacBatchDVService.getGIACS087AcctEntries(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("acctEntriesList", json);
					request.setAttribute("batchDvId", request.getParameter("batchDvId"));
					PAGE = "/pages/claims/inquiry/specialCSRInquiries/popup/acctEntries.jsp";
				}
			}else if ("getGIACS087AcctEntriesDtl".equals(ACTION)) {
				JSONObject json = giacBatchDVService.getGIACS087AcctEntriesDtl(request, USER);
				message = json.toString();
				System.out.println("======"+message);
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("getGIACS087AcctEntriesTotals".equals(ACTION)) {
				JSONObject json = giacBatchDVService.getGIACS087AcctEntTotals(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
