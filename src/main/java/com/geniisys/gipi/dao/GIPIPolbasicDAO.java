/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIPolbasicDAO.
 */
public interface GIPIPolbasicDAO extends GenericDAO<GIPIPolbasic> {

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
	List<GIPIPolbasic> getEndtPolicyCA(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyAC(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyFI(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMC(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMN(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyMH(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyAV(int parId) throws SQLException;
	List<GIPIPolbasic> getEndtPolicyEN(int parId) throws SQLException;
	List<GIPIPolbasic> getPolicyForEndt(Map<String, String> params) throws SQLException;
	String isPolExist(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getPolicyListing(Map<String, Object> params) throws SQLException; 
	String getBillNotPrinted(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the records for LOV CGFK$GIPD_LINE_CD
	 * @param keyword The search query keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getGipdLineCdLov(String keyword) throws SQLException;
	
	/**
	 * Gets the policy information records with endtSeqNo = 0
	 * @param   lineCd,sublineCd,issCd,issueYy,polSeqNo,renewNo,
	 * 		    refPolNo,nbtLineCd,nbtIssCd,nbtParYy,nbtParSeqNo,
	 * 		    nbtQuoteSeqNo 
	 * @returns paginated list of policies(with endtSeqNo = 0) 
	 * @throws  SQLException 
	 */
	List<HashMap<String, Object>> getPolicyInformation(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the policy information records related to a 
	 * 		    policy with endtSeqNo = 0
	 * @param   lineCd,sublineCd,issCd,issueYy,polSeqNo,renewNo,
	 * 		    refPolNo,nbtLineCd,nbtIssCd,nbtParYy,nbtParSeqNo,
	 * 		    nbtQuoteSeqNo
	 * @returns list of policies
	 * @throws  SQLException 
	 */
	List<GIPIPolbasic> getRelatedPolicies(Map<String, Object> params) throws SQLException;
	
	/**
	 * Retrieves the Main information of a policy
	 * @param   policyId
	 * @returns policyId,labelTag,lineCd,assdName,acctOf,polNo,endtNo
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyMainInformation(Integer policyId) throws SQLException;
	
	/**
	 * Retrieves the all the basic informations of a policy
	 * @param   policyId
	 * @returns basic informations of a policy
	 * @throws  SQLException
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
	 * 		    to the given policy(with policyId as a parameter)
	 * @param   policyId
	 * @returns policy informations
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyEndtSeq0(Integer policyId) throws SQLException;
	
	/**
	 * Gets the list of policies by assured
	 * @param   assdNo
	 * @returns list of policies (same assured)
	 * @throws  SQLException
	 */
	List<GIPIPolbasic> getPolicyListByAssured(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * Gets the list of policies by obligee
	 * @param   obligeeNo
	 * @returns list of policies (same obligee)
	 * @throws  SQLException
	 */
	List<GIPIPolbasic> getPolicyListByObligee(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * Gets the list of renewlas of a policy
	 * @param   policyId
	 * @returns list of policies (renewals)
	 * @throws  SQLException
	 */
	List<GIPIPolbasic> getPolicyRenewals(HashMap<String,Object> params) throws SQLException;
	
	List<GIPIPolbasic> getEndtCancellationLOV(GIPIPolbasic polbasic) throws SQLException;
	List<GIPIPolbasic> getEndtCancellationLOV2(GIPIPolbasic polbasic) throws SQLException;
	
	List<GIPIPolbasic> getPolicyListingForCertPrinting(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getPolicyListByEndorsementType(	HashMap<String, Object> params) throws SQLException;
	Map<String, Object> getValidRefPolNo(Map<String, Object> params) throws SQLException;

	/**
	 * @author rey
	 * @date 07-29-2011
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getBillTaxListDAO(Integer policyId) throws SQLException;
	
	/**
	 * @author rey
	 * @date 08.04.2011
	 * @param params
	 * @return bill peril list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getBillPerilListDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.11.2011
	 * @param params
	 * @return policy by assured in account of
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPolicyByAssuredInAcctOfDAO(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * @author rey
	 * @date 08.05.2011
	 * payment schedule
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPaymentScheduleDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.05.2011
	 * @param params
	 * @return invoice commission list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getInvoiceCommissionDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.08.2011
	 * commission details
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getCommissionDetailsDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return policy discount/surcharge list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPolicyDiscountDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return item discount surcharge
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getItemDiscountDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.09.2011
	 * @param params
	 * @return peril discount surcharge
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPerilDiscountDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * Gets the policy no of specified policy id
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	String getPolicyNo(Integer policyId) throws SQLException;
	
	/**
	 * get GIPI_POLBASIC record list for redistribution
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getPolicyListingForRedistribution(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.16.2011
	 * @param params
	 * @return co signors list
	 * @throws SQLException
	 */
	List<GIPIPolbasic> getCoSignorsDAO(HashMap<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.16.2011
	 * @param params
	 * @return bond policy data
	 * @throws SQLException
	 */
	GIPIPolbasic getBondPolicyDataDAO(Integer policyId) throws SQLException;
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
	Integer getPolBondSeqNo(Map<String, Object> params) throws SQLException;
	String getPolicyId(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkEndtGiuts008a(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyGuits008a(Map<String, Object> params) throws SQLException;
	String getRefPolNo2(Map<String, Object> params) throws SQLException;
	//GIPIS132
	Integer getMainPolicyId(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis100ExtractSummary(Map<String, Object> params) throws SQLException, Exception;
	String callExtractDistGipis130(Map<String, Object> params) throws SQLException;
	String onLoadSummarizedDist(Map<String, Object> params) throws SQLException;
	String insertSummDist(Map<String, Object> params) throws SQLException;
	void extractVesselAccum(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIPIS156BasicInfo (Map<String, Object> params) throws SQLException;
	
	//GIPIS203
	String extractRecapsVI(Map<String, Object> params) throws SQLException;
	String checkExtractedRecordsBeforePrint(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRecapsVIBeforeExtract(Map<String, Object> params) throws SQLException;  /* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
	
	//GIPIS175
	Map<String, Object> saveGIPIS175 (Map<String, Object> params) throws SQLException;
	
	void extractCasualtyAccum(Map<String, Object> params)throws SQLException;
	void extractBlockAccum(Map<String, Object> params)throws SQLException;
	String gipis110CheckFiAccess(String userId)throws SQLException;
	
	String gipis191ExtractRiskCategory(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIPIS191Params(String userId) throws SQLException;

	//GIPIS200
	Map<String, Object> checkViewProdDtls(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractProduction(Map<String, Object> params) throws SQLException;
	
	//GIPIS202
	Map<String, Object> validateGIPIS201Access (Map<String, Object> params) throws SQLException;
	
	//GIPIS201
	Map<String, Object> validateGIPIS201DisplayORC() throws SQLException;
	Map<String, Object> getEndtPolicyDates(Integer parId) throws SQLException; // kris 04.15.2014
	
	String getIssCdRI() throws SQLException;	//hdrtagudin 07232015 SR19751
	Map<String, Object> getInitialAcceptance(Integer policyId) throws SQLException; //hdrtagudin 07302015 SR19751

	Integer getParId(String policyId) throws SQLException;
}
