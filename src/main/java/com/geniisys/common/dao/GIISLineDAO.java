/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISLine;


/**
 * The Interface GIISLineDAO.
 */
public interface GIISLineDAO {
	
	/**
	 * Gets the line listing.
	 * 
	 * @return the line listing
	 */
	List<GIISLine> getLineListing();	
	
	/**
	 * Gets the line listing by user id.
	 * 
	 * @param userId the user id
	 * @return the line listing by user id
	 */
	List<GIISLine> getLineListingByUserId(String userId);
	
	/**
	 * Gets the gIIS line name.
	 * 
	 * @param lineCd the line cd
	 * @return the gIIS line name
	 * @throws SQLException the sQL exception
	 */
	GIISLine getGIISLineName(String lineCd) throws SQLException;
	
	/**
	 * Gets the giis line list.
	 * 
	 * @return the giis line list
	 * @throws SQLException the sQL exception
	 */
	List<GIISLine> getGiisLineList() throws SQLException;
	String getPackPolFlag(String lineCd) throws SQLException;
	List<GIISLine> getCheckedLineIssourceList(Map<String, Object> params) throws SQLException;
	String getMenuLineCd(String lineCd) throws SQLException;
	
	List<GIISLine> getPolLinesForAssd(Integer assdNo) throws SQLException;
	List<GIISLine> getCheckedPackLineIssourceList(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> validatePolLineCd(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateLineCd(Map<String, Object> params) throws SQLException;
	List<GIISLine> validateLineCdGiexs006(Map<String, Object> params) throws SQLException;
	GIISLine getGiisLineGiuts036(String lineCd) throws SQLException;
	List<GIISLine> getAllRecapsCd() throws SQLException;
	String saveInvoice(Map<String, Object> allParams) throws SQLException;
	String validateDeleteLine(String lineCdToDelete) throws SQLException;
	String validateAddLine(String lineCdToAdd) throws SQLException;
	public String validateAcctLineCd(String acctLineCd) throws SQLException;
	
	List<GIISLine> getLineListingLOV(Map<String, Object> params) throws SQLException;
	String validateLineCdGiris051(Map<String, Object> params) throws SQLException;	//shan 01.17.2013
	String getLineCd(String lineName) throws SQLException;		//shan 01.30.2013
	String validateGIRIS051LinePPW(String lineName) throws SQLException;	//shan 05.15.2013
	Map<String, Object> getLineNameGicls201(Map<String, Object> params) throws SQLException;	//shan 03.15.2013
	String validateLineCd2(String lineCd) throws SQLException;
	Map<String, Object> validateGIACS102LineCd(Map<String, Object> params) throws SQLException;
	//added by steven 12.12.2013
	void saveGiiss001(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valMenuLineCd(String recId) throws SQLException;
	//end steve
	
	String getGiisLineName2(String lineCd) throws SQLException;
}
