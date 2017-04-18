package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACPremDeposit;

public interface GIACPremDepositDAO {

	/**
	 * Gets GIAC Prem Deposit details of specified transaction Id
	 * @param tranId The transaction Id
	 * @return The GIAC Prem Deposit entity
	 * @throws SQLException
	 */
	List<GIACPremDeposit> getGIACPremDeposit(int tranId) throws SQLException;
	
	/**
	 * Gets all GIAC Prem Deposit records
	 * @param tranId The old transaction Id
	 * @param oldItemNo The old item no
	 * @return The GIAC Prem Deposit entity
	 * @throws SQLException
	 */
	List<GIACPremDeposit> getGIACPremDeposit2() throws SQLException;
	
	/**
	 * Gets GIAC Acctrans details of specified transaction id, fund cd, and branch cd. Move to appropriate DAO if necessary
	 * @param tranId The tran Id
	 * @param gfunFundCd The fund cd
	 * @param gibrBranchCd The branch cd
	 * @return
	 * @throws SQLException
	 */
	GIACAccTrans getGIACAcctrans(int tranId, String gfunFundCd, String gibrBranchCd) throws SQLException;
	
	/**
	 * Gets the sum total collection of all giac prem deposits of specified transaction Id
	 * @param tranId The tran Id
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getTotalCollections(int tranId) throws SQLException;
	
	/**
	 * Gets default currency details
	 * @param currencycd
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getDefaultCurrency(Integer currencyCd) throws SQLException;
	
	/**
	 * Gets the list of old item no details
	 * @param transactionType The transaction type
	 * @param controlModule The control module
	 * @param keyword The search keyword
	 * @param userId 
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getOldItemNoList(Integer transactionType, String controlModule, String keyword, String userId) throws SQLException;
	
	/**
	 * Gets the list of old item no details for transaction type 4
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getOldItemNoListFor4(String keyword) throws SQLException;
	
	/**
	 * Gets the records needed for GIACS026 module
	 * @param params The parameters
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGIACPremDepositModuleRecords(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of collection amt sums and their respective old_item_no and old_tran_id
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getCollectionAmtSumFor2List() throws SQLException;
	
	/**
	 * Gets the list of collection amt sums and their respective old_item_no and old_tran_id
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getCollectionAmtSumFor4List() throws SQLException;
	
	/**
	 * Gets GIAC Aging SOA and GIPI Polbasic fields
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGIACAgingSOAPolicy(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure VALIDATE_RI_CD of GIACS026
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validateRiCd(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure VALIDATE_TRAN_TYPE1 of GIACS026
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validateTranType1(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure VALIDATE_TRAN_TYPE2 of GIACS026
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	void validateTranType2(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure GET_PAR_SEQ_NO2 of GIACS026
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getParSeqNo2(Map<String, Object> params) throws SQLException;
	
	/**
	 * Saves GIAC Prem Deposit Records and executes post-forms-commit functions and procedures
	 * @param giacPremDeps The list of GIAC Prem Deposit records to be saved
	 * @param delGiacPremDeps The list of GIAC Prem Deposit primary keys of records to be deleted
	 * @param gaccBranchCd The branch cd
	 * @param gaccFundCd The fund cd
	 * @param gaccTranid The tran id
	 * @param moduleName The module name
	 * @param genType The item generation type
	 * @param tranSource The tran source
	 * @param orFlag The OR Flag
	 * @param USER The user
	 * @return The result message
	 * @throws SQLException
	 */
	String saveGIACPremDeposit(List<GIACPremDeposit> giacPremDeps, List<Map<String, Object>> delGiacPremDeps,
							  String gaccBranchCd, String gaccFundCd, int gaccTranId, String moduleName,
							  String genType, String tranSource, String orFlag, GIISUser USER) throws SQLException;
	
	/**
	 * Inserts/Updates GIAC Prem Deposit records
	 * @param giacPremDep List of giac_prem_deposit records to be saved
	 * @throws SQLException
	 */
	void setGIACPremDeposit(List<GIACPremDeposit> giacPremDeps) throws SQLException;
	
	/**
	 * Deletes GIAC Prem Deposit records
	 * @param giacPremDeps List of giac_prem_deposit primary keys of records to be deleted
	 * @throws SQLException
	 */
	void deleteGIACPremDeposit(List<Map<String, Object>> giacPremDeps) throws SQLException;
	
	/**
	 * Executes procedure COLLECTION_DEFAULT_AMOUNT or COLLECTION_DEFAULT_AMT_FOR_4 on GIACS026, depending on the transaction type
	 * @param params
	 * @throws SQLException
	 */
	void executeCollectionDefaultAmount(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure GET_PAR_SEQ_NO of GIACS026
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	void getParSeqNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Check if the entered old tran id, old item no, and old tran type exists. This is to avoid foreign key constraint errors
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String checkGipdGipdFKConstraint(Map<String, Object> params) throws SQLException;
	
	/**
	 * Saves changes in the premium deposit collection table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String saveGIACPremDep(Map<String, Object> allParams) throws SQLException;
	
	
	/*added by kenneth for print premium deposit 06.25.2013*/
	String extractPremDeposit (String userId) throws SQLException;
	String extractWidNoReversal (Map<String, Object> params) throws SQLException;
	String extractWidReversal (Map<String, Object> params) throws SQLException;
	Map<String, Object> getLastExtract(String userId) throws SQLException;
	/*end kenneth for print premium deposit 06.25.2013*/
	
}
