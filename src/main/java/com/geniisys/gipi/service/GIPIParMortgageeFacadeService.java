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

import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.pack.entity.GIPIPackMortgagee;


/**
 * The Interface GIPIParMortgageeFacadeService.
 */
public interface GIPIParMortgageeFacadeService {
	
	/**
	 * Gets the gIPI par mortgagee.
	 * 
	 * @param parId the par id
	 * @return the gIPI par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIParMortgagee> getGIPIParMortgagee(int parId) throws SQLException;
	public List<GIPIParMortgagee> getGIPIWMortgageeByItemNo(HttpServletRequest request) throws SQLException;
	public List<GIPIParMortgagee> getGIPIWMortgagee(Integer parId) throws SQLException;
	
	/**
	 * Save gipi par mortgagee.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIParMortgagee(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save gipi par mortgagee.
	 * 
	 * @param gipiParMortgagee the gipi par mortgagee
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIParMortgagee(GIPIParMortgagee gipiParMortgagee) throws SQLException;
	
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
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIParMortgagee(Map<String, Object> params) throws SQLException;
	public List<GIPIParMortgagee> prepareGIPIWMortgageeForInsert(JSONArray setRows) throws JSONException;
	public List<Map<String, Object>> prepareGIPIWMortgageeForDelete(JSONArray delRows) throws JSONException;
	
	/**
	 * Gets the mortgagees of the sub-policies that are under a Package PAR.
	 * @param packParId - the packParId of the Package PAR
	 * @throws SQLException - the SQLException
	 */
	
	public List<GIPIPackMortgagee> getPackParMortgagees (Integer packParId) throws SQLException;
	
	public void newFormInstance(Map<String, Object> params) throws SQLException, JSONException;	
}
