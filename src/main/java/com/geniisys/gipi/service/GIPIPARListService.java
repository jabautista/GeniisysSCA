/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIPARList;
import com.ibatis.sqlmap.client.SqlMapException;


/**
 * The Interface GIPIPARListService.
 */
public interface GIPIPARListService {
	
	/**
	 * Save gipipar.
	 * 
	 * @param gipiPar the gipi par
	 * @return the gIPIPAR list
	 * @throws SqlMapException the sql map exception
	 * @throws SQLException the sQL exception
	 */
	GIPIPARList saveGIPIPAR(GIPIPARList gipiPar) throws SqlMapException, SQLException;
	
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
	 * Gets the gipi par list.
	 * 
	 * @param lineCd the line cd
	 * @param pageNo the page no
	 * @param keyword the keyword
	 * @param userId 
	 * @return the gipi par list
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getGipiParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException;
	
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
	void insertParHist(Integer parId, String userId, String entrySource,
			String parstatCd) throws SQLException;
	
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
	PaginatedList getEndtParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException;
	String getParNo(Integer parId) throws SQLException;
	String getParNo2(Integer policyId) throws SQLException;
	String copyParList(Map<String, Object> params) throws SQLException, Exception;
	void deletePar(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> saveParCreationPageChanges(Map<String, Object> params) throws SQLException, Exception;
	public void returnPARToQuotation(int quoteId) throws SQLException;
	void cancelPar(Map<String, Object> params) throws SQLException, Exception;
	HashMap<String, Object> getGipiParListing(HashMap<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> checkRITablesBeforePARDeletion (Integer parId) throws SQLException;
	void updateParRemarks (JSONArray updatedRows) throws SQLException, JSONException;
	List<GIPIPARList> getPackItemParList(Integer packParId, String lineCd) throws SQLException;
	List<GIPIPARList> getAllPackItemParList(Integer packParId, String lineCd) throws SQLException;
	String checkParlistDependency(Integer inspNo) throws SQLException;
	HashMap<String, Object> getParAssuredList(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> getParEndorsementTypeList(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> saveRIPar(String param, String userId, int mode, String parType) throws SQLException, JSONException, ParseException, Exception;
	List<GIPIPARList> getPackPolicyList(Integer packParId) throws SQLException;
	List<GIPIPARList> getParListGIPIS031A(Integer packParId) throws SQLException;
	Map<String, Object> copyParToParGiuts007(Map<String, Object> params) throws SQLException;
	List<GIPIPARList> getParStatusGiuts007(HashMap<String, Object> params) throws SQLException;
	Integer generateParIdGiuts008a() throws SQLException;
	Map<String, Object> insertParListGiuts008a(Map<String, Object> params) throws SQLException;
	String getSharePercentageGipis085(Integer parId) throws SQLException;
	Integer whenNewFormInstGipis017B(Integer parId) throws SQLException;
	
	//shan 10.20.2013
	JSONObject getParListGIPIS211(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getParVehiclesGIPIS211(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getParVehicleItemsGIPIS211(HttpServletRequest request) throws SQLException, JSONException;
	
	String checkForPostedBinder(Integer parId) throws SQLException; //Created by J. Diago 09.11.2014
	String checkIfInvoiceExistsRI(Integer parId) throws SQLException; //Created by J. Diago 09.15.2014
	void recreateWInvoiceGiris005(Integer parId) throws SQLException; //Created by J. Diago 09.15.2014

	Map<String, Object> checkAllowCancel(Integer parId) throws SQLException;// edgar 02/16/2015
}
