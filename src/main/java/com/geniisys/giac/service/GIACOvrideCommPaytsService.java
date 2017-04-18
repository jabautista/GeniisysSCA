package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.giac.entity.GIACOvrideCommPayts;

public interface GIACOvrideCommPaytsService {

	/**
	 * Gets the GIAC_OVRIDE_COMM_PAYTS records of specified tran id
	 * @param gaccTranId
	 * @return
	 * @throws SQLException
	 */
	List<GIACOvrideCommPayts> getGIACOvrideCommPayts(Integer gaccTranId) throws SQLException;
	
	/**
	 * Executes the procedure CHCK_PREM_PAYTS on GIACS040
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	void chckPremPayts(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure CHCK_BALANCE on GIACS040
	 * @param params
	 * @throws SQLException
	 */
	void chckBalance(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates the CHILD_INTM_NO item of the block GOCP in GIACS040
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs040ChildIntmNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates the COMM_AMT item of the block GOCP in GIACS040
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs040CommAmt(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates the FOREIGN_CURR_AMT item of the block GOCP in GIACS040
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs040ForeignCurrAmt(Map<String, Object> params) throws SQLException;
	
	/**
	 * Saves GIAC Ovride Comm Payts records and performs post-forms-commit of GIACS040
	 * @param setOvrideCommPayts
	 * @param delOvrideCommPayts
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	String saveGIACOvrideCommPayts(JSONArray setOvrideCommPayts, JSONArray delOvrideCommPayts, Map<String, Object> params) throws SQLException, JSONException, ParseException;
	
	String validateTranRefund(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getInputVAT(Map<String, Object> params) throws SQLException;
	
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	String validateBill(Map<String, Object> params) throws SQLException;
}
