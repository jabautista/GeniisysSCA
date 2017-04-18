package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACChkReleaseInfoService;
import com.geniisys.giac.service.GIACInquiryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACInquiryController", urlPatterns={"/GIACInquiryController"})
public class GIACInquiryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 509772312700968123L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACInquiryService giacInquiryService = (GIACInquiryService) APPLICATION_CONTEXT.getBean("giacInquiryService");
			GIACChkReleaseInfoService giacChkReleaseInfoService = (GIACChkReleaseInfoService) APPLICATION_CONTEXT.getBean("giacChkReleaseInfoService");
			GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
			
			if("showOrStatus".equals(ACTION)){
				JSONObject json = giacInquiryService.showOrStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/orStatus/orStatus.jsp";					
				}
			}else if("showOrHistory".equals(ACTION)){
				JSONObject json = giacInquiryService.showOrHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/orStatus/subPages/orHistory.jsp";
				}
			}else if("showReprintDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("showFileOption", request.getParameter("showFileOption"));
				PAGE = "/pages/accounting/orStatus/subPages/orReprint.jsp";
			}else if("showOrPrintDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("showFileOption", request.getParameter("showFileOption"));
				PAGE = "/pages/accounting/orStatus/subPages/orPrint.jsp";
			}else if("showTransactionStatus".equals(ACTION)){
				JSONObject json = giacInquiryService.showTransactionStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/transactionStatus/transactionStatus.jsp";					
				}
			}else if ("showTranStatHist".equals(ACTION)) {
				JSONObject json = giacInquiryService.showTranStatHist(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/transactionStatus/subPages/transactionStatusHistory.jsp";				
				}				
			} else if("showTranStatPrintDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("showFileOption", request.getParameter("showFileOption"));
				PAGE = "/pages/accounting/transactionStatus/subPages/transactionStatusPrintDialog.jsp";		
			//lara
			}else if("showDVStatus".equals(ACTION)){ //LMB	
				JSONObject json = giacInquiryService.showDVStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{				
					PAGE = "/pages/accounting/generalDisbursements/inquiry/dvStatus/dvStatus.jsp";				
				}		
			} else if("showGIAC237StatusHistory".equals(ACTION)){
				JSONObject jsonStatusHistory = giacInquiryService.showStatusHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonStatusHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonStatusHistory", jsonStatusHistory);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/dvStatus/statusHistory.jsp";					
				}
			} else if("showPaymentRequestStatus".equals(ACTION)){
				JSONObject json = giacInquiryService.showPaymentRequestStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/inquiry/paymentRequestStatus/paymentRequestStatus.jsp";				
				}
			}else if("showPaymentRequestHistory".equals(ACTION)){
				JSONObject json = giacInquiryService.showPaymentRequestHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/inquiry/paymentRequestStatus/subPages/paymentRequestHistory.jsp";
				}
			/*Added by Joms Diago*/
			}else if("showCheckReleaseInfo".equals(ACTION)){
				JSONObject json = giacInquiryService.showCheckReleaseInfo(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/checkReleaseInfo/checkReleaseInfo.jsp";					
				}
				request.setAttribute("userId", USER.getUserId());
			}else if("saveCheckReleaseInfo".equals(ACTION)){
				message = giacChkReleaseInfoService.saveCheckReleaseInfo(request, USER.getUserId());
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGLAccountTransaction".equals(ACTION)){
				JSONObject json = giacInquiryService.showGLAccountTransaction(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalLedger/inquiry/glAccountTransaction/glAccountTransaction.jsp";
				} 
			}else if("getGLAcctTransactionGIACS230".equals(ACTION)){
				JSONObject json = giacInquiryService.showGLAccountTransaction(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalLedger/inquiry/glAccountTransaction/subpages/glAcctTranTableGrid.jsp";
				} 
			}else if("getSLSummaryGIACS230".equals(ACTION)){
				JSONObject json = giacInquiryService.getSlSummary(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalLedger/inquiry/glAccountTransaction/subpages/slSummaryTableGrid.jsp";
				} 
			}else if("showMultiSortGIACS230".equals(ACTION)){
				PAGE = "/pages/accounting/generalLedger/inquiry/glAccountTransaction/popup/multiSort.jsp";
			}else if ("showGIACS092".equals(ACTION)) {
				JSONObject jsonViewPDCPayments = giacInquiryService.showPDCPayments(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonViewPDCPayments.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonViewPDCPayments", jsonViewPDCPayments);
					PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/pdcPaymentsInquiry.jsp";					
				}
			} else if("showORParticulars".equals(ACTION)) {
				PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/orParticulars.jsp";	
			} else if("showMiscAmount".equals(ACTION)) {
				PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/miscAmount.jsp";	
			} else if("showForeignCurrency".equals(ACTION)) {
				PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/foreignCurrency.jsp";	
			} else if("showGIACS092Details".equals(ACTION)) {
				JSONObject jsonGIACS092Details = giacInquiryService.showGIACS092Details(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIACS092Details.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIACS092Details", jsonGIACS092Details);
					PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/details.jsp";
				}
			} else if("showGIACS092Replacement".equals(ACTION)) {
				JSONObject jsonGIACS092Replacement = giacInquiryService.showGIACS092Replacement(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIACS092Replacement.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIACS092Replacement", jsonGIACS092Replacement);
					PAGE = "/pages/accounting/cashReceipts/inquiry/pdcPaymentsInquiry/replacement.jsp";
				}
			}else if ("showBillPayment".equals(ACTION)) {
				JSONObject jsonGiacDirectPremCollnsTg = giacInquiryService.showBillPayment(request,USER);
				request.setAttribute("jsonGiacDirectPremCollnsTg", jsonGiacDirectPremCollnsTg);
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billPayments/billPayments.jsp";
			}else if ("getGiacs211BillDetails".equals(ACTION)) { // andrew - 08042015 - SR 19643
				JSONObject jsonGipiInvoice = giacInquiryService.getGiacs211BillDetails(request, USER);
				message = jsonGipiInvoice.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("getGIACS211GipiInvoice".equals(ACTION)) {
				JSONObject jsonGipiInvoice = giacInquiryService.getGIACS211GipiInvoice(request, USER);
				message = jsonGipiInvoice.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGIACS211PolicyLov".equals(ACTION)) {
				JSONObject jsonGipiInvoice = giacInquiryService.getGIACS211PolicyLov(request, USER);
				message = jsonGipiInvoice.toString();
				PAGE = "/pages/genericMessage.jsp"; //Dren 06292015 : SR 0004613 - Added LOV for policy no.
			}else if ("getGIACS211PackPolicyLov".equals(ACTION)) {  // andrew - 07242015 - SR 19643
				JSONObject jsonGipiInvoice = giacInquiryService.getGIACS211PackPolicyLov(request, USER);
				message = jsonGipiInvoice.toString();
				PAGE = "/pages/genericMessage.jsp"; //Dren 06292015 : SR 0004613 - Added LOV for policy no.
			}else if ("getGIACS211GiacDirectPremCollns".equals(ACTION)) {
				JSONObject jsonGiacDirectPremCollnsTg = giacInquiryService.getGIACS211GiacDirectPremCollns(request, USER);
				message = jsonGiacDirectPremCollnsTg.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showPremiumOverlay".equals(ACTION)){
				JSONObject jsonPremium = giacInquiryService.showPremiumOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPremium.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPremium", jsonPremium);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPayments/pop-ups/premiumOverlay.jsp";
				}
			}else if("showTaxesOverlay".equals(ACTION)){
				JSONObject jsonTaxes = giacInquiryService.showTaxesOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonTaxes.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonTaxes", jsonTaxes);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPayments/pop-ups/taxesOverlay.jsp";
				}
			}else if("showPDCPaymentsOverlay".equals(ACTION)){
				JSONObject jsonPDCPayments = giacInquiryService.showPDCPaymentsOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPDCPayments.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPDCPayments", jsonPDCPayments);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPayments/pop-ups/pdcPaymentsOverlay.jsp";
				}
			}else if("showBalancesOverlay".equals(ACTION)){
				JSONObject jsonBalances = giacInquiryService.showBalancesOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBalances.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBalances", jsonBalances);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPayments/pop-ups/balancesOverlay.jsp";
				}
			}else if("showGIACS202".equals(ACTION)){ // jomsdiago 07.31.2013
				JSONObject json = giacInquiryService.getBillsByAssdAndAgeDetails(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsByAssdAndAge/billsByAssdAndAge.jsp";				
				}
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("callFrom", request.getParameter("callFrom"));
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
			}else if("showAgingListAllPopUp".equals(ACTION)){ // jomsdiago 07.31.2013
				JSONObject json = giacInquiryService.showAgingListAllPopUp(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsByAssdAndAge/agingListAllPopUp.jsp";				
				}
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
			}else if("showSortPopUp".equals(ACTION)){ // jomsdiago 07.31.2013
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("columnNo", request.getParameter("columnNo"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsByAssdAndAge/agingSortPopUp.jsp";
			}else if("showDetailsDirOverlay".equals(ACTION)){ // jomsdiago 07.31.2013
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsByAssdAndAge/detailsDirOverlay.jsp";
			}else if("showGIACS203".equals(ACTION)){ // jomsdiago 08.01.2013
				JSONObject json = giacInquiryService.getBillsUnderAgeLevel(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsUnderAgeLevel/billsUnderAgeLevel.jsp";				
				}
				request.setAttribute("callFrom", request.getParameter("callFrom"));
				request.setAttribute("pathFrom", request.getParameter("pathFrom"));
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("selectedBranchCd", request.getParameter("selectedBranchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("selectedAgingId", request.getParameter("selectedAgingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
			}else if("showGIACS203SortPopUp".equals(ACTION)){ // jomsdiago 08.02.2013
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsUnderAgeLevel/billsUnderAgeSortPopUp.jsp";
			}else if("showGIACS206".equals(ACTION)){ // jomsdiago 08.02.2013
				JSONObject json = giacInquiryService.getBillsForGivenAssdDtls(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsForGivenAssd/billsForGivenAssd.jsp";				
				}
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
			}else if("showGIACS204".equals(ACTION)){ // jomsdiago 08.05.2013
				JSONObject json = giacInquiryService.getBillsAssdAndAgeLevel(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsAssdAndAgeLevel/billsAssdAndAgeLevel.jsp";				
				}
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("selectedBranchCd", request.getParameter("selectedBranchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("selectedAgingId", request.getParameter("selectedAgingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
				request.setAttribute("callFrom", request.getParameter("callFrom"));
			}else if("showGIACS204SortPopUp".equals(ACTION)){ // jomsdiago 08.05.2013
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("selectedBranchCd", request.getParameter("selectedBranchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("selectedAgingId", request.getParameter("selectedAgingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsAssdAndAgeLevel/billsAssdAndAgeLevelSortPopUp.jsp";
			}else if("showGIACS207".equals(ACTION)){ // jomsdiago 08.06.2013
				JSONObject json = giacInquiryService.getBillsForAnAssdDtls(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsForAnAssd/billsForAnAssd.jsp";				
				}
				request.setAttribute("fundCd", request.getParameter("fundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("agingId", request.getParameter("agingId"));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				request.setAttribute("fundDesc", request.getParameter("fundDesc"));
				request.setAttribute("branchName", request.getParameter("branchName"));
			}else if("showGIACS207SortPopUp".equals(ACTION)){ // jomsdiago 08.06.2013
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsForAnAssd/billsForAnAssdSortPopUp.jsp";
			}else if("showAssuredListAllPopUp".equals(ACTION)){ // jomsdiago 08.06.2013
				JSONObject json = giacInquiryService.showAssuredListAllPopUp(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsForAnAssd/assuredListAllPopUp.jsp";			
				}
				request.setAttribute("assdNo", request.getParameter("assdNo"));
			}else if("showAssuredListSortPopUp".equals(ACTION)){ // jomsdiago 08.06.2013
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				PAGE = "/pages/accounting/creditAndCollection/inquiry/billsForAnAssd/assuredListAllSortPopUp.jsp";
			
			// GIACS070:  shan 08.22.2013
			}else if("showViewJournalEntriesPage".equals(ACTION)){
				request.setAttribute("globalWithOp", giacInquiryService.giacs070WhenNewFormInstance());
				JSONObject json = giacInquiryService.viewJournalEntries(request, USER);
				if ("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalLedger/inquiry/viewJournalEntries/viewJournalEntries.jsp";
				}
			}else if("getOpInfo".equals(ACTION)){
				message = giacInquiryService.getOpInfoGiacs070(Integer.parseInt(request.getParameter("tranId"))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("chkPaytReqDtl".equals(ACTION)){
				message = giacInquiryService.chkPaytReqDtl(Integer.parseInt(request.getParameter("tranId")));
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDvInfoGiacs070".equals(ACTION)){
				JSONObject json = giacInquiryService.getDvInfoGiacs070(Integer.parseInt(request.getParameter("tranId")));
				System.out.println(json.toString());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
				// end GIACS070
			}else if("showCommissionInquiry".equals(ACTION)){
				JSONObject jsonComInquiry = giacInquiryService.showCommissionInquiry(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonComInquiry.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("dispOverridingComm", giisParameterFacadeService.getParamValueV2("DISPLAY_OVERRIDING_COMM"));
					request.setAttribute("jsonComInquiry", jsonComInquiry);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/commissionInquiry.jsp";
				}
			}else if("showGiacs221History".equals(ACTION)){
				JSONObject jsonHistory = giacInquiryService.showGiacs221History(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonHistory", jsonHistory);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/historyOverlay.jsp";
				}
			}else if("showGiacs221Detail".equals(ACTION)){
				JSONObject jsonDetail = giacInquiryService.showGiacs221Detail(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonDetail.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonDetail", jsonDetail);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/detailOverlay.jsp";
				}
			}else if("showGiacs221CommBreakdown".equals(ACTION)){
				JSONObject jsonCommBreakdown = giacInquiryService.showGiacs221CommBreakdown(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommBreakdown.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCommBreakdown", jsonCommBreakdown);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/commBreakdownOverlay.jsp";
				}
			}else if("showGiacs221ParentComm".equals(ACTION)){
				JSONObject jsonParentComm = giacInquiryService.showGiacs221ParentComm(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonParentComm.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonParentComm", jsonParentComm);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/parentCommOverlay.jsp";
				}
			}else if("showGiacs221PrintDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("showFileOption", request.getParameter("showFileOption"));
				PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/commInquiryPrintDialog.jsp";
			}else if("showUnreleaseCommOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/unreleaseCommOverlay.jsp";
			}else if("showNotStandardRtOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/generalDisbursements/inquiry/commissionInquiry/pop-ups/notStandardRtOverlay.jsp";
			}else if("showBillPerPolicy".equals(ACTION)){ // john dolon 8.15.2013
				JSONObject json = giacInquiryService.showBillPerPolicy(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPerPolicy/billPerPolicy.jsp";				
				}
				request.setAttribute("userId", USER.getUserId());
			}else if("showPremPayments".equals(ACTION)){
				JSONObject jsonPremPayments = giacInquiryService.showPremPayments(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPremPayments.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPremPayments", jsonPremPayments);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPerPolicy/billPerPolicyOverlay/premPayments.jsp";					
				}
			}else if("showCommPayments".equals(ACTION)){
				JSONObject jsonCommPayments = giacInquiryService.showCommPayments(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommPayments.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCommPayments", jsonCommPayments);
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billPerPolicy/billPerPolicyOverlay/commPayments.jsp";					
				}
			}else if("showBillsByIntermediary".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giacInquiryService.getBillsPerIntm(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					request.setAttribute("reload", request.getParameter("reload"));
					PAGE = "/pages/accounting/creditAndCollection/inquiry/billsByIntermediary/billsByIntermediary.jsp";
				}
			}else if("showGIACS240".equals(ACTION)){
				JSONObject json = giacInquiryService.showGIACS240(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("json", json);
					PAGE = "/pages/accounting/generalDisbursements/inquiry/checksPaidPerPayee/checksPaidPerPayee.jsp";
				}
			}else if("validateFundCdGiacs240".equals(ACTION)){
				message = giacInquiryService.validateFundCdGiacs240(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateBranchCdGiacs240".equals(ACTION)){
				message = giacInquiryService.validateBranchCdGiacs240(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePayeeClassCdGiacs240".equals(ACTION)){
				message = giacInquiryService.validatePayeeClassCdGiacs240(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePayeeNoGiacs240".equals(ACTION)){
				message = giacInquiryService.validatePayeeNoGiacs240(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showChecksPaidPerDepartment".equals(ACTION)){
				JSONObject json = giacInquiryService.getChecksPaidPerDept(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/inquiry/checksPaidPerDepartment/checksPaidPerDepartment.jsp";
				}
			}else if ("getDvAmount".equals(ACTION)) {
				message = (new JSONObject(giacInquiryService.getDvAmount(request, USER))).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}
		} catch (SQLException e) {
			/* modified by shan 08.23.2013
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";*/
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}
}
