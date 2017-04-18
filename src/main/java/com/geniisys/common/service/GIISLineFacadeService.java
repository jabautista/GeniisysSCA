/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;


import com.geniisys.common.entity.GIISLine;
import com.ibm.disthub2.impl.matching.selector.ParseException;


/**
 * The Interface GIISLineFacadeService.
 */
public interface GIISLineFacadeService {

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
	String saveLine(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	String validateDeleteLine(String lineCd) throws JSONException, SQLException, ParseException;
	String validateAddLine(String lineCd) throws JSONException, SQLException, ParseException;
	String validateAcctLineCd(String acctLineCd) throws SQLException;
	
	List<GIISLine> getLineListingLOV(Map<String, Object> params) throws SQLException;
	String validateLineCdGiris051(Map<String, Object> params) throws SQLException;	//shan 01.17.2013
	String getLineCd(String lineName) throws SQLException;		//shan 01.30.2013
	String validateGIRIS051LinePPW(HttpServletRequest request) throws SQLException;	//shan 05.15.2013
	String getLineNameGicls201(HttpServletRequest request, String userId) throws SQLException;	//shan 03.15.2013
	String validateLineCd2(HttpServletRequest request) throws SQLException;	
	Map<String, Object> validateGIACS102LineCd(HttpServletRequest request) throws SQLException;
	//added by steven 12.12.2013
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss001(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valMenuLineCd(HttpServletRequest request) throws SQLException;
	//end by steven 12.12.2013
	
	String getGiisLineName2(String lineCd) throws SQLException;
}
