/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIPolbasic;


/**
 * The Interface GIPIPolbasicService.
 */
public interface GIPIPolbasicService {
	
	/**
	 * Gets the ref open pol no.
	 * 
	 * @param params the params
	 * @return the ref open pol no
	 * @throws SQLException the sQL exception
	 */
	String getRefOpenPolNo(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getPolbasicForOpenPolicy(String linecd, Integer assdNo, String inceptionDate, String expiryDate) throws SQLException;

	/**
	 * Extracts the latest expiry date in case there is an endorsement of expiry
	 * @param parId The Par ID
	 * @return
	 * @throws SQLException
	 */
	Date extractExpiryDate(int parId) throws SQLException;
	
	/**
	 * Gets the effectivity date (in string format) if particular item has been endorsed.
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @return The effectivity date if item has been endorsed. Otherwise, none.
	 * @throws SQLException
	 */
	String getBackEndtEffectivityDate(int parId, int itemNo) throws SQLException;
	
	GIPIPolbasic getPolicyDetails(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getEndtPolicy(int parId) throws SQLException;	
	Integer getExtractId() throws SQLException;
	void populateGixxTables(Map<String, Object> params) throws SQLException;
	void populateGixxTableWPolDoc(Map<String, Object> params) throws SQLException;
	void populatePackGixxTables(Map<String, Object> params) throws SQLException;
	void populatePackGixxTableWPolDoc(Map<String, Object> params) throws SQLException;

	/**
	 * Retrieves three addresses from gipi_polbasic, for the specified policy.
	 * @param params The parameters needed for the query
	 * @return The updated map with the three addresses.
	 * @throws SQLException
	 */
	Map<String, Object> getAddressForNewEndtItem(Map<String, Object> params) throws SQLException;
	void updatePrintedCount(Map<String, Object> params) throws SQLException;
	
	/**
	 * Check if there is an existing claim.
	 * @param premseqno, isscd
	 * @throws SQLException the sQL exception
	 */
	String checkClaim(Map<String, Object> params) throws SQLException;
	
	Integer getMaxEndtItemNo(Map<String, Object> params) throws SQLException;
	PaginatedList getPolicyForEndt(Map<String, String> params, int pageNo) throws SQLException;
	String isPolExist(Map<String, Object> params) throws SQLException;
	PaginatedList getPolicyListing(Map<String, Object> params) throws SQLException;
	String getBillNotPrinted(Integer policyId, String polFlag, String lineCd) throws SQLException;
	
	/**
	 * Gets the records for LOV CGFK$GIPD_LINE_CD
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getGipdLineCdLov(Integer pageNo, String keyword) throws SQLException;
	
	
	/**
	 * Gets the policy information records with endtSeqNo = 0
	 * @param  lineCd,sublineCd,issCd,issueYy,polSeqNo,renewNo,
	 * 		    refPolNo,nbtLineCd,nbtIssCd,nbtParYy,nbtParSeqNo,
	 * 		    nbtQuoteSeqNo 
	 * @returns paginated list of policies(with endtSeqNo = 0) 
	 * @throws  SQLException 
	 */
	PaginatedList getPolicyInformation(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the policy information records related to a 
	 * 		    policy with endtSeqNo = 0
	 * @param   lineCd,sublineCd,issCd,issueYy,polSeqNo,renewNo,
	 * 		    refPolNo,nbtLineCd,nbtIssCd,nbtParYy,nbtParSeqNo,
	 * 		    nbtQuoteSeqNo
	 * @returns HashMap that contains a list of policies
	 * @throws  SQLException 
	 */
	HashMap<String, Object> getRelatedPolicies(HashMap<String, Object> params) throws SQLException, JSONException, ParseException ;
	
	/**
	 * Retrieves the Main information of a policy
	 * @returns policyId,labelTag,lineCd,assdName,acctOf,polNo,endtNo
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyMainInformation(Integer policyId) throws SQLException;
	
	/**
	 * Retrieves the all the basic informations of a policy
	 * @param   policyId
	 * @returns basic informations of a policy
	 * @throws SQLException
	 */
	HashMap<String, Object> getPolicyBasicInformation(Integer policyId) throws SQLException;
	
	/**
	 * Retrieves the all the basic informations of a policy
	 * 		    with lineCd equal to SU
	 * @param   policyId,lineCd
	 * @returns basic informations of a policy
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyBasicInformationSu(Integer policyId) throws SQLException;
	
	/**
	 * Returns bank payment details
	 * @param   policyId
	 * @returns companyCd,employeeCd,bankRefNo,companyName,employeeName
	 * @throws  SQLException
	 */
	GIPIPolbasic getBankPaymentDtl(Integer policyId) throws SQLException;
	
	/**
	 * Returns bancassurance details
	 * @param   policyId
	 * @returns bancTypeCd,areaCd,branchCd,managerCd,
	 * 		    bancTypeDesc,areaDesc,branchDesc,payeeName
	 * @throws  SQLException
	 */
	GIPIPolbasic getBancassuranceDtl(Integer policyId) throws SQLException;
	
	/**
	 *Returns plan details 
	 *@param   policyId
	 *@returns planCd,planChTag,planDesc
	 *@throws  SQLException
	 */
	GIPIPolbasic getPlanDtl(Integer policyId) throws SQLException;
	
	/**
	 * Returns a policy(with endtSeqNo = 0) information  
	 * 		   to the given policy(with policyId as a parameter)
	 * @param  policyId
	 * @returns policy informations
	 * @throws SQLException
	 */
	HashMap<String, Object> getPolicyEndtSeq0(Integer policyId) throws SQLException;
	
	/**
	 * Gets the list of policies by assured
	 * @param   assdNo
	 * @returns list of policies (same assured)
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyListByAssured(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * @author rey
	 * @date 07-19-2011
	 * Gets the list of policies by endorsement type
	 * @param params
	 * @return list of policies (same endorsement type)
	 * @throws SQLException
	 */
	HashMap<String, Object> getPolicyListByEndorsementType(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of policies by obligee
	 * @param   obligeeNo
	 * @returns list of policies (same obligee)
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyListByObligee(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of renewlas of a policy
	 * @param   policyId
	 * @returns list of policies (renewals)
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyRenewals(HashMap<String, Object> params) throws SQLException;
	
	List<GIPIPolbasic> getEndtCancellationLOV(GIPIPolbasic polbasic, String type) throws SQLException;
	PaginatedList getPolicyListingForCertPrinting(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyFI(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMC(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMN(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMH(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyEN(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyAV(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyCA(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyAC(int parId) throws SQLException;
	Map<String, Object> getValidRefPolNo(Map<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 07-29-2011
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getBillTaxList(Integer policyId) throws SQLException; 
	/**
	 * @author rey
	 * @date 08.04.2011
	 * @param params
	 * @return bill peril list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getBillPerilList(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.11.2011
	 * @param params
	 * @return policy by assured in account of
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPolicyByAssuredInAcctOf (HashMap<String, Object> params)throws SQLException;
	/**
	 * @author rey
	 * @date 08.05.2011
	 * payment schedule
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPaymentSchedule(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.16.2011
	 * @param params
	 * @return co signors list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getCoSignors(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 07.16.2011
	 * @param params
	 * @return bond policy data
	 * @throws SQLException
	 */
	GIPIPolbasic getBondPolicyData(Integer policyId) throws SQLException;
	/**
	 * @author rey
	 * @date 08.08.2011
	 * commission details
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getCommissionDetails(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.08.2011
	 * invoice commission
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getInvoiceCommission(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return policy discount/surcharge list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPolicyDiscountSurcharge(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return item discount/surcharge list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getItemDiscountSurcharge(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return peril discount/surcharge list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPerilDiscountSurcharge(HashMap<String, Object> params) throws SQLException;
	/**
	 * Gets the policy no of specified policy id
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	String getPolicyNo(Integer policyId) throws SQLException;
	
	/**
	 * get GIPI_POLBASIC records for redistribution
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	HashMap<String, Object> getPolicyListingForRedistribution(HashMap<String, Object> params) throws SQLException, JSONException, ParseException;
	
	/**
	 * execute POST-QUERY of block V370 in Redistribution (GIUWS012)
	 * @param params
	 * @throws SQLException
	 */
	void executeGIUWS012V370PostQuery(Map<String, Object> params) throws SQLException;
	
	/**
	 * Check if policy has FACUL share and if there are existing payments
  	 * from FACUL Reinsurers to consider the value of "ALLOW_NEG_DIST" 
  	 * parameter in displaying the message that there are collections from facul insurers (GIUTS021)
	 * @param policyId
	 * @param lineCd
	 * @return
	 * @throws SQLException
	 */
	String checkReinsurancePaymentForRedistribution(Integer policyId, String lineCd) throws SQLException;
	
	Map<String, Object> getPackDetailsHeader(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyGICLS026(Map<String, Object> params) throws SQLException;
	String getRefPolNo(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> checkPolicyGiexs006(Map<String, Object> params) throws SQLException;
	String getEndtTax2GIPIS091(Integer policyId) throws SQLException;
	Map<String, Object> getPolicyInformation(Integer policyId) throws SQLException;
	Integer getPolBondSeqNo(HttpServletRequest request) throws SQLException, NullPointerException;
	String getPolicyId(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkEndtGiuts008a(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyGuits008a(Map<String, Object> params) throws SQLException;
	String getRefPolNo2(Map<String, Object> params) throws SQLException;
	
	//gipis131 - pol cruz 04.11.2013
	JSONObject showGIPIS131(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showGipis131ParStatusHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//gipis132 - pol cruz 04.16.2013
	JSONObject showGIPIS132(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Integer getMainPolicyId(HttpServletRequest request) throws SQLException;
	
	Map<String, Object> gipis100ExtractSummary(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	JSONObject showViewDistributionStatus(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewDistribution(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewRIPlacement(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getDistDtl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getDistDtl2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewSummarizedDist(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String callExtractDistGipis130(HttpServletRequest request) throws SQLException, ParseException;
	String onLoadSummarizedDist(HttpServletRequest request) throws SQLException;
	JSONObject viewSummDistRiPlacement(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewBinder(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewDistItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewDistPerItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewDistPeril(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException, ParseException;
	JSONObject viewDistPerPeril(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String insertSummDist(HttpServletRequest request) throws SQLException;
	//giuts028 - jomsdiago 07.25.2013
	JSONObject showReinstateHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showViewVesselAccumulation(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	JSONObject showVesselAccumulationDtl(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	JSONObject showShareExposures(HttpServletRequest request)throws SQLException, JSONException, ParseException;
	JSONObject showTemporaryExposures(HttpServletRequest request)throws SQLException, JSONException, ParseException;
	JSONObject showActualExposures(HttpServletRequest request)throws SQLException, JSONException, ParseException;
	
	JSONObject getGIPIS156BasicInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	
	// GIPIS203
	String extractRecapsVI(HttpServletRequest request, String userId) throws SQLException;
	String checkExtractedRecordsBeforePrint(HttpServletRequest request) throws SQLException, Exception;
	Map<String, Object> checkRecapsVIBeforeExtract(HttpServletRequest request, GIISUser USER) throws SQLException; /* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
	
	//gipis100a - john dolon 9.4.2013
	JSONObject showPackagePolicyInformation(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showPackagePolicyItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showViewIntermediaryCommission(HttpServletRequest request, String userId)throws SQLException, JSONException, ParseException;
	JSONObject showIntermediaryCommissionlOverlay(HttpServletRequest request)throws SQLException, JSONException, ParseException;
	JSONObject getMotorCarInquiryRecords(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	//GIPIS175
	JSONObject saveGIPIS175(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	
	//GIPIS209
	JSONObject showViewExposuresPerPAEnrollees(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//GIPIS111
	JSONObject showViewCasualtyAccumulation(HttpServletRequest request)throws SQLException, JSONException;
	JSONObject showCasualtyAccumulationDtl(HttpServletRequest request)throws SQLException, JSONException;
	JSONObject showGipis111ActualExposures(HttpServletRequest request)throws SQLException, JSONException;
	JSONObject showGipis111TemporaryExposures(HttpServletRequest request)throws SQLException, JSONException;
	
	//GIPIS152
	JSONObject getUserInformationList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getTranList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getTranIssList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getTranLineList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getModuleList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGrpTranList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGrpTranIssList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGrpTranLineList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGrpModuleList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getHistoryList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	//GIPIS110
	JSONObject showViewBlockAccumulation(HttpServletRequest request)throws SQLException, JSONException;
	JSONObject showBlockAccumulationDtl(HttpServletRequest request, String userId)throws SQLException, JSONException;
	String gipis110CheckFiAccess(String userId)throws SQLException;
	JSONObject showBlockShareExposures(HttpServletRequest request)throws SQLException, JSONException;
	JSONObject showGipis110ActualExposures(HttpServletRequest request, String userId)throws SQLException, JSONException;
	JSONObject showGipis110TemporaryExposures(HttpServletRequest request, String userId)throws SQLException, JSONException;
	JSONObject showBlockRisk(HttpServletRequest request, String userId)throws SQLException, JSONException; //nieko 07072016 KB 894
	
	String gipis191ExtractRiskCategory(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> getGIPIS191Params(String userId) throws SQLException;

	//GIPIS200		
	JSONObject checkViewProdDtls(HttpServletRequest request, String userId) throws SQLException;
	JSONObject extractProduction(HttpServletRequest request, String userId) throws SQLException;
	
	//GIPIS202
	JSONObject getProductionDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> validateGIPIS201Access (HttpServletRequest request, GIISUser USER) throws SQLException;
	
	//GIPIS201	
	JSONObject getProdPolicyDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> validateGIPIS201DisplayORC (HttpServletRequest request) throws SQLException;
	JSONObject getGIPIS201CommDtls	(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getDiscountSurcharge(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getDiscSurcDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showEndtTypeList(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getEndtPolicyDates(HttpServletRequest request) throws SQLException, JSONException; // kris 04.15.2014
	
	String getIssCdRI() throws SQLException; // hrdtagudin 07232015 SR 19751
	JSONObject getInitialAcceptance(Map<String, Object> params) throws SQLException, JSONException; // hrdtagudin 07302015 SR 19751

	Integer getParId(String policyId) throws SQLException;
}
