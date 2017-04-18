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

import com.geniisys.gipi.entity.GIPIWinvperl;


/**
 * The Interface GIPIWinvperlFacadeService.
 */
public interface GIPIWinvperlFacadeService {
	
	/**
	 * Gets the gIPI winvperl.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @param lineCd the line cd
	 * @return the gIPI winvperl
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, int itemGrp, String lineCd) throws SQLException;
	
	/**
	 * Gets the gIPI winvperl using par Id and Line Cd only.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @return the gIPI winvperl
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, String lineCd) throws SQLException;
	
	/**
	 * Gets the item grp winvperl.
	 * 
	 * @param parId the par id
	 * @return the item grp winvperl
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvperl> getItemGrpWinvperl(int parId) throws SQLException;
	
	/**
	 * Gets the takeup winvperl.
	 * 
	 * @param parId the par id
	 * @return the takeup winvperl
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvperl> getTakeupWinvperl(int parId) throws SQLException;
}
