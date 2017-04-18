/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;


/**
 * The Interface GIISIntermediaryService.
 */
public interface GIISIntermediaryService {

	/**
	 * Gets the intermediary list.
	 * 
	 * @param intmNo the intm no
	 * @return the intermediary list
	 * @throws SQLException the sQL exception
	 */
	List<GIISIntermediary> getIntermediaryList(int intmNo) throws SQLException;
	
	/**
	 * Gets the parent intermediary name.
	 * 
	 * @param parentIntmNo the parent intm no
	 * @return the parent intermediary name
	 * @throws SQLException the sQL exception
	 */
	String getParentIntermediaryName(int parentIntmNo) throws SQLException;
	
	/**
	 * Gets the default tax rate
	 * 
	 * @param intmNo Intermediary No.
	 * @return The default tax rate
	 * @throws SQLException The SQL Exception
	 */
	BigDecimal getDefaultTaxRate(int intmNo) throws SQLException;
	
	/**
	 * Gets payor list
	 * 
	 * @return payor list details
	 * @throws SQLException The SQL Exception
	 */
	PaginatedList getPayorLOV(Integer pageNo, String keyword) throws SQLException;
	
	/**
	 * Gets payor list
	 * 
	 * @return payor list details
	 * @throws SQLException The SQL Exception
	 */
	PaginatedList getPayorLOV2(HttpServletRequest request, Integer pageNo) throws SQLException;
	
	/**
	 * Gets all intermediary list
	 * 
	 * @return intermediary list details
	 * @throws SQLException The SQL Exception
	 */
	List<GIISIntermediary> getAllGIISIntermediary() throws SQLException;
	
	/**
	 * Gets list of distinct intermediaries existing in GIPI Comm Invoice
	 * @param tranType The transaction type
	 * @param issCd The issue source code
	 * @param premSeqNo The prem seq no
	 * @param intmName The intm name to be searched
	 * @return The list of intermediaries
	 * @throws SQLException
	 */
	List<GIISIntermediary> getGIPICommInvoiceIntmList(String tranType, String issCd, String premSeqNo, String intmName) throws SQLException;
	
	/**
	 * Gets the complete intermediary list.
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getIntermediaryList2(Integer pageNo, String keyword) throws SQLException;
	
	/**
	 * Gets the intermediary list associated with table GIIS_BANC_TYPE_DTL.
	 * @param pageNo
	 * @param keyword
	 * @param bancTypeCd
	 * @param intmType
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getBancaIntermediaryList(Integer pageNo, String keyword, String bancTypeCd, String intmType) throws SQLException;
	
	PaginatedList getGipis085IntmLOVListing(Integer pageNo, Map<String, Object> params) throws SQLException;

	void getPremWarrLetter(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> validateIntmNo(Map<String, Object> params) throws SQLException;
	List<GIISIntermediary> validateIntmNoGiexs006(Integer intmNo) throws SQLException;
	Map<String, Object> validateIntmType(Map<String, Object> params) throws SQLException;
	String getParentIntmNo (HttpServletRequest request) throws SQLException;
	String extractIntmProdColln (HttpServletRequest request, String userId) throws SQLException;
	String extractWeb (HttpServletRequest request, String userId) throws SQLException;
	
	// shan 11.7.2013
	JSONObject showGiiss203(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss203(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//void valAddRec(HttpServletRequest request) throws SQLException;
	
	GIISIntermediary getGiiss076Record(Integer intmNo) throws SQLException;
	String getRequireWtax() throws SQLException;
	String getParentTinGiiss076(Integer parentIntmNo) throws SQLException;
	Integer valIntmNameGiiss076(String intmName) throws SQLException;
	String getGiacParamValueN(String paramName) throws SQLException;
	void valDeleteRecGiiss076(Integer intmNo) throws SQLException;
	String saveGiiss076(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	Integer copyIntermediaryGiiss076(HttpServletRequest request) throws SQLException;
	String checkMobilePrefixGiiss076(HttpServletRequest request) throws SQLException;
	
	String valCommRate(HttpServletRequest request) throws SQLException;
}
