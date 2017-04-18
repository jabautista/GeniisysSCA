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

import com.geniisys.common.entity.GIISSubline;


/**
 * The Interface GIISSublineDAO.
 */
public interface GIISSublineDAO {
	
	/**
	 * Gets the gIIS subline listing.
	 * 
	 * @param sublineCd the subline cd
	 * @return the gIIS subline listing
	 */
	public List<GIISSubline> getGIISSublineListing(String sublineCd);
	
	/**
	 * Gets the gIIS subline listing by line cd.
	 * 
	 * @param lineCd the line cd
	 * @return the gIIS subline listing by line cd
	 */
	public List<GIISSubline> getGIISSublineListingByLineCd(String lineCd);
	
	/**
	 * Gets the subline details.
	 * 
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the subline details
	 * @throws SQLException the sQL exception
	 */
	GIISSubline getSublineDetails(String lineCd, String sublineCd) throws SQLException;
	
	public String getSublineName(String lineCd, String sublineCd) throws SQLException;
	Map<String, Object> validateSublineCd(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePurgeSublineCd(Map<String, Object> params) throws SQLException;
	List<GIISSubline> validateSublineCdGiexs006(Map<String, Object> params) throws SQLException;
	String getOpFlagGiuts008a(Map<String, Object> params) throws SQLException;
	GIISSubline getSublineDetails2(Map<String, String> params) throws SQLException;
	String validateDeleteSubline(Map<String, Object> allParams)throws SQLException;
	String validateAddSubline(Map<String, Object> allParams) throws SQLException;
	String saveInvoice(Map<String, Object> allParams) throws SQLException;
	String validateAcctSublineCd(Map<String, Object> allParams) throws SQLException;
	String validateOpenSw(Map<String, Object> allParams) throws SQLException;
	String validateOpenFlag(Map<String, Object> allParams) throws SQLException;
	
}
