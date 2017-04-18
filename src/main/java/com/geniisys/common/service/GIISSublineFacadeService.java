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

import org.json.JSONException;


import com.geniisys.common.entity.GIISSubline;
import com.ibm.disthub2.impl.matching.selector.ParseException;


/**
 * The Interface GIISSublineFacadeService.
 */
public interface GIISSublineFacadeService {
	
	/**
	 * Gets the subline listing.
	 * 
	 * @param sublineCd the subline cd
	 * @return the subline listing
	 */
	public List<GIISSubline> getSublineListing(String sublineCd);
	
	/**
	 * Gets the subline listing by line cd.
	 * 
	 * @param lineCd the line cd
	 * @return the subline listing by line cd
	 */
	public List<GIISSubline> getSublineListingByLineCd(String lineCd);
	
	/**
	 * Gets the subline details.
	 * 
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the subline details
	 * @throws SQLException the sQL exception
	 */
	GIISSubline	getSublineDetails(String lineCd, String sublineCd) throws SQLException;
	
	
	Map<String, Object> validatePurgeSublineCd(Map<String, Object> params) throws SQLException;
	List<GIISSubline> validateSublineCdGiexs006(Map<String, Object> params) throws SQLException;
	String getOpFlagGiuts008a(Map<String, Object> params) throws SQLException;
	GIISSubline getSublineDetails2(String lineCd, String sublineCd) throws SQLException;
	String saveSubline(String parameters, Map<String, Object> params) throws JSONException, SQLException, ParseException;
	String validateDeleteSubline(Map<String, Object> params)throws JSONException, SQLException, ParseException;
	Map<String, Object> validateSublineCd(Map<String, Object> params) throws JSONException, SQLException, ParseException;
	String validateAddSubline(Map<String, Object> allParams) throws JSONException, SQLException, ParseException;
	String validateAcctSublineCd(Map<String, Object> allParams) throws SQLException;
	String validateOpenSw(Map<String, Object> allParams) throws SQLException;
	String validateOpenFlag(Map<String, Object> allParams) throws SQLException;
}
