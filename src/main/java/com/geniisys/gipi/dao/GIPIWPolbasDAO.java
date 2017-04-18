/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.entity.GIPIRefNoHist;
import com.geniisys.gipi.entity.GIPIWPicture;
import com.geniisys.gipi.entity.GIPIWPolbas;

/**
 * The Interface GIPIWPolbasDAO.
 */
public interface GIPIWPolbasDAO {

	/**
	 * Gets the gipi w polbas.
	 * 
	 * @param parId the par id
	 * @return the gipi w polbas
	 * @throws SQLException the sQL exception
	 */
	GIPIWPolbas getGipiWPolbas(int parId) throws SQLException;
	
	/**
	 * Gets the gipi w polbas default.
	 * 
	 * @param parId the par id
	 * @return the gipi w polbas default
	 * @throws SQLException the sQL exception
	 */
	GIPIWPolbas getGipiWPolbasDefault(int parId) throws SQLException;
	
	/**
	 * Save gipi w polbas.
	 * 
	 * @param gipiWPolbas the gipi w polbas
	 * @throws SQLException the sQL exception
	 */
	void saveGipiWPolbas(GIPIWPolbas gipiWPolbas) throws SQLException;
	
	/**
	 * Validate subline.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @param paramSublineCd the param subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateSubline(Integer parId, String lineCd, String sublineCd, String paramSublineCd) throws SQLException;
	
	/**
	 * Validate assd name.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @throws SQLException the sQL exception
	 */
	void validateAssdName(Integer parId, String lineCd, String issCd) throws SQLException;
	
	/**
	 * Validate booking date.
	 * 
	 * @param bookingYear the booking year
	 * @param bookingMth the booking mth
	 * @param issueDate the issue date
	 * @param inceptDate the incept date
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateBookingDate(Integer bookingYear,String bookingMth, String issueDate, String inceptDate) throws SQLException;
	
	/**
	 * Validate takeup term.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> validateTakeupTerm(Integer parId, String lineCd, String issCd) throws SQLException;
	
	/**
	 * Validate co insurance.
	 * 
	 * @param parId the par id
	 * @param coInsurance the co insurance
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateCoInsurance(Integer parId, Integer coInsurance) throws SQLException;
	
	/**
	 * Validate co insurance2.
	 * 
	 * @param parId the par id
	 * @param coInsurance the co insurance
	 * @throws SQLException the sQL exception
	 */
	void validateCoInsurance2(Integer parId, Integer coInsurance) throws SQLException;
	
	/**
	 * Delete bill.
	 * 
	 * @param parId the par id
	 * @param coInsurance the co insurance
	 * @throws SQLException the sQL exception
	 */
	void deleteBill(Integer parId, Integer coInsurance) throws SQLException;
	
	/**
	 * Insert par hist.
	 * 
	 * @param parId the par id
	 * @param userId the user id
	 * @throws SQLException the sQL exception
	 */
	void insertParHist(Integer parId, String userId) throws SQLException;
	
	/**
	 * Post forms commit d.
	 * 
	 * @param parId the par id
	 * @param assdNo the assd no
	 * @throws SQLException the sQL exception
	 */
	void postFormsCommitD(Integer parId, Integer assdNo) throws SQLException;
	
	/**
	 * Update par status.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void updateParStatus(Integer parId) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	/**
	 * Gets the gipi wpolbas common.
	 * 
	 * @param parId the par id
	 * @return the gipi wpolbas common
	 * @throws SQLException the sQL exception
	 */
	GIPIWPolbas getGipiWpolbasCommon(int parId) throws SQLException;
	
	/**
	 * Creates the winvoice.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @throws SQLException the sQL exception
	 */
	void createWinvoice(Integer parId, String lineCd, String issCd) throws SQLException;
	
	/**
	 * Validate ref pol no.
	 * 
	 * @param parId the par id
	 * @param refPolNo the ref pol no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateRefPolNo(Integer parId, String refPolNo) throws SQLException;
	
	/**
	 * New form inst.
	 * 
	 * @param issCd the iss cd
	 * @param lineCd 
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> newFormInst(String issCd, String lineCd) throws SQLException;
	
	/**
	 * Gets the issue yy.
	 * 
	 * @param param the param
	 * @param doi the doi
	 * @param issueDate the issue date
	 * @return the issue yy
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getIssueYy(String bookingMth,String bookingYear, String doi, String issueDate) throws SQLException;
	
	/**
	 * Validate expiry date.
	 * 
	 * @param parId the par id
	 * @param doe the doe
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> validateExpiryDate(Integer parId, String doe) throws SQLException;
	
	/**
	 * Post forms commit a.
	 * 
	 * @param parId the par id
	 * @param coInsurance the co insurance
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> postFormsCommitA(Integer parId, Integer coInsurance, String dateSw) throws SQLException;
	
	/**
	 * Updatepol dist.
	 * 
	 * @param effDate the eff date
	 * @param parId the par id
	 * @param longTermDist the long term dist
	 * @throws SQLException the sQL exception
	 */
	void updatepolDist(String effDate, Integer parId, String longTermDist) throws SQLException;
	
