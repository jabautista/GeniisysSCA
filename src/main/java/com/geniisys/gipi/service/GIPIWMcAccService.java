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

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWMcAcc;


/**
 * The Interface GIPIWMcAccService.
 */
public interface GIPIWMcAccService {

	/**
	 * Gets the gipi w mc acc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the gipi w mc acc
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWMcAcc> getGipiWMcAcc(int parId,int itemNo) throws SQLException;
	
	/**
	 * Gets the gipi w mc accby par id.
	 * 
	 * @param parId the par id
	 * @return the gipi w mc accby par id
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWMcAcc> getGipiWMcAccbyParId(int parId) throws SQLException;
	
	/**
	 * Save gipi w mc acc.
	 * 
	 * @param parameters the parameters
	 * @throws SQLException the sQL exception
	 */
	void saveGipiWMcAcc(Map<String, Object> parameters) throws SQLException;
	
	/**
	 * Delete gipi w mc acc.
	 * 
	 * @param gipiWMcAcc the gipi w mc acc
	 * @throws SQLException the sQL exception
	 */
	void deleteGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException;
	void deleteGipiWMcAcc(Map<String, Object> params) throws SQLException;
	List<GIPIWMcAcc> prepareGIPIWMcAccForInsert(JSONArray setRows) throws JSONException;
	List<Map<String, Object>> prepareGIPIWMcAccForDelete(JSONArray delRows) throws JSONException;
}
