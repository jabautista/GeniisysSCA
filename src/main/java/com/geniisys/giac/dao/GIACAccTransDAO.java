/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.giac.entity.GIACAccTrans;

public interface GIACAccTransDAO {

	GIACAccTrans getValidationDetail(Integer tranId) throws SQLException;
	String getTranFlag(Integer tranId) throws SQLException;
	
	/**
	 * Gets DCB Listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getDCBListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the GIAC_ACCTRANS detail for DCB Info
	 * @param gaccTranId
	 * @return
	 * @throws SQLException
	 */
	GIACAccTrans getGiacAcctransDtl(Integer gaccTranId) throws SQLException;
	
	/**
	 * Gets GICD_SUM block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGicdSumListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GBDS/GBDS2 (Bank/Cash Deposit) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	//List<Map<String, Object>> getGbdsListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GCDD (Cash Deposit Analysis - GIAC_CASH_DEP_DTL) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	//List<Map<String, Object>> getGcddListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GBDSD (Deposit Slip Breakdown) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	//List<Map<String, Object>> getGbdsdListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the loc error amt for ERROR block in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
//	BigDecimal getLocErrorAmt(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the local_surcharge, foreign_surcharge and net_colln_amt of the check that has OTC
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getOtcSurchargeForTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets LOCM (List of Credit Memo) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getLocmForTableGrid(Map<String, Object> params) throws SQLException;
	
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
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getDCBPayModeList(Map<String, Object> params) throws SQLException;
	
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
	 * Gets GBDSD (Deposit Slip Breakdown) block records listing in table grid using specified gacc tran id
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	//List<Map<String, Object>> getGbdsdListTableGridByGaccTranId(Map<String, Object> params) throws SQLException;
	
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
	
	String closeDCB(Map<String, Object> params) throws SQLException;
	void updateAccTransFlag(Map<String, Object> params) throws SQLException;
	void updateDCBCancel(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getRecAcctEntTranDtl (Integer acctTranId) throws SQLException;
	String checkDCBFlag (Map<String, Object> params) throws SQLException;  //Deo [03.03.2017]: SR-5939
}
