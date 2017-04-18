package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
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
import com.geniisys.giac.service.GIACDisbursementUtilitiesService;
import com.geniisys.giex.service.GIEXExpiryService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACDisbursementUtilitiesController", urlPatterns={"/GIACDisbursementUtilitiesController"})
public class GIACDisbursementUtilitiesController extends BaseController{

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
			GIACDisbursementUtilitiesService giacDisbursementUtilitiesService = (GIACDisbursementUtilitiesService) APPLICATION_CONTEXT.getBean("giacDisbursementUtilitiesService");
			
			if("showCopyPaymentRequest".equals(ACTION)) {
				PAGE = "/pages/accounting/generalDisbursements/utilities/copyPaymentRequest/copyPaymentRequest.jsp";
			}else if("populateBillInformationDtls".equals(ACTION)){
				message = new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(giacDisbursementUtilitiesService.getBillInformationDtls(request, USER.getUserId()))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateRequestNumber".equals(ACTION)) {
				giacDisbursementUtilitiesService.validateRequestNo(request);
				//request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("copyPaymentRequest".equals(ACTION)) {
				giacDisbursementUtilitiesService.copyPaymentRequest(request, USER);
				PAGE = "/pages/genericObject.jsp";
			} else if ("showNewPaymentRequest".equals(ACTION)) {
				PAGE = "/pages/accounting/generalDisbursements/utilities/copyPaymentRequest/newPaymentRequest.jsp";
			} else if ("giacs045ValidateDocumentCd".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateDocumentCd(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs045ValidateBranchCdFrom".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateBranchCdFrom(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs045ValidateLineCd".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateLineCd(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs045ValidateDocYear".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateDocYear(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs045ValidateDocMm".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateDocMm(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs045ValidateBranchCdTo".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs045ValidateBranchCdTo(request, USER);
				PAGE = "/pages/genericObject.jsp";
			}else if("showModifyCommInvoicePage".equals(ACTION)) {
				JSONObject jsonInvCommInfoList = giacDisbursementUtilitiesService.showInvoiceCommInfoListing(request,USER);
				request.setAttribute("jsonInvCommInfoList", jsonInvCommInfoList);
				
				JSONObject jsonPerilInfoList = giacDisbursementUtilitiesService.showPerilInfoListing(request,USER);
				request.setAttribute("jsonPerilInfoList", jsonPerilInfoList);
				
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIEXExpiryService giexExpiryService = (GIEXExpiryService) APPLICATION_CONTEXT.getBean("giexExpiryService");
				request.setAttribute("fundCd", commInvoiceService.getAccountingParameter("FUND_CD"));
				request.setAttribute("branchCd", commInvoiceService.getAccountingParameter("BRANCH_CD"));
				request.setAttribute("ORA2010SW", giexExpiryService.getGiispLineCdGiexs006("ORA2010_SW"));
				
				PAGE = "/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/modifyCommInvoiceMain.jsp";
			}else if("showInvoiceCommInfoListing".equals(ACTION)){
				System.out.println("showInvoiceCommInfoListing: issCd="+request.getParameter("issCd") + " premSeqNo="+request.getParameter("premSeqNo"));
				JSONObject jsonInvCommInfoList = giacDisbursementUtilitiesService.showInvoiceCommInfoListing(request,USER);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonInvCommInfoList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showPerilInfoListing".equals(ACTION)){
				System.out.println("showPerilInfoListing: fundCd="+request.getParameter("fundCd") + " branchCd="+request.getParameter("branchCd")+ " commRecId="+request.getParameter("commRecId")
						+ " intmNo="+request.getParameter("intmNo")+ " lineCd="+request.getParameter("lineCd"));
				JSONObject jsonPerilInfoList = giacDisbursementUtilitiesService.showPerilInfoListing(request,USER);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPerilInfoList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("giacs408ValidateBillNo".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs408ValidateBillNo(request, USER.getUserId());
				PAGE = "/pages/genericObject.jsp";
			}else if ("giacs408ChkBillNoOnSelect".equals(ACTION)) {
				giacDisbursementUtilitiesService.giacs408ChkBillNoOnSelect(request);
				PAGE = "/pages/genericObject.jsp";
			}else if ("populateInvoiceCommPeril".equals(ACTION)) {
				giacDisbursementUtilitiesService.populateInvoiceCommPeril(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateInvCommShare".equals(ACTION)) {
				giacDisbursementUtilitiesService.validateInvCommShare(request);
				PAGE = "/pages/genericObject.jsp";
			}else if ("validatePerilCommRt".equals(ACTION)) {
				giacDisbursementUtilitiesService.validatePerilCommRt(request);
				PAGE = "/pages/genericObject.jsp";
			}else if ("recomputeCommRate".equals(ACTION)) {
				BigDecimal commissionRt =  giacDisbursementUtilitiesService.recomputeCommRt(request);
				message = (commissionRt == null) ? "0" : commissionRt.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("recomputeCommRate2".equals(ACTION)) {
				JSONObject recomputeCommRateList =  giacDisbursementUtilitiesService.recomputeCommRt2(request);
				message = recomputeCommRateList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("recomputeWtaxRate".equals(ACTION)) {
				BigDecimal wtaxRate =  giacDisbursementUtilitiesService.recomputeWtaxRate(request);
				message = (wtaxRate == null) ? "0" : wtaxRate.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showInvCommHistoryListing".equals(ACTION)){
				JSONObject jsonInvCommHistoryList = giacDisbursementUtilitiesService.showInvCommHistoryListing(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonInvCommHistoryList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonInvCommHistoryList", jsonInvCommHistoryList);
					PAGE = "/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/subPages/invCommissionHistory.jsp";
				}
			}else if("showBancAssurance".equals(ACTION)){
				JSONObject jsonBancAssurance = giacDisbursementUtilitiesService.showBancAssurance(request);
				request.setAttribute("jsonBancAssurance", jsonBancAssurance);

				JSONObject jsonBancAssuranceDtls = giacDisbursementUtilitiesService.showBancAssuranceDtls(request, USER);
				request.setAttribute("jsonBancAssuranceDtls", jsonBancAssuranceDtls);
				PAGE = "/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/subPages/bancAssuranceDetails.jsp";
			}else if("showBancAssuranceDtls".equals(ACTION)){
				JSONObject json = giacDisbursementUtilitiesService.showBancAssuranceDtls2(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getObjInsertUpdateInvperl".equals(ACTION)) {
				message = (new JSONArray (giacDisbursementUtilitiesService.getObjInsertUpdateInvperl(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkInvoicePayt".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.checkInvoicePayt(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkRecord".equals(ACTION)) {
				message = new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(giacDisbursementUtilitiesService.checkRecord(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("keyDelRecGIACS408".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.keyDelRecGIACS408(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("cancelInvoiceCommission".equals(ACTION)) {
				giacDisbursementUtilitiesService.cancelInvoiceCommission(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveInvoiceCommission".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.saveInvoiceCommission(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postInvoiceCommission".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.postInvoiceCommission(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkBancAssurance".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.checkBancAssurance(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("applyBancAssurance".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.applyBancAssurance(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("recomputeCommRateGiacs408".equals(ACTION)) {
				message = new JSONArray(giacDisbursementUtilitiesService.recomputeCommRateGiacs408(request)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getAdjustedPremAmt".equals(ACTION)) {
				message = giacDisbursementUtilitiesService.getAdjustedPremAmt(request, USER).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiacs408PerilList".equals(ACTION)){
				System.out.println("getGiacs408PerilList: fundCd="+request.getParameter("fundCd") + " branchCd="+request.getParameter("branchCd")+ " commRecId="+request.getParameter("commRecId")
						+ " intmNo="+request.getParameter("intmNo")+ " lineCd="+request.getParameter("lineCd"));
				JSONArray jsonPerilList = giacDisbursementUtilitiesService.getGiacs408PerilList(request, USER);
				
				message = jsonPerilList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiacs408InvoiceCommList".equals(ACTION)){
				JSONArray jsonInvoiceCommList = giacDisbursementUtilitiesService.getGiacs408InvoiceCommList(request, USER);
				
				message = jsonInvoiceCommList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
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
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
