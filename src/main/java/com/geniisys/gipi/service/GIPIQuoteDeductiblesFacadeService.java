/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISDeductibleDesc;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;


/**
 * The Interface GIPIQuoteDeductiblesFacadeService.
 */
public interface GIPIQuoteDeductiblesFacadeService {
	
	/**
	 * Gets the gIPI quote deductibles summary list.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote deductibles summary list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesSummaryList(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote deductibles.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteDeductibles(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save gipi quote deductibles.
	 * 
	 * @param gipiQuoteDeductibles the gipi quote deductibles
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteDeductibles(GIPIQuoteDeductibles gipiQuoteDeductibles) throws SQLException;
	
	/**
	 * Delete gipi quote deductibles.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteDeductibles(int quoteId)throws SQLException;
	
	/**
	 * Gets the deductible list.
	 * 
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the deductible list
	 * @throws SQLException the sQL exception
	 */
	public List<GIISDeductibleDesc> getDeductibleList(String lineCd, String sublineCd) throws SQLException;

	/**
	 * Gets the deductible sum.
	 * 
	 * @param quoteId the quote id
	 * @return the deductible sum
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuoteDeductibles getDeductibleSum(int quoteId) throws SQLException;
	
	public List<GIPIQuoteDeductibles> getItemDeductibles(int quoteId) throws SQLException;
	

	/**
	 * Create a list og GipiQuoteDeductiblesSummary from jsonArray rows from jsp
	 * @param jsonArray rows from jsp
	 * @param USER
	 * @return List of GipiQuoteDeductiblesSummary
	 * @throws SQLException
	 */
	public List<GIPIQuoteDeductiblesSummary> prepareGIPIQuoteDeductiblesSummaryJSON(JSONArray rows, GIISUser USER) throws JSONException;
	
	/**
	 * Gets the GIPI quote deductibles summary list for Package Quotation.
	 * 
	 * @param packQuoteId - the package quote id
	 * @return the GIPI quote deductibles summary list
	 * @throws SQLException - the SQL exception
	 */
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesForPackList(Integer packQuoteId) throws SQLException;
	
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
	void saveGIPIQuoteDeductibles2(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	/**
	 * nieko Check quote's item and peril
	 * 
	 * @param globalQuoteId
	 * @param deductibleType
	 * @param deductibleLevel
	 * @param itemNo
	 * @return
	 * @throws SQLException
	 */
	public String checkQuoteDeductible(int globalQuoteId, String deductibleType, int deductibleLevel, int itemNo) throws SQLException;
	
	/**
	 * nieko get list of quote item perils
	 */
	public List<LOV> getQuotePerilList(int quoteId) throws SQLException;
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
}
