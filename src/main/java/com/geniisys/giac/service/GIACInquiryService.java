/***************************************************
\ * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Create Date	:	03.01.2013
 ***************************************************/
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACInquiryService {
	//transaction status
	JSONObject showTransactionStatus (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showTranStatHist (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showOrStatus (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showOrHistory (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showCheckReleaseInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//lara
	JSONObject showDVStatus(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException, ParseException;
	JSONObject showStatusHistory(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException, ParseException;

	
	JSONObject showPaymentRequestStatus (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showPaymentRequestHistory (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GL Account Transaction GIACS230
	JSONObject showGLAccountTransaction(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getSlSummary(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIACS092
	JSONObject showPDCPayments (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showGIACS092Details (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showGIACS092Replacement (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showBillPayment(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject getGIACS211GipiInvoice(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject getGIACS211PolicyLov(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException; // Dren 06292015 : SR 0004613 - Added LOV for policy no.
	JSONObject getGIACS211PackPolicyLov(HttpServletRequest request,	GIISUser USER) throws SQLException, JSONException; // andrew - 07242015 - SR 19643
	JSONObject getGIACS211GiacDirectPremCollns(HttpServletRequest request,GIISUser USER)throws SQLException, JSONException;
	JSONObject showPremiumOverlay(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showTaxesOverlay(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showPDCPaymentsOverlay(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showBalancesOverlay(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	
	//GIACS202 jomsdiago 07.31.2013
	JSONObject getBillsByAssdAndAgeDetails (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showAgingListAllPopUp (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIACS203 jomsdiago 08.01.2013
	JSONObject getBillsUnderAgeLevel (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIACS206 jomsdiago 08.01.2013
	JSONObject getBillsForGivenAssdDtls (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIACS204 jomsdiago 08.05.2013
	JSONObject getBillsAssdAndAgeLevel (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIACS207 jomsdiago 08.06.2013
	JSONObject getBillsForAnAssdDtls (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showAssuredListAllPopUp (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showCommissionInquiry(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showGiacs221History(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showGiacs221Detail(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showGiacs221CommBreakdown(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showGiacs221ParentComm(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	
	//GIACS070 shan 08.23.2013
	String giacs070WhenNewFormInstance() throws SQLException;
	JSONObject viewJournalEntries(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Integer getOpInfoGiacs070(Integer tranId) throws SQLException;
	String chkPaytReqDtl(Integer tranId) throws SQLException;
	JSONObject getDvInfoGiacs070(Integer tranId) throws SQLException;
	
	//GIACS289 john dolon 8.16.2013
	JSONObject showBillPerPolicy(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject showPremPayments (HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showCommPayments (HttpServletRequest request) throws SQLException, JSONException;

	JSONObject getBillsPerIntm(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGIACS240(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String validateFundCdGiacs240(HttpServletRequest request, String userId) throws SQLException;
	String validateBranchCdGiacs240(HttpServletRequest request, String userId) throws SQLException;
	String validatePayeeClassCdGiacs240(HttpServletRequest request) throws SQLException;
	String validatePayeeNoGiacs240(HttpServletRequest request) throws SQLException, JSONException;
	
	JSONObject getChecksPaidPerDept(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> getDvAmount (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGiacs211BillDetails(HttpServletRequest request, GIISUser USER) throws SQLException; // andrew - 08042015 - SR 19643
	
}
