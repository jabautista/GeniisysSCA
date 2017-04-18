/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.pack.entity.GIPIPackMortgagee;


/**
 * The Interface GIPIParMortgageeDAO.
 */
public interface GIPIParMortgageeDAO {
	
	/**
	 * Gets the gIPI par mortgagee.
	 * 
	 * @param parId the par id
	 * @return the gIPI par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIParMortgagee> getGIPIParMortgagee(int parId) throws SQLException;
	public List<GIPIParMortgagee> getGIPIWMortgageeByItemNo(Map<String, Integer> params) throws SQLException;
	public List<GIPIParMortgagee> getGIPIWMortgagee(Integer parId) throws SQLException;
	
	/**
	 * Save gipi par mortgagee.
	 * 
	 * @param gipiParMortgagee the gipi par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIParMortgagee(GIPIParMortgagee gipiParMortgagee) throws SQLException;
	
	/**
	 * Sets the gIPI par mortgagee.
	 * 
	 * @param gipiParMortgagee the new gIPI par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public void setGIPIParMortgagee(List<GIPIParMortgagee> gipiParMortgagee) throws SQLException;
	
	/**
	 * Delete gipi par mortgagee.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIParMortgagee(int parId, int itemNo) throws SQLException;
	
	/**
	 * Delete gipi par mortgagee.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIParMortgagee(int parId) throws SQLException;
	
	/**
	 * Del gipi par mortgagee.
	 * 
	 * @param gipiParMortgagee the gipi par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public void delGIPIParMortgagee(List<GIPIParMortgagee> gipiParMortgagee) throws SQLException;
	
	/**
	 * Gets the mortgagees of the sub-policies that are under a Package PAR.
	 * @param packParId - the packParId of the Package PAR
	 * @throws SQLException - the SQLException
	 */
	
	public List<GIPIPackMortgagee> getPackParMortgagees (Integer packParId) throws SQLException;
	
	/**
	 * Save the mortgagee
	 * @param - map containing the records
	 * @throws SQLException - the SQLException
	 */
	public void saveMortgagee(Map<String, Object> params) throws SQLException;
}
