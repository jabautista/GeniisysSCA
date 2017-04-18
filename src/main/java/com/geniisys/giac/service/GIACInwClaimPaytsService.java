package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.giac.entity.GIACInwClaimPayts;

public interface GIACInwClaimPaytsService {

	/**
	 * Gets the GIAC_INW_CLAIM_PAYTS records of specified tran id
	 * @param gaccTranId
	 * @return
	 * @throws SQLException
	 */
	List<GIACInwClaimPayts> getGIACInwClaimPayts(Integer gaccTranId) throws SQLException;
	
	/**
	 * Gets the claim no, policy no, and assured name based on specified claim id
	 * @param claimId
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getClaimPolicyAndAssured(Integer claimId) throws SQLException;
	
	/**
	 * Gets the list of records for the CLM_LOSS_ID record group
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getClmLossIdListing(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates the item DSP_PAYEE_DESC of GICP block on GIACS018 (Facul Claim Payts)
	 * @param params
	 * @throws SQLException
	 */
	void validatePayee(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the PRE-INSERT trigger of GICP block in GIACS018 (Facul Claim Payts)
	 * function returns 'Y' if record in GIIS_PAYEES exist, otherwise 'N'
	 * @param params
	 * @throws SQLException
	 */
	void executeGiacs018PreInsertTrigger(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the POST-FORMS-COMMIT trigger in GIACS018
	 * @param params
	 * @throws SQLException
	 */
	void executeGiacs018PostFormsCommit(Map<String, Object> params) throws SQLException;
	
	/**
	 * Inserts/Updates GIAC Inw Claim Payts Records
	 * @param inwClaimPaytsList
	 * @throws SQLException
	 */
	void setGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList) throws SQLException;
	
	/**
	 * Deletes GIAC Inw Claim Payts Records
	 * @param inwClaimPaytsList
	 * @throws SQLException
	 */
	void delGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList) throws SQLException;
	
	/**
	 * Saves GIAC Inw Claim Payts records and performs key-delrec and post-forms-commit of GIACS018
	 * @param setInwClaimPaytsList
	 * @param delInwClaimPaytsList
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> saveGIACInwClaimPayts(JSONArray setRows, JSONArray delRows, Map<String, Object> params) throws SQLException, JSONException, ParseException;
}
