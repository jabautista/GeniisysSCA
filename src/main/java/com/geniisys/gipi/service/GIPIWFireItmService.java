/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWFireItm;


/**
 * The Interface GIPIWFireItmService.
 */
public interface GIPIWFireItmService {

	/**
	 * Gets the gIPIW fire items.
	 * 
	 * @param parId the par id
	 * @return the gIPIW fire items
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWFireItm> getGIPIWFireItems(int parId) throws SQLException;
	
	/**
	 * Sets the gIPIW fire item.
	 * 
	 * @param wFireItem the new gIPIW fire item
	 * @throws SQLException the sQL exception
	 */
	void setGIPIWFireItem(List<GIPIWFireItm> wFireItem) throws SQLException;
	
	/**
	 * Sets the gipiw fire item.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void setGIPIWFireItem(Map<String, Object> params) throws SQLException;
	
	/**
	 * Del gipiw fire item.
	 * 
	 * @param wFireItem the w fire item
	 * @throws SQLException the sQL exception
	 */
	void delGIPIWFireItem(List<GIPIWFireItm> wFireItem) throws SQLException;
	
	/**
	 * Del gipiw fire item.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void delGIPIWFireItem(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the assured mailing address.
	 * 
	 * @param assdNo the assd no
	 * @return the assured mailing address
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> getAssuredMailingAddress(int assdNo) throws SQLException;
	
	/**
	 * Gets the fire parameters.
	 * 
	 * @return the fire parameters
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> getFireParameters() throws SQLException;
	BigDecimal getFireTariff(int parId, int itemNo) throws SQLException;
	
	/**
	 * Check if all items created has additional information in gipi_wfireitm
	 * @param parId The Par Id
	 * @return The result message.
	 * @throws SQLException
	 */
	String checkAddtlInfo(int parId) throws SQLException;
	
	/**
	 * Gets the values of basic variables during the loading of Endt Fire Item page 
	 * @param params The parameter map
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGIPIS039BasicVarValues(Map<String, Object> params) throws SQLException;
	boolean saveFireItem (Map<String, Object> params) throws SQLException; // added by nica
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWFireItm(String param, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> gipis039NewFormInstance(Map<String, Object> params)throws SQLException, JSONException;
	void gipis03B9540WhenValidateItem(Map<String, Object> params) throws SQLException; 
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> getTariffZoneOccupancyValue(Map<String, Object>params) throws SQLException;
}
