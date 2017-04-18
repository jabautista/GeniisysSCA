/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIPARList;
import com.ibatis.sqlmap.client.SqlMapException;


/**
 * The Interface GIPIPARListDAO.
 */
public interface GIPIPARListDAO {
	
	/**
	 * Save gipipar.
	 * 
	 * @param gipipar the gipipar
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIPAR(GIPIPARList gipipar)throws SQLException; 
	
	/**
	 * Gets the gIPIPAR details.
	 * 
	 * @param parId the par id
	 * @param packParId the pack par id
	 * @return the gIPIPAR details
	 * @throws SQLException the sQL exception
	 */
	GIPIPARList getGIPIPARDetails(Integer parId, Integer packParId) throws SQLException;
	
	/**
	 * Gets the gIPIPAR details.
	 * 
	 * @param parId the par id
	 * @return the gIPIPAR details
	 * @throws SQLException the sQL exception
	 */
	GIPIPARList getGIPIPARDetails(Integer parId) throws SQLException;
	
	/**
	 * Gets the new par id.
	 * 
	 * @return the new par id
	 * @throws SQLException the sQL exception
	 */
	Integer getNewParId()throws SQLException;
	
	/**
	 * Check par quote.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkParQuote(Integer parId) throws SQLException;
	
	/**
	 * Update status from quote.
	 * 
	 * @param quoteId the quote id
	 * @param parStatus the par status
	 * @throws SQLException the sQL exception
	 */
	void updateStatusFromQuote(Integer quoteId, Integer parStatus) throws SQLException;
	
	/**
	 * Insert par hist.
	 * 
	 * @param parId the par id
	 * @param userId the user id
	 * @param entrySource the entry source
	 * @param parstatCd the parstat cd
	 * @throws SQLException the sQL exception
	 */
	void insertParHist(Integer parId, String userId, String entrySource, String parstatCd) throws SQLException;
	
	/**
	 * Delete bill.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteBill(Integer parId) throws SQLException;
	
	/**
	 * Sets the par status to with peril.
	 * 
	 * @param parId the par id
	 * @param packParId the pack par id
	 * @throws SQLException the sQL exception
	 */
	void setParStatusToWithPeril(Integer parId, Integer packParId) throws SQLException;
	
	/**
	 * Sets the par status to with peril.
	 * 
	 * @param parId the new par status to with peril
	 * @throws SQLException the sQL exception
	 */
	void setParStatusToWithPeril(Integer parId) throws SQLException;
	
	void updatePARStatus(Integer parId, Integer parStatus) throws SQLException;
	
	/**
	 * 
	 * Gets gipi_par_list where par_type = 'E'
	 * 
	 * @param lineCd
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPARList> getEndtParList(String lineCd, String keyword, String userId) throws SQLException;
	String getParNo(Integer parId) throws SQLException;
	String getParNo2(Integer policyId) throws SQLException;
	
	/* Copy related methods */
	String copyParList(Map<String, Object> params) throws SQLException, Exception;
	void deletePar(Map<String, Object> params) throws SQLException, Exception;
	void setPackageMenu(Integer packParId) throws SQLException;
	Map<String, Object> saveParCreationPageChanges(Map<String, Object> params) throws SQLException, Exception;
	/* end of copy related methods*/
	
	public void returnPARToQuotation(int quoteId) throws SQLException;
	void cancelPar(Map<String, Object> params) throws SQLException, Exception;
	List<GIPIPARList> getGipiParListing(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> checkRITablesBeforePARDeletion (Integer parId) throws SQLException;
	void updateParRemarks(List<GIPIPARList> updatedRows) throws SQLException;
	List<GIPIPARList> getGipiParList(String lineCd, String keyword, String userId) throws SQLException;
	List<GIPIPARList> getPackItemParList(Map<String, Object> params) throws SQLException;
	List<GIPIPARList> getAllPackItemParList(Map<String, Object> params) throws SQLException;
	String checkParlistDependency(Integer inspNo) throws SQLException;
	List<GIPIPARList> getParAssuredList(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> saveInitialAcceptance(Map<String, Object> params, int mode) throws SQLException;
	List<GIPIPARList> getPackPolicyList(Integer packParId) throws SQLException;

	List<GIPIPARList> getParEndorsementTypeList(HashMap<String, Object> params) throws SQLException;
	List<GIPIPARList> getParListGIPIS031A(Integer packParId) throws SQLException;
	Map<String, Object> copyParToParGiuts007(Map<String, Object> params) throws SQLException;
	List<GIPIPARList> getParStatusGiuts007(HashMap<String, Object> params) throws SQLException;
	Integer generateParIdGiuts008a() throws SQLException;
	Map<String, Object> insertParListGiuts008a(Map<String, Object> params) throws SQLException;
	//void copyParToParGiuts007(Map<String, Object> params) throws SQLException;
	String getSharePercentageGipis085(Integer parId) throws SQLException;
	Integer whenNewFormInstGipis017B(Integer parId) throws SQLException;
	String checkForPostedBinder(Integer parId) throws SQLException;
	String checkIfInvoiceExistsRI(Integer parId) throws SQLException;
	void recreateWInvoiceGiris005(Integer parId) throws SQLException;

	Map<String, Object> checkAllowCancel(Integer parId) throws SQLException;
}
