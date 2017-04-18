package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACCommPayts;

public interface GIACCommPaytsService {

	/**
	 * Gets the list of GIAC_COMM_PAYTS records 
	 * @param gaccTranId The transaction id
	 * @return List of GIAC Comm Payts records
	 * @throws SQLException
	 */
	List<GIACCommPayts> getGIACCommPayts(int gaccTranId) throws SQLException;
	
	/**
	 * Gets the basic values for module variables on GIACS020, usually 
	 * @param gaccTranId The tran Id
	 * @param userId The user id
	 * @return The map containing the values of the variables
	 * @throws SQLException
	 */
	Map<String, Object> getGiacs020BasicVarValues(Integer gaccTranId, String userId) throws SQLException;
	
	/**
	 * Gets a paginated list of bill number for specified tran type, issue source code, and keyword
	 * @param pageNo The page no of the paginated list
	 * @param tranType The tran type
	 * @param issCd The iss cd
	 * @param gaccTranId The tran Id
	 * @param keyword The keyword for search
	 * @return The paginated list of bill number
	 * @throws SQLException
	 */
	PaginatedList getBillNoList(Integer pageNo, Integer tranType, String issCd, Integer gaccTranId, String keyword) throws SQLException;
	
	/**
	 * Executes procedure GET_GIPI_COMM_INVOICE of the module Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGIPICommInvoice(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes procedure CHK_MODIFIED_COMM called in the validation of Prem Seq No of the module Giacs020
	 * @param premSeqNo The prem seq no
	 * @param issCd The issue source code
	 * @return The result message
	 * @throws SQLException
	 */
	String chkModifiedComm(String premSeqNo, String issCd) throws SQLException;
	
	/**
	 * Validates the intm no on GIACS020 - Comm Payts
	 * @param params The parameters to be used in the validation
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validateGIACS020IntmNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes procedure PARAM2_MGMT_COMP called in the validation of Intm No of the module Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> commPaytsParam2MgmtComp(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the Intm No POST-TEXT-ITEM trigger as part of validation of Intm No of the module Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> commPaytsIntmNoPostText(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes procedure GET_DEF_PREM_PCT of the module Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getCommPaytsDefPremPct(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure COMM_PAYTS of the module Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> commPaytsCompSummary(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the PRE-INSERT trigger of GCOP block in Giacs020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> preInsertGiacs020CommPayts(Map<String, Object> params) throws SQLException;
	
	/**
	 * Saves GIAC Comm Payts records and executes post-forms-commit functions and procedures
	 * @param giacCommPayts
	 * @param delGiacCommPayts
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> saveGIACCommPayts(List<GIACCommPayts> giacCommPayts, List<GIACCommPayts> delGiacCommPayts, Map<String, Object> params) throws SQLException;
	
	/**
	 * Inserts/Updates GIAC Comm Payts records
	 * @param giacCommPayts List of giac_comm_payts records to be saved
	 * @throws SQLException
	 */
	void setGIACCommPayts(List<GIACCommPayts> giacCommPayts) throws SQLException;
	
	/**
	 * Deletes GIAC Comm Payts records
	 * @param giacCommPayts List of giac_comm_payts records to be saved
	 * @throws SQLException
	 */
	void deleteGIACCommPayts(List<GIACCommPayts> giacCommPayts) throws SQLException;
	
	/**
	 * Executes the POST-FORMS-COMMIT trigger of GIACS020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> executeGiacs020PostFormsCommit(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the GCOP_INV records on GIACS020
	 * @param pageNo
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getGcopInv(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the WHEN-CHECKBOX-CHANGED trigger of :GCOP_INV.chk_tag item on GIACS020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> checkGcopInvChkTag(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the KEY-DELREC trigger of GCOP block in GIACS020
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String executeGIACS020DeleteRecord(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getGcopInvList(Map<String, Object>params) throws SQLException;

	String checkRelCommWUnprintedOr(HttpServletRequest request) throws SQLException;
	
	List<Map<String, Object>> getGcopInvDetails(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getParam2FullPremPayt(Map<String, Object> params) throws SQLException;
	
	String validateGIACS020BillNo(HttpServletRequest request) throws SQLException;	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015

	String checkingIfPaidOrUnpaid(HttpServletRequest request, String userId) throws SQLException, JSONException;//SR20909 :: john 11.9.2015 //Modified by Jerome Bautista 03.04.2016 SR 21279
	void checkCommPaytStatus(HttpServletRequest request) throws SQLException;
}
