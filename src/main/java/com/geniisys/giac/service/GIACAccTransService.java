package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACAccTrans;

public interface GIACAccTransService {
	
	GIACAccTrans getValidationDetail(Integer tranId) throws SQLException;
	String getTranFlag(Integer tranId) throws SQLException;
	
	/**
	  * Gets the map that will be used for the display of table grid for the DCB Listing
	  * @param params
	  * @return
	  * @throws SQLException
	  * @throws JSONException
	  */
	 Map<String, Object> getDCBListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	 
	/**
	 * Gets the GIAC_ACCTRANS detail for DCB Info
	 * @param gaccTranId
	 * @return
	 * @throws SQLException
	 */
	GIACAccTrans getGiacAcctransDtl(Integer gaccTranId) throws SQLException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GICD_SUM block records in GIACS035
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> getGicdSumListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDS/GBDS (Bank/Cash Deposit) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
//	Map<String, Object> getGbdsListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the 
	 *  GCDD (Cash Deposit Analysis - GIAC_CASH_DEP_DTL) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
//	Map<String, Object> getGcddListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDSD (Deposit Slip Breakdown) block records in GIACS035
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
//	Map<String, Object> getGbdsdListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the ERROR (Cash Deposit Analysis) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
//	Map<String, Object> getGbdsdErrorListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the OTC (Out of Town Check Detail) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> getOtcListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the LOCM (List of Credit Memo) block records in GIACS035
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> getLocmListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Executes the first part of WHEN-VALIDATE-ITEM of DCB_NO in GIACS035 (Close DCB)
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs035DCBNo1(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the second part of WHEN-VALIDATE-ITEM of DCB_NO in GIACS035 (Close DCB)
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs035DCBNo2(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the mean tran flag of specified tran_flag
	 * @param tranFlag
	 * @return
	 * @throws SQLException
	 */
	String getTranFlagMean(String tranFlag) throws SQLException;
	
	/**
	 * Check records in collection breakdown if existing
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String checkBankInOR(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the records for PAY_MODE LOV in Close DCB (GIACS035)
	 * @param pageNo
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getDCBPayModeList(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the PRE-TEXT-ITEM trigger of GDBD.AMOUNT in GIACS035 (Close DCB) and gets the new amount
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal executeGdbdAmtPreTextItem(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets total amt for gicd sum rec to be used in WHEN-VALIDATE-ITEM trigger of AMOUNT in GDBD block of GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getGdbdAmtWhenValidate(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the WHEN_VALIDATE_ITEM trigger of GDBD.dsp_curr_sname and gets the computed gicd_sum_rec
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getCurrSnameGicdSumRec(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the WHEN_VALIDATE_ITEM trigger of GDBD.foreign_curr_amt
	 * and gets the computed gicd_sum_rec for local and foreign currency amt
	 * @param params
	 * @throws SQLException
	 */
	void getTotFcAmtForGicdSumRec(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the collection and deposit to be used in CASH_DEPOSITS return button when-button-pressed trigger
	 * @param params
	 * @throws SQLException
	 */
	void getGcddCollectionAndDeposit(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of CHECK_CLASS used in Close DCB(GIACS035) GBDS block
	 * @return
	 * @throws SQLException
	 */
	List<CGRefCodes> getCheckClassList() throws SQLException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDSD (Deposit Slip Breakdown) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	//Map<String, Object> getGbdsdListTableGridMapByGaccTranId(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Update GIAC_BANK_DEP_SLIP_DTL in OTC return button
	 * to delete the local_sur,foreign_sur and net_colln_amt of non-OTC checks
	 * @param depId
	 * @throws SQLException
	 */
	void updateGbdsdInOtc(Integer depId) throws SQLException;
	
	/**
	 * Gets the records for GBDSD LOV in Close DCB (GIACS035)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGbdsdLOV(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes when return btn on Bank Dep is pressed.
	 * to make sure that details were entered after creating record on gbds block
	 * @param params
	 * @throws SQLException
	 */
	void executeGiacs035BankDepReturnBtn(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> checkDCBForClosing(Map<String, Object> params) throws SQLException;
	
	String closeDCB(String param, String userId) throws SQLException, JSONException, ParseException;
	void updateAccTransFlag(Map<String, Object> params) throws SQLException;
	void updateDCBCancel(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getRecAcctEntTranDtl (Integer acctTranId) throws SQLException;
	String checkDCBFlag (String param) throws SQLException, JSONException;  //Deo [03.03.2017]: SR-5939
}
