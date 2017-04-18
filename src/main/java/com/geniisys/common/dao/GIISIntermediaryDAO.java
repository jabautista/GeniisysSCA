/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISIntermediary;

/**
 * The Interface GiisIntermediaryDAO.
 */
public interface GIISIntermediaryDAO {

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
	 * Gets payor details
	 * 
	 * @return the payor details
	 * @throws SQLException The SQL Exception
	 */
	List<GIISIntermediary> getPayorLOV(String keyword) throws SQLException;
	
	/**
	 * Gets payor details
	 * 
	 * @return the payor details
	 * @throws SQLException The SQL Exception
	 */
	List<GIISIntermediary> getPayorLOV2(Map<String, Object> params) throws SQLException;
	
	
	/**
	 * Gets all intermediary details
	 * 
	 * @return the intermediary details
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
	 * 
	 * @param keyword
	 * @return the intermediary list
	 * @throws SQLException the sQL exception
	 */
	List<GIISIntermediary> getIntermediaryList2(String keyword) throws SQLException;
	
	/**
	 * Gets the intermediary list associated with table GIIS_BANC_TYPE_DTL.
	 * @param keyword
	 * @param bancTypeCd
	 * @param intmType
	 * @return
	 * @throws SQLException
	 */
	List<GIISIntermediary> getBancaIntermediaryList(String keyword, String bancTypeCd, String intmType) throws SQLException;
	
	/**
	 * Gets the intermediary list for Gipis085
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIISIntermediary> getGipis085IntmLOVListing(Map<String, Object> params) throws SQLException;

	Map<String, Object> getPremWarrLetter(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateIntmNo(Map<String, Object> params) throws SQLException;
	List<GIISIntermediary> validateIntmNoGiexs006(Integer intmNo) throws SQLException;
	Map<String, Object> validateIntmType(Map<String, Object> params) throws SQLException;
	String getParentIntmNo (Map<String, Object> params) throws SQLException;
	void extractIntmProdColln (Map<String, Object> params) throws SQLException;
	void extractWeb (Map<String, Object> params) throws SQLException;
	
	// shan 11.7.2013
	void saveGiiss203(Map<String, Object> params) throws SQLException;
	Map<String, Object> valDeleteRec(Map<String, Object> params) throws SQLException;
	//void valAddRec(Integer intmNo) throws SQLException;
	
	//shan 11.11.2013
	GIISIntermediary getGiiss076Record(Integer intmNo) throws SQLException;
	String getRequireWtax() throws SQLException;
	String getParentTinGiiis076(Integer parentIntmNo) throws SQLException;
	Integer valIntmNameGiiis076(String intmName) throws SQLException;
	String getGiacParamValueN(String paramName) throws SQLException;
	void valDeleteRecGiiis076(Integer intmNo) throws SQLException;
	void saveGiiss076(GIISIntermediary intm) throws SQLException;
	Map<String, Object> copyIntermediaryGiiss076(Map<String, Object> params) throws SQLException;
	Integer getIntermediaryNoSequence() throws SQLException;
	String checkMobilePrefixGiiss076(Map<String, Object> params) throws SQLException;
	
	String valCommRate(Map<String, Object> params) throws SQLException;
}