	/**
	 * Commit.
	 * 
	 * @throws SQLException the sQL exception
	 */
	void commit() throws SQLException;
	
	/**
	 * Pre forms commit a.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> preFormsCommitA(Integer parId) throws SQLException;
	
	/**
	 * Pre forms commit b.
	 * 
	 * @param opLineCd the op line cd
	 * @param opSublineCd the op subline cd
	 * @param opIssCd the op iss cd
	 * @param opIssueYy the op issue yy
	 * @param opPolSeqNo the op pol seq no
	 * @param opRenewNo the op renew no
	 * @param effDate the eff date
	 * @param doe the doe
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> preFormsCommitB(String opLineCd, String opSublineCd, String opIssCd, String opIssueYy, String opPolSeqNo,String opRenewNo, String effDate, String doe) throws SQLException;
	
	/**
	 * Pre forms commit c.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void preFormsCommitC(Integer parId) throws SQLException;
	
	/**
	 * Pre forms commit g.
	 * 
	 * @param bookingYear the booking year
	 * @param bookingMth the booking mth
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void preFormsCommitG(Integer bookingYear, String bookingMth, Integer parId) throws SQLException;
	
	/**
	 * Pre update b540 a.
	 * 
	 * @param sublineCd the subline cd
	 * @param refPolNo the ref pol no
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> preUpdateB540A(String sublineCd, String refPolNo) throws SQLException;
	Map<String, Object> saveGipiWPolbasForBond(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateEndtInceptExpiryDate(Map<String, Object> params) throws SQLException;	
	Map<String, Object> validateEndtEffDate(Map<String, Object> params) throws SQLException;
	int checkForPendingClaims(Map<String, Object> params) throws SQLException;	
	BigDecimal checkPolicyPayment(Map<String, Object> params) throws SQLException;	
	Map<String, Object> checkEndtForItemAndPeril(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkForPolFlagInterruption(Map<String, Object> params) throws SQLException;
	Map<String, Object> executeCheckPolFlagProcedures(Map<String, Object> params) throws SQLException;
	Map<String, Object> executeUncheckPolFlagProcedures(Map<String, Object> params) throws SQLException;
	
	/**
	 * Calls the function UPDATE_GIPI_WPOLBAS2 for Endt Par Item and returns the result message.
	 * @param parId The Par Id
	 * @param lineCd The line code
	 * @param negateItem The negate item tag
	 * @param prorateFlag The prorate flag
	 * @param compSw The comp_sw tag
	 * @param endtExpiryDate The endt expiry date
	 * @param effDate The effectivity date
	 * @param shortRtPercent The short rate percent
	 * @param expiryDate The expiry date
	 * @return The result message
	 */
	String updateGipiWpolbasEndt(int parId, String lineCd, String negateItem, String prorateFlag, String compSw, String endtExpiryDate, String effDate, BigDecimal shortRtPercent, String expiryDate) throws SQLException;
	
