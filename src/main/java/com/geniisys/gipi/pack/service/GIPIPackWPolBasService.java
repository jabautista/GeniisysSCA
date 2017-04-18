package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;

public interface GIPIPackWPolBasService {
	
	/**
	 * Get record details for Package PAR Basic Info from GIPI_PACK_WPOLBAS.
	 * 
	 * @param packParId - the pack par id
	 * @return GIPIPackWPolBas
	 * @throws SQLException the SQL exception
	 */
	
	GIPIPackWPolBas getGIPIPackWPolBas (int packParId) throws SQLException;
	
	/**
	 * Executes the WHEN-NEW-FORM-INSTANCE trigger of GIPIS031A
	 * @param params
	 * @throws SQLException
	 */
	void executeGipis031ANewFormInstance(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure GET_ACCT_OF_CD of GIPIS031A
	 * @param params
	 * @throws SQLException
	 */
	void executeGipis031AGetAcctOfCd(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes procedures of GIPIS031A to check if policy exists
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> checkPolicyNoForPackEndt(Map<String, Object> params) throws SQLException;
	
	/**
	 * Fetches the info needed in loading the Package Endt Basic Info page
	 * @param params
	 * @throws SQLException
	 */
	void getEndtPackBasicInfoRecs(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the SEARCH_FOR_POLICY trigger of the module GIPIS031A (Pack Endt Basic Info)
	 * @param params
	 * @throws SQLException
	 */
	void searchForPolicy(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save endt pack basic info
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	public Map<String, Object> saveEndtBasicInfo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the WHEN-NEW-FORM-INSTANCE trigger of GIPIS002A
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @return the map
	 * @throws SQLException the SQL Exception
	 */
	Map<String, String> newFormInst(String lineCd, String issCd) throws SQLException;
	
	/**
	 * Checks if record exist in GIPI_PACK_WPOLBAS with the given packParId.
	 * 
	 * @param packParId - the pack par id
	 * @return the map
	 * @throws SQLException the SQL exception
	 */
	Map<String, String> isPackWPolbasExist(Integer packParId) throws SQLException;
	
	/**
	 * Get default values for Package PAR Basic Info without GIPI_PACK_WPOLBAS record.
	 * 
	 * @param packParId - the pack par id
	 * @return GIPIPackWPolBas
	 * @throws SQLException the SQL exception
	 */
	
	GIPIPackWPolBas getGipiPackWPolbasDefaultValues(Integer packParId) throws SQLException;
	
	/**
	 * Saves Package PAR Basic Information.
	 * 
	 * @param params - map of parameters to be save
	 * @return map
	 * @throws SQLException the SQL exception
	 */
	Map<String, Object> savePackPARBasicInfo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Checks existing table records of Package PAR sub-policies.
	 * 
	 * @param packParId - the pack_par_id value
	 * @return map
	 * @throws SQLException the SQL exception
	 */
	Map<String, Object> checkPackParExistingTables(Integer packParId) throws SQLException;
	
	/**
	 * check if policy have affecting endorsement that can be cancelled
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String checkPolicyForAffectingEndtToCancel(Map<String, Object> params) throws SQLException;
	
	/**
	 * This function checks for the existence of peril of specified pack par id
	 * @param parId
	 * @return
	 * @throws SQLException
	 */
	String checkIfExistingInGipiWitmperl(Integer parId) throws SQLException;
	
	/**
	 * This function checks for the existence of item(s) of specified pack par id
	 * @param parId
	 * @return
	 * @throws SQLException
	 */
	String checkIfExistingInGipiWitem(Integer parId) throws SQLException;
	
	/**
	 * Gets the LOV records for pack endt cancellation
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getRecordsForPackEndtCancellation(Map<String, Object> params) throws SQLException;
	
	/**
	 * Returns the no of item and peril of the given pack_par_id
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> checkPackEndtForItemAndPeril(Map<String, Object> params) throws SQLException;
	
	/**
	 * Generates Bank Reference No. for Package PAR.
	 * @param params - Map
	 * @return Map
	 * @throw SQL Exception
	 */
	Map<String, Object> generateBankRefNoForPack(Map<String, Object> params) throws SQLException;
	
	/**
	 * Execute Pre get_amount
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String preGetAmountsForPackEndt(Map<String, Object> params) throws SQLException;

	/**
	 * Execute CREATE_NEGATED_RECORDS_FLAT procedure for Pack Endt
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> createNegatedRecordsFlat(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates if ref_pol no is already existing in other policy nos / par nos
	 * @param packParId - the packParId
	 * @param refPolNo - the refPolNo
	 * @return String - the message
	 * @throws SQL Exception - the SQL Exception
	 */
	String validatePackRefPolNo (Integer packParId, String refPolNo) throws SQLException;
	
	/**
	 * Validates the endt eff date in endorsement pack basic info (GIPIS031A)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validatePackEndtEffDate(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> processPackEndtCancellation(Map<String, Object> params) throws SQLException;
	Map<String, Object> searchForEditedPackPolicy(HttpServletRequest request) throws SQLException;
}
