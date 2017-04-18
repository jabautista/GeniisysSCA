package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACBankDepSlipsDAO {

	/**
	 * Saves the GBDS/GBDS blocks in GIACS035 (Close DCB)
	 * @param allParams
	 * @return
	 * @throws SQLException
	 */
	String saveGbdsBlock(Map<String, Object> allParams) throws SQLException; 
	
	List<Map<String, Object>> getGbdsListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GCDD (Cash Deposit Analysis - GIAC_CASH_DEP_DTL) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGcddListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GBDSD (Deposit Slip Breakdown) block records listing in table grid using specified gacc tran id
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGbdsdListTableGridByGaccTranId(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GBDSD (Deposit Slip Breakdown) block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGbdsdListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the loc error amt for ERROR block in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getLocErrorAmt(Map<String, Object> params) throws SQLException;
}