	Map<String, Object> checkForProrateFlagInterruption(Map<String, Object> params) throws SQLException;
	Map<String, Object> executeCheckProrateFlagProcedures(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateEndtExpDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateEndtIssueDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031NewFormInstance(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateBeforeSave(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveEndtBasicInfo(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031KeyCommit(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkEnteredPolicyNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyForSpoilage(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkClaims(Map<String, Object> params) throws SQLException;
	Map<String, Object> searchForPolicy(Map<String, Object> params) throws SQLException;
	String checkOldBondNoExist(Map<String, String> params) throws SQLException;
	String validateRenewalDuration(Map<String, Object> params) throws SQLException;
	String preGetAmounts(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> createNegatedRecordsCoi(Map<String, Object> params) throws SQLException;
	Map<String, Object> createNegatedRecordsEndt(Map<String, Object> params) throws SQLException;
	Map<String, Object> createNegatedRecordsFlat(Map<String, Object> params) throws SQLException;
	String checkPolicyForAffectingEndtToCancel(Map<String, Object> params) throws SQLException;
	String endtCheckRecordInItemPeril(Integer parId) throws SQLException;
	String endtCheckRecordInItem(Integer parId) throws SQLException;
	Map<String, Object> insertGipiWPolbasicDetailsForPAR(Map<String, Object> params) throws SQLException;	
	List<Map<String, Object>> getRecordsForEndtCancellation(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getRecordsForCoiCancellation(Map<String, Object> params) throws SQLException;
	Map<String, Object> processEndtCancellation(Map<String, Object> params) throws SQLException;
	Map<String, Object> getRecordsForService(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyNoForEndt(Map<String, Object> params) throws SQLException;
	void deleteRecordsForEndtTax(int parId) throws SQLException;
	String getEndtText(int parId) throws SQLException;
	Map<String, Object> savePARBasicInfo(Map<String, Object> params) throws SQLException;
	String getPolicyNoForEndt(Integer parId) throws SQLException;
	Map<String, Object> updateGipiWPolbasEndt(Map<String, Object> params) throws SQLException;
	String iisExistWItem(Integer parId) throws SQLException;
	Map<String, Object> getFixedFlag(Map<String, Object> params) throws SQLException;
	Map<String, Object> getFixedFlagGIPIS017B(Map<String, Object> params) throws SQLException;
	Map<String, Object> genBankDetails(Map<String, Object> params) throws SQLException;
	String validateAcctIssCd(String nbtAcctIssCd) throws SQLException;
	String validateBranchCd(HashMap<String, String> params) throws SQLException;
	List<GIPIRefNoHist> getBankRefNoList(HashMap<String, Object> params) throws SQLException;
	String validateBankRefNo(HashMap<String, String> params) throws SQLException;
	Map<String, Object> coInsurance(Integer parId) throws SQLException;
	Map<String, Object> getEndtRiskTag(Map<String, Object> params) throws SQLException;
	Map<String, Object> searchForEditedPolicy(Map<String, Object> params) throws SQLException;
	String checkPaidPolicy(Map<String, Object> params) throws SQLException;
	Integer checkAvailableEndt(Map<String, Object> params) throws SQLException;
	GIPIWPolbas getEndtBancassuranceDtl(Integer parId) throws SQLException;
	
	Integer getWpolbasParIdByPolFlag(String polFlag, Integer parId) throws SQLException;
	
	Map<String, Object> validateEffDateB5401(Map<String, Object> params) throws SQLException;
	
	//:D
	Map<String, Object> saveGipiWPolbasForEndtBond2(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getCoverNoteDetails(Map<String, Object> params) throws SQLException;
	
	void updateCoverNoteDetails(Map<String, Object> params) throws SQLException, Exception;
	GIPIWPolbas updateBookingDates(GIPIWPolbas polbas) throws SQLException;
	
	Map<String, Object> searchForPolicy1(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031NewFormInstance1(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateEffDate01(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateEffDate02(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateEffDate03(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateEffDate04(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateEndtExpiryDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateInceptDate01(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateInceptDate02(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateExpiryDate01(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031ValidateIssueDate01(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031GetBookingDate(Map<String, Object> params) throws SQLException;
	String gipis031CheckNewRenewals(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis031EndtCoiCancellationTagged(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	void saveEndtBasicInfo01(Map<String, Object> params) throws SQLException, JSONException, ParseException;	
	Map<String, Object> getBookingDateGIPIS002(Map<String, Object> params) throws SQLException;
	Map<String, Object> processEndtCancellationGipis165(Map<String, Object> params) throws SQLException;
	
	String checkParPostedBinder(Integer parId) throws SQLException;	// shan 10.14.2014
	String validatePolNo(Map<String, Object> params) throws SQLException;
	String getBondAutoPrem(Integer parId) throws SQLException; //added by robert GENQA SR 4828 08.26.15
	Map<String, Object> validateAssdNoRiCd (Map<String, Object> params) throws SQLException, JSONException; //jmm SR-22834
	Map<String, Object> validatePackAssdNoRiCd (Map<String, Object> params) throws SQLException, JSONException;
	List<GIPIQuotePictures> getAttachmentList(Map<String, Object> params) throws SQLException;
	void saveAttachments(List<GIPIWPicture> newAttachments) throws SQLException;
}
