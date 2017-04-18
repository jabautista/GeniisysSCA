package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.seer.framework.util.StringFormatter;

public class AccountingLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -419448722672930009L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		// common parameters
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("currentPage", Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
			params.put("findText", request.getParameter("filterText"));
		}
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		
		
		try {		
			// IMPORTANT: use the specified action for controller as the id for sqlMap select/procedure			
			// NOTE: format for lov action is : "get<Entity Name>LOV"
			
			// parameters per action
			if("getGIACBranchLOV".equals(ACTION)){
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));				
			} else if("getGIACSlListsLOV".equals(ACTION)) {
				System.out.println("acctg LOV controller - " + request.getParameter("slTypeCd"));
				params.put("slTypeCd", request.getParameter("slTypeCd"));
			} else if("getGIACBankLOV".equals(ACTION)){
				// No specific parameter for this lov
			} else if("getBillNoLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			} else if("getInstNoLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
			} else if("getGlAcctsLOV".equals(ACTION)) {
				Map<String, Object> searchMap = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("glObj")));
				params.putAll(searchMap);
				if("".equals(request.getParameter("findText")) || request.getParameter("findText") == null) {
					params.put("findText", request.getParameter("acctName"));
				}
			} else if("getAdvSeqNoLOV".equals(ACTION)) {
				params.put("moduleId", "GIACS017");
				params.put("userId", USER.getUserId());
				params.put("vIssCd", request.getParameter("vIssCd"));
				params.put("tranType", request.getParameter("tranType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("adviceYear", request.getParameter("advYear"));
				params.put("notIn2",request.getParameter("notIn2"));
			} else if("getPayeeClassLOV".equals(ACTION)) {
				params.put("ACTION", ACTION);
				params.put("tranType", request.getParameter("tranType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("claimId", request.getParameter("claimId"));
				System.out.println(ACTION+": "+params);
			} else if("getPayeeNamesLOV".equals(ACTION)){
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "payeeNo");
				}
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				System.out.println("ACTION: " + ACTION+"\n params : "+params);
			} else if("getAcctCodesChartLOV".equals(ACTION)){
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "dspAcctCd");
				}
				System.out.println("ACTION: " + ACTION+"\n params : "+params);
			} else if("getSlNameInputVatListsLOV".equals(ACTION)){
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "slCd");
				}
				params.put("slTypeCd", request.getParameter("slTypeCd"));
				System.out.println("ACTION: " + ACTION+"\n params : "+params);
			} else if("getPayorNameLOV".equals(ACTION)){
				params.put("ACTION", ACTION+request.getParameter("transactionType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("recYear", request.getParameter("recYear"));
				params.put("recSeqNo", request.getParameter("recSeqNo"));
			} else if("getChartOfAcctsLOV".equals(ACTION)) {
				Map<String, Object> searchMap = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("glObj")));
				params.putAll(searchMap);
				if("".equals(request.getParameter("findText")) || request.getParameter("findText") == null) {
					params.put("findText", request.getParameter("acctName"));
				}
			} else if("getOldItemDtlsLOV".equals(ACTION)) {
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("tranMonth", request.getParameter("tranMonth"));
				params.put("tranSeqNo", request.getParameter("tranSeqNo"));
				params.put("oldItemNo", request.getParameter("oldItemNo"));
				//params.put("notIn2", request.getParameter("notIn2"));
			}else if("getAccountCodeLOV".equals(ACTION)) {
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
			}else if("getParNoLOV".equals(ACTION)) { //edited by steven 12/18/2012
				params.put("assdNo", request.getParameter("assdNo"));
//				params.put("keyword", request.getParameter("findText"));
			}else if("getGIISReinsurerLOV3".equals(ACTION)){ 
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "riCd");
				}
			}else if("getGIISReinsurerLOV4".equals(ACTION)){ //added by steven 12/14/2012 for GIACS026 Reinsurer
			}else if("getSlListUnidentifiedCollnsLOV".equals(ACTION)){
				params.put("slTypeCd", request.getParameter("slTypeCd"));
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getCompanyLOV".equals(ACTION)){
				// No specific parameter for this lov
				params.put("searchString", request.getParameter("searchString")); //added by pol, 7.18.2013
			}else if("getGIACS003CompanyLOV".equals(ACTION)){  //added by steven 4/2/2013
				params.put("searchString", request.getParameter("searchString"));
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "initialOrder");
				}
			}else if("getBranchCd2LOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getGIACS003BranchLOV".equals(ACTION)){ //added by steven 3/25/2013
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "initialOrder");
				}
			}else if("getJVTranTypeLOV".equals(ACTION)){ //added by steven 3/25/2013
				params.put("jvTranTag", request.getParameter("jvTranTag"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISPayeeClass2LOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getPayeesLOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			}else if("getGiisCurrencyLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getRgDocumentCdClaimLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getRgDocumentCdNonClaimLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("paramName", request.getParameter("paramName"));
			}else if("getRgDocumentCdOtherLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getPayeeClassListLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getWhtaxCodeLOV".equals(ACTION)){
				params.put("gaccBranchCd", request.getParameter("gaccBranchCd"));
			}else if("getPayeeLOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			}else if("getSlListingByWhtaxIdLOV".equals(ACTION)){
				params.put("whtaxId",request.getParameter("whtaxId"));
			}else if("getRgDocumentCdAllLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getGiisLineLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString")); // added by pol cruz, 08-27-2013
			}else if("getGiacOucsLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getGiacIssCdLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
			}else if("getGiacRiIssCdLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getGiacAssdNameLOV".equals(ACTION)){
				params.put("keyword", request.getParameter("findText"));
				params.put("assdNo", request.getParameter("assdNo"));
			}else if("getGiacIntmNameLOV".equals(ACTION)){
				String searchString = request.getParameter("searchString");
				params.put("keyword", (searchString != null && !searchString.equals("")) ? searchString : request.getParameter("findText"));
			}else if("getGiacPolNoLOV".equals(ACTION)){ //edited by steven 12/18/2012
				params.put("assdNo", request.getParameter("assdNo"));
//				params.put("keyword", request.getParameter("findText"));
			}else if("getGiacOldItemNoLOV".equals(ACTION)){
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("controlModule", request.getParameter("controlModule"));
				params.put("keyword", request.getParameter("findText"));
				params.put("userId", USER.getUserId());
			}else if("getGiacOldItemNoFor4LOV".equals(ACTION)){	//shan 11.04.2013
				params.put("keyword", request.getParameter("findText"));
			}else if("getGiisCurrencyLOV".equals(ACTION)){
				params.put("keyword", request.getParameter("findText"));
			} else if("getGIACSInquiryFundLOV".equals(ACTION)){
				params.put("company", request.getParameter("company"));
			} else if("getGIACSInquiryBranchLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("branch", request.getParameter("branch"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("userId", USER.getUserId());
			} else if("getGIISIntmLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getReplenishNoLOV".equals(ACTION)){
				
			}else if("getFundCdLOV".equals(ACTION)){
				
			}else if("getCompany2LOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if ("getPrintDialogBranchLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("branch", request.getParameter("branch"));
				params.put("fundCd", request.getParameter("fundCd"));
			}else if ("getPrintDialogTranClassLOV".equals(ACTION)) {
				params.put("tranClass", request.getParameter("tranClass"));
			}else if ("getPrintDialogStatusLOV".equals(ACTION)) {
				params.put("status", request.getParameter("status"));
			}else if ("getAllOrStatusLOV".equals(ACTION)) {
				params.put("status", request.getParameter("status"));
			}else if ("getGIACS237FundLOV".equals(ACTION)){
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if ("getGIACS237BranchLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if ("getBranchLOV".equals(ACTION)){
				// no specific parameters for this action
				// GIACS312, 
			}else if("getRecipientsLOV".equals(ACTION)){
				// for GIACS071 recipient list - no specific parameters
			}else if ("getReplenishmentBranchLOV".equals(ACTION)) {		//added by Gzelle 04162013
				params.put("branch", request.getParameter("branch"));
				params.put("appUser", USER.getUserId());
			}else if("getGIACS002CompanyLOV".equals(ACTION)){
				// no specific parameters
			}else if("getGIACS002BranchLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getGIACS002DocumentLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getDocSeqNoLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("docYear", Integer.parseInt(request.getParameter("docYear")));
				params.put("docMm",Integer.parseInt( request.getParameter("docMm")));
				
			}else if("showGIUTS022PolicyLOV".equals(ACTION)){	//Kenneth L. 04.23.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));	
				params.put("userId", USER.getUserId());
			}else if("getGlAcctsGIACS230LOV".equals(ACTION)){		//added by Shan 04.22.2013
				params.put("glAcctCategory", request.getParameter("glAcctCat"));
				params.put("glControlAcct", request.getParameter("glCtrlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
				params.put("searchString", request.getParameter("searchString"));
				System.out.println("GIACS230 GL Acct Params: "+params.toString());
			}else if("getGIACS230BranchLOV".equals(ACTION)){	//added by Shan 04.22.2013
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS092FundLOV".equals(ACTION)) {
				params.put("ACTION", "getGIACSFundLOV2");
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS092BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS408BillNoLOV".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGIACS408IntmNoLOV".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getLineGIUTS022LOV".equals(ACTION)) {				//added by: Kenneth L. 04.24.2013
				params.put("search", request.getParameter("search"));
				params.put("userId", USER.getUserId());
			}else if("getSublineGIUTS022LOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("search", request.getParameter("search"));
			}else if("getIssGIUTS022LOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
				params.put("userId", USER.getUserId());
			}else if("getEndtIssGIUTS022LOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			}else if("getPaytermGIUTS022LOV".equals(ACTION)) {
				// no specific parameters
			} else if("getGIACS002BanksLOV".equals(ACTION)){
				/*if(request.getParameter("findText2").trim() != ""){
					params.put("findText2", request.getParameter("findText2"));
				}*/
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("mirBranchCd", request.getParameter("mirBranchCd"));
			} else if("getCheckClass3".equals(ACTION)){
				// no specific params :: for retrieving check class list for GIACS002
			} else if("getCheckStat".equals(ACTION)){
				// no specific params :: for retrieving check stat list for GIACS002
			} else if("getGIACS045DocumentCdLov".equals(ACTION)) {
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS045BranchCdLov".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("documentCd", request.getParameter("documentCd"));
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS045BranchCdLov2".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS045LineLov".equals(ACTION)) {
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS045DocYearLov".equals(ACTION)) {
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS045DocSeqNoLov".equals(ACTION)) {
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("docYear", request.getParameter("docYear"));
				params.put("docMm", request.getParameter("docMm"));
				params.put("docSeqNo", request.getParameter("docSeqNo"));
				/*if(request.getParameter("searchString").trim() != "")
					params.put("searchString", request.getParameter("searchString"));*/

			} else if("getGIACS180BranchCdLov".equals(ACTION)){
				if(request.getParameter("filterText") != null &&request.getParameter("filterText").trim() != "")
					params.put("filterText", request.getParameter("filterText"));
			} else if("getGiacs180AssdLOV".equals(ACTION)){
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").trim().equals("")){
					params.put("filterText", request.getParameter("filterText"));
				}
			}else if("getGiacs180AssdLOV2".equals(ACTION)){
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").trim().equals("")){
					params.put("filterText", request.getParameter("filterText"));
				}
				params.put("userId", USER.getUserId());
			} else if("getGIACS512IntmNoLOV".equals(ACTION)){
				//if(request.getParameter("searchString").trim() != "") modified by pol cruz, 08-27-2013
					params.put("searchString", request.getParameter("searchString"));
			} else if("getIntmType2LOV".equals(ACTION)){
				
			} else if("getGIACS180IntmNoLOV".equals(ACTION)){
				params.put("intmType", request.getParameter("intmType").equals("") ? null : request.getParameter("intmType"));
				if(request.getParameter("filterText").trim() != "")
					params.put("filterText", request.getParameter("filterText"));

			} else if("getGIACS180IntmNoLOV2".equals(ACTION)){
				params.put("intmType", request.getParameter("intmType").equals("") ? null : request.getParameter("intmType"));
				if(request.getParameter("filterText").trim() != "")
					params.put("filterText", request.getParameter("filterText"));
					params.put("userId", USER.getUserId());
			} else if("getGiisIntermediaryLov".equals(ACTION)) {
				params.put("intmType", request.getParameter("intmType"));
				params.put("findText2", request.getParameter("findText2"));
			} else if("getGiisIntmTypeLov".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			} else if("getGiisAssuredLov".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			} else if("getGIACS221AssuredLOV".equals(ACTION)) {//Added by pjsantos 11/28/2016, to get list of assured's GENQA 5857 
				params.put("findText", request.getParameter("findText"));	
				params.put("billIssCd", request.getParameter("billIssCd"));	
			} else if("getCgRefCodesLov".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			} else if("getBancaTypeLov".equals(ACTION)) {
				
			} else if("getGIARDC01CashierLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("dcbNo", request.getParameter("dcbNo"));
				params.put("dcbYear", request.getParameter("dcbYear"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getTranYearLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getTranMonthLOV".equals(ACTION)) {
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("findText2", request.getParameter("findText2"));
			} else if("getBancIntmLov".equals(ACTION)) {
				params.put("paramIntmType", request.getParameter("paramIntmType"));
			} else if ("getGIACS051BranchCdFromLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS051DocYearLOV".equals(ACTION)) {
				params.put("branchCdFrom", request.getParameter("branchCdFrom"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS051DocSeqNoLOV".equals(ACTION)) {
				params.put("branchCdFrom", request.getParameter("branchCdFrom"));
				params.put("docYear", request.getParameter("docYear"));
				params.put("docMm", request.getParameter("docMm"));
				params.put("docSeqNo", request.getParameter("docSeqNo"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS051BranchCdToLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS410TranYearLOV".equals(ACTION)){	//shan 05.27.2013
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIACS410TranMonthLOV".equals(ACTION)){ //shan 05.27.2013
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS155IntmLov".equals(ACTION)) {
				if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
					params.put("findText", request.getParameter("filterText"));
				}
			} else if ("getGIACS155FundLov".equals(ACTION)) {
				if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
					params.put("findText", request.getParameter("filterText"));
				}
				params.put("userId", USER.getUserId());
				params.put("intmNo", request.getParameter("intmNo"));
			} else if ("getGIACS155BranchLov".equals(ACTION)) {
				if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
					params.put("findText", request.getParameter("filterText"));
				}
				params.put("userId", USER.getUserId());
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("fundCd", request.getParameter("fundCd"));
			} else if("getGIACS052ChecksLOV".equals(ACTION)){
				params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
			}else if("getGIACS015AccountCdLov".equals(ACTION)) {			//kenneth L. 06.10.2013
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
			}else if("getGIACS015SlCdLov".equals(ACTION)) {			//kenneth L. 06.10.2013
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("slTypeCd", request.getParameter("slTypeCd"));
				params.put("slCd", request.getParameter("slCd"));
			}else if("getGIACS015TranTypeLov".equals(ACTION)) {			//kenneth L. 06.10.2013
				params.put("transactionType", request.getParameter("transactionType"));
			}else if("getGIACS015OldTranIdLov".equals(ACTION)) {			//kenneth L. 06.10.2013
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("tranMonth", request.getParameter("tranMonth"));
				params.put("tranSeqNo", request.getParameter("tranSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
			} else if("getGiacs106LineLOV".equals(ACTION)) {
				params.put("riCd", request.getParameter("riCd"));
				params.put("findText2", request.getParameter("findText2"));
			} else if("getGiacs106RiLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs105LineLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs105RiLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs119LineLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs119RiLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs181LineLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs181RiLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs183LineLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs183RiLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs138SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs138LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs138BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs111LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("issCd", request.getParameter("issCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs111BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs151ReportLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getRiBillNoLOV".equals(ACTION)){ //mikel //editted by johndolon 7.25.2013
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("findBillNo", request.getParameter("findBillNo"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("dueDate", request.getParameter("dueDate"));	// added by shan 11.11.2014
				params.put("inceptDate", request.getParameter("inceptDate"));	// added by shan 11.11.2014
				params.put("issueDate", request.getParameter("issueDate"));	// added by shan 11.11.2014
				params.put("expiryDate", request.getParameter("expiryDate"));	// added by shan 11.11.2014
			}else if ("getGIACS049CompanyLOV".equals(ACTION)){	//added by shan 06.07.2013
				params.put("keyword", request.getParameter("gibrGfunFundCd"));
			}else if ("getGIACS049BranchLOV".equals(ACTION)){	//added by shan 06.07.2013
				params.put("keyword", request.getParameter("gibrBranchCd"));
				params.put("userId", USER.getUserId()); //added by steven 09.30.2014
			}else if("getReinsurerLOV".equals(ACTION)){
				params.put("findReinsurer", request.getParameter("findReinsurer"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiisAssuredLov2".equals(ACTION)){
				params.put("findAssured", request.getParameter("findAssured"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getPolicyNoLOV2".equals(ACTION)){
				params.put("findPolicyNo", request.getParameter("findPolicyNo"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd")); //end mikel
				params.put("issueYy", request.getParameter("issueYy")); //added by johndolon 7.25.2013
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo")); //end john
			}else if("getGIACTaxesLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getGIACSlLOV".equals(ACTION)){
				params.put("slTypeCd", request.getParameter("slTypeCd"));
			}else if("getCreditMemoDtlsList".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("memoType", request.getParameter("memoType"));
				params.put("payMode", request.getParameter("payMode"));
			}else if("getGIACS117BranchLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("moduleId", "GIACS117");
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS072MemoTypeLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS072BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS127BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIACS093BranchLOV".equals(ACTION)){ 	// shan 06.17.2013
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS170BranchLOV".equals(ACTION)){	//shan 06.19.2013
				params.put("moduleId", "GIACS170");
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getLineCdLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIACS178BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("fetchSimpleBranchLOVNoRI".equals(ACTION)){ //added by vondanix 10.06.2015 SR 5019
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("riIssCd", request.getParameter("riIssCd"));
				params.put("userId", USER.getUserId());
			}else if("fetchSimpleBranchLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("userId", USER.getUserId());
			}else if("getGIACS147BranchLov".equals(ACTION)){	//added by kenneth L. 06.25.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if("getGIACS147AssuredLov".equals(ACTION)){	//added by kenneth L. 06.25.2013
				params.put("search", request.getParameter("search"));
			}else if("getGIACS147DepFlagLov".equals(ACTION)){	//added by kenneth L. 06.25.2013
				params.put("search", request.getParameter("search"));
			}else if("fetchSimpleLineLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
			}else if ("getPremAssumedRiLOV".equals(ACTION)) {		// -gzelle 06.18.2013
//				params.put("riCd",  request.getParameter("riCd") == "" ? null : Integer.parseInt(request.getParameter("riCd")));
//				params.put("riName", request.getParameter("riName"));
				params.put("search", request.getParameter("search"));
			}else if ("getPremAssumedLineLOV".equals(ACTION)) {		// -gzelle 06.18.2013
//				params.put("lineCd", request.getParameter("lineCd"));
//				params.put("lineName", request.getParameter("lineName"));
				params.put("search", request.getParameter("search"));
			}else if("getGIACS078BranchLOV".equals(ACTION)){ // shan 06.25.2013
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS078IntmLOV".equals(ACTION)){	//shan 06.23.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("fetchRequestLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
			}else if ("getGIACS281BankAcctLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIACS281BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS118BranchLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));				
			}else if("getGIACS135BranchLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText") );
				}
			}else if("getGIACS184BranchLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS413IntmTypeLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("filterText"));
			}else if ("getGIACS127TranClass".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				if(request.getParameter("chkInclude").equals("true"))
					params.put("chkInclude", true);
			}else if ("getGIACS127JVTran".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS135BankAcctNoLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText") );
				}
				params.put("moduleId", request.getParameter("moduleId"));
			}else if("getGIACS273BranchLOV".equals(ACTION)){	//shan 06.28.2013
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS273DocLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getPremCededTreatyLOV".equals(ACTION)) {		//-gzelle 07.01.2013
				params.put("quarter", request.getParameter("quarter").equals("") ? null : request.getParameter("quarter"));
				params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
				params.put("lineCd", request.getParameter("lineCd"));
				//params.put("shareCd", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
				//params.put("treatyName", request.getParameter("treatyName"));
				params.put("search", request.getParameter("search"));
			}else if ("getPremCededLineLOV".equals(ACTION)) {
				params.put("quarter", request.getParameter("quarter").equals("") ? null : request.getParameter("quarter"));
				params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
				//params.put("lineCd", request.getParameter("lineCd"));
				//params.put("lineName", request.getParameter("lineName"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if("getBranchGiacs328Lov".equals(ACTION)){	//added by kenneth L. 07.02.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));			
			}else if("getGiisLineLOV3".equals(ACTION)){		//shan 07.01.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISReinsurerLOV5".equals(ACTION)){	//shan 07.02.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if("fetchEmployeeLOV".equals(ACTION)){ //joms 07.09.2013
				params.put("companyCd", request.getParameter("companyCd"));
			}else if("getBranchGiacs108LOV".equals(ACTION)){ // bonok :: 07.18.2013
				
			}else if("getLineGiacs108LOV".equals(ACTION)){ // bonok :: 07.18.2013
				
			}else if ("getBranchPerFundLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIACS060GLAcctCdLOV".equals(ACTION)) {
				if(request.getParameter("glAcctId").equals("")) {
					params.put("glAcctCategory", request.getParameter("glAcctCategory"));
					params.put("glControlAcct", request.getParameter("glControlAcct"));
					params.put("glSubAcct1", request.getParameter("glSubAcct1"));
					params.put("glSubAcct2", request.getParameter("glSubAcct2"));
					params.put("glSubAcct3", request.getParameter("glSubAcct3"));
					params.put("glSubAcct4", request.getParameter("glSubAcct4"));
					params.put("glSubAcct5", request.getParameter("glSubAcct5"));
					params.put("glSubAcct6", request.getParameter("glSubAcct6"));
					params.put("glSubAcct7", request.getParameter("glSubAcct7"));
				}
			}else if("getGIACS060TranClassLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiacs286IssLov".equals(ACTION)){	//added by kenneth L. 07.16.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));			
			}else if("getGiacs286LineLov".equals(ACTION)){	//added by kenneth L. 07.16.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));			
			}else if("getGiacs286IntmLov".equals(ACTION)){	//added by kenneth L. 07.16.2013
				params.put("search", request.getParameter("search"));			
			}else if("getGiacs286AssdLov".equals(ACTION)){	//added by kenneth L. 07.16.2013
				params.put("search", request.getParameter("search"));
			}else if("getGIACS274BranchLOV".equals(ACTION)){	//added by shan 07.25.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getFileSourceLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getFileSourceLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));	
			}else if("getPayeeGiacs110LOV".equals(ACTION)){
				
			}else if("getGiacs502BranchLov".equals(ACTION)){	//added by kenneth L. 07.26.2013
				params.put("search", request.getParameter("search"));	
			}else if("getSOAFaculRiLineLOV".equals(ACTION)){	//added by Gzelle 07.22.2013
				params.put("riCd",  request.getParameter("riCd") == "" ? null : Integer.parseInt(request.getParameter("riCd")));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if("getSOAFaculRiLOV".equals(ACTION)){		//added by Gzelle 07.22.2013
				params.put("search", request.getParameter("search"));	
			}else if("getGiacs101SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs101LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("issCd", request.getParameter("issCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs101BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				if (request.getParameter("moduleId").equals("GIACS221") && params.get("sortColumn") == null) {
					params.put("sortColumn", "branchCd");
				}
				params.put("findText2", request.getParameter("findText2"));
			}else if("getRiList".equals(ACTION)){
				params.put("riCd", request.getParameter("riCd"));
			}else if("getLineList".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getTaxGiacs110LOV".equals(ACTION)){

			}else if("getPayeeNoGiacs110LOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			}else if("getGIACS149IntmLOV".equals(ACTION)){	//shan 08.01.2013
				params.put("workflowColVal", request.getParameter("workflowColVal"));
				params.put("userId", USER.getUserId());
				params.put("keyword", request.getParameter("keyword"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS149FundLOV".equals(ACTION)){	//shan 08.01.2013
				params.put("keyword", request.getParameter("keyword"));
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS149BranchLOV".equals(ACTION)){	//shan 08.01.2013
				params.put("keyword", request.getParameter("keyword"));
				params.put("userId", USER.getUserId());
			}else if("getAgingLevelListLOV".equals(ACTION)){ // J. Diago 08.06.2013
				// parameters here if any.
			}else if("getGIACS056LineLOV".equals(ACTION)){
				//no parameters
			}else if("getGiacBankLOV".equals(ACTION)){
				//no parameters
			}else if("getGiacBankAcctLOV".equals(ACTION)){
				params.put("bankCd", request.getParameter("bankCd"));
			}else if("getCheckDvPrintLOV".equals(ACTION)){
				//no parameters
			}else if("getGIACS102LineLOV".equals(ACTION)){
				//params.put("searchString", request.getParameter("searchString"));
			}else if("getGiacs190BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs221IntermediaryLov".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs221IssCdLov".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
			}else if("getGiacs221BillLov".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? request.getParameter("objFilter2") :request.getParameter("objFilter"));
			}else if("getGiacs221LineLOV".equals(ACTION)) {
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "lineCd");
				}
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs221IntmLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs221Intermediary2Lov".equals(ACTION)) {
				params.put("intmType", request.getParameter("intmType"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("showBillPerPolicyLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("moduleId", request.getParameter("moduleId"));
			}else if ("getBranchLOVInAcctrans".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getIntmType3LOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIACS153IntmNoLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS054BranchLOV".equals(ACTION)){
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS054BankLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if ("getBasicIsSourceLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS288IntmLOV".equals(ACTION)){
				params.put("intmType", request.getParameter("intmType"));
			} else if("getGlAcctCodeLOV".equals(ACTION) || "getGlAcctCodeLOV2".equals(ACTION)) {
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
			}else if("getPayeeGiacs240LOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS240BranchLOV".equals(ACTION)){
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getAllIssourceLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGiisLineLOV2".equals(ACTION)){
				
			}else if("getFundChecksPaidDeptLOV".equals(ACTION)){	//added by Gzelle 09.20.2013
				params.put("search", request.getParameter("search"));
			}else if("getBranchChecksPaidDeptLOV".equals(ACTION)){	//added by Gzelle 09.20.2013
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));	
			}else if("getOucChecksPaidDeptLOV".equals(ACTION)){		//added by Gzelle 09.20.2013
				params.put("search", request.getParameter("search").equals("") ? null:Integer.parseInt(request.getParameter("search")));	
			}else if("getPayeeClassGiacs240LOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiacs414BranchLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("findText2", request.getParameter("findText2"));
			}else if("copyBudgetPushedLovYear".equals(ACTION)) { // Added by J. Diago 09.26.2013
				// parameters here if any..
			}else if("getGIACS276LineLOV".equals(ACTION)){	//added by john dolon 9.30.2013
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIACS202BranchLOV".equals(ACTION)){ // J. Diago 10.01.2013
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getGiacsDynamicBranchLOV".equals(ACTION)) { // J. Diago 10.02.2013
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiacs035DcbDateLOV".equals(ACTION)){
				params.put("gaccGfunFundCd", request.getParameter("gaccGfunFundCd"));
				params.put("gaccGibrBranchCd", request.getParameter("gaccGibrBranchCd"));
			}else if("getGiacs035DcbNoLOV".equals(ACTION)){
				params.put("gaccGfunFundCd", request.getParameter("gaccGfunFundCd"));
				params.put("gaccGibrBranchCd", request.getParameter("gaccGibrBranchCd"));
				params.put("dcbDate", request.getParameter("dcbDate"));
				params.put("dcbYear", request.getParameter("dcbYear"));
			}else if("getGIACS053BranchLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			}else if("getGeneralBranchLOV".equals(ACTION)){ // J. Diago 10.21.2013
				// parameters if any.	
			}else if("getIntmTypeGIACS158".equals(ACTION)){	//added by Gzelle 10.24.2013
				params.put("search", request.getParameter("search"));	
			}else if("getIntmGIACS158".equals(ACTION)){		//added by Gzelle 10.24.2013
				params.put("intmType", request.getParameter("intmType"));
				params.put("search", request.getParameter("search").equals("") ? null:Integer.parseInt(request.getParameter("search")));	
			}else if("getGiacs360YearLOV".equals(ACTION)){	//added by Gzelle 12.2.2013
				params.put("search", request.getParameter("search"));	
			}else if("getGiacs360MonthLOV".equals(ACTION)){	//added by Gzelle 12.2.2013
				params.put("search", request.getParameter("search"));					
			}else if("getGiacs360IssLOV".equals(ACTION)){	//added by Gzelle 12.2.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));	
			}else if("getGiacs360LineLOV".equals(ACTION)){	//added by Gzelle 12.2.2013
				params.put("userId", USER.getUserId());
				params.put("issCd", request.getParameter("issCd"));
				params.put("search", request.getParameter("search"));	
			}else if("getGiacs311SlTypeRecList".equals(ACTION)){	//added by Gzelle 1.2.2014
				params.put("search", request.getParameter("search"));	
			}else if("getGiacs311AcctTypeRecList".equals(ACTION)){	//added by Gzelle 1.2.2014
				params.put("acctType", request.getParameter("acctType"));
				params.put("search", request.getParameter("search"));					
			}else if("getGIACS299BranchLOV".equals(ACTION)){
				
			}else if("getGIACS299LineLOV".equals(ACTION)){
				
			}else if("getGiacs335LOV".equals(ACTION)){
				//no specific parameters
			}else if("getGiacs316BranchLOV".equals(ACTION)){
				params.put("docCode", request.getParameter("docCode"));
				//if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText"));
				//}
			}else if("getGiacs316UserCdLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("filterText", request.getParameter("filterText"));
			}else if("getGiiss204LineLOV".equals(ACTION)){ // Fons 10.25.2013
				params.put("searchString", request.getParameter("searchString"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			}else if("getGiacs008InstNoLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("riCd", request.getParameter("riCd"));
			} else if("getGiacs322CompanyLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			} else if("getGiacs322BranchLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getGiacs321GiacModulesLOV".equals(ACTION)){
				
			} else if("showGiacs035CurrencyLov".equals(ACTION)){
				params.put("shortName", request.getParameter("shortName"));
			/*} else if("getGiacs351GlAcctLov".equals(ACTION)){
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glAcctControlAcct", request.getParameter("glAcctControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));*/
			} else if ("getGiacs310FundCdLOV".equals(ACTION)) {
				
			} else if ("getGiacs310BranchCdLOV".equals(ACTION)) {
				
			} else if ("getGiacs310BranchCdToLOV".equals(ACTION)) {
				
			} else if ("getGiacs310BranchCdFromLOV".equals(ACTION)) {
				
			} else if ("getGIACS301ParamTypeLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGiacs314ModuleLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			} else if ("getGiacs314TableLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			} else if ("getGiacs314ColumnLOV".equals(ACTION)){
				params.put("tableName", request.getParameter("tableName"));
				params.put("search", request.getParameter("search"));
			} else if ("getGiacs314DisplayLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			}else if ("getGiacs319CompanyLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("userId", USER.getUserId());
			}else if ("getGiacs319DcbUserLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGiacs319BankLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGiacs319BankAcctLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("bankCd", request.getParameter("bankCd"));
			} else if ("getGiacs317ScrnRepTagLOV".equals(ACTION)){

			} else if ("showGiacs329IntmLov".equals(ACTION)){
				params.put("intmType", request.getParameter("intmType"));
			}else if ("getGiacs315ModuleLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGiacs315FunctionLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("moduleId", request.getParameter("moduleId"));
			}else if ("getGiacs315UserLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGiacs309SlTypeLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS038CompanyLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIACS038BranchLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("showGiacs480EmployeeLov".equals(ACTION)){
				params.put("companyCd", request.getParameter("companyCd"));
			} else if("getGiardc01DcbNoLov".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("dcbYear", request.getParameter("dcbYear"));
				params.put("dcbNo", request.getParameter("dcbNo"));
				params.put("dcbDate", request.getParameter("dcbDate"));
				params.put("cashierCd", request.getParameter("cashierCd"));
				params.put("cashierName", request.getParameter("cashierName"));
			}else if("getBankLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getBankAcctLOV".equals(ACTION)){
				params.put("bankCd", request.getParameter("bankCd"));
			}else if("getGiacs091BranchLOV".equals(ACTION)){	//added by john dolon 07.04.2014
				params.put("search", request.getParameter("search"));
			}else if("getGiacs091BankCdLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			}else if("getGiacs091BankAcctLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("bankCd", request.getParameter("bankCd"));
			}else if("getGiacs032FundCdLOV".equals(ACTION)){

			}else if("getGiacs032BranchCdLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
			}else if("getGiacs032CurrencyLOV".equals(ACTION)){
				
			}else if("getGiacs032BankLOV".equals(ACTION)){
				
			}else if("getGiacs031BillLOV1".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("search", request.getParameter("search"));
			}else if("getGiacs031BillLOV2".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("search", request.getParameter("search"));
			}else if("getGiacs031BillLOV3".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("search", request.getParameter("search"));
			}else if("getGiacs031BillLOV4".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("search", request.getParameter("search"));
			}else if("getGiacs031InstLOV1".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
			}else if("getGiacs031InstLOV2".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
			}else if("getGiacs031InstLOV3".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
			}else if("getGiacs031InstLOV4".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
			} else if("getGiacs031PolicyList".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issYy", request.getParameter("issYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("refPolNo", request.getParameter("refPolNo"));
				params.put("dueSw", request.getParameter("dueSw"));
			}  else if("getBillNoLOVPerTranType".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
				params.put("notIn", request.getParameter("notIn"));	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			}else if("getSLCodeLOV".equals(ACTION)){
				params.put("glAcctId", request.getParameter("glAcctId"));
			}else if("getGiacs001CancelledOr".equals(ACTION)){
				
			} else if("getGiacs211IssCdLov".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
			} else if("getGiacs040BillNoLOV".equals(ACTION)) {
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("tranType", request.getParameter("tranType"));
			}else if("getGiacs020IssCdLOV".equals(ACTION)) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
				params.put("moduleId", request.getParameter("moduleId"));
			}else if("getGIACS605SourceLOV".equals(ACTION)){ // Dren Niebres 10.03.2016 SR-4572: Added LOV for GIACS605 - Start
				params.put("search", request.getParameter("search"));										
			}else if("getGIACS605TransactionLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			}else if("getGIACS605FilenameLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("sourceCd", request.getParameter("sourceCd"));
				params.put("transactionType", request.getParameter("transactionType")); // Dren Niebres 10.03.2016 SR-4572: Added LOV for GIACS605 - End		
			}else if("getGIACS606SourceLOV".equals(ACTION)){ // Dren Niebres 10.03.2016 SR-4573: Added LOV for GIACS606 - Start
				params.put("search", request.getParameter("search"));	
			}else if("getGIACS606TransactionLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));				
			}else if("getGIACS606FilenameLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("sourceCd", request.getParameter("sourceCd"));
				params.put("transactionType", request.getParameter("transactionType"));				
			}else if("getGIACS606StatusLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("transactionType", request.getParameter("transactionType"));	
			}else if("getGIACS606Status2ALOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("transactionType", request.getParameter("transactionType"));	
			}else if("getGIACS606Status2BLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("transactionType", request.getParameter("transactionType"));	//Dren Niebres 10.03.2016 SR-4573: Added LOV for GIACS606 - End				
			}
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params)); //escapeHTMLInMap added by shan : 03.06.2014
			message = json.toString();					
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
