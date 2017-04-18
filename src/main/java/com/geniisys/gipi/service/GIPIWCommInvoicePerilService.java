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

import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;


/**
 * The Interface GIPIWCommInvoicePerilService.
 */
public interface GIPIWCommInvoicePerilService {

	/**
	 * Gets the w comm invoice peril.
	 * 
	 * @param parId the par id
	 * @param itemGroup the item group
	 * @param intermediaryIntmNo the intermediary intm no
	 * @return the w comm invoice peril
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId, int itemGroup, int intermediaryIntmNo) throws SQLException;
	
	/**
	 * Gets the w comm invoice peril using parId only.
	 * 
	 * @param parId the par id
	 * @return the w comm invoice peril
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId) throws SQLException;
	
	/**
	 * Save w comm invoice peril.
	 * 
	 * @param commInvoicePeril The comm invoice peril to be saved
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWCommInvoicePeril(List<GIPIWCommInvoicePeril> commInvoicePerils) throws SQLException;
	
	/**
	 * Delete w comm invoice peril.
	 * 
	 * @param parId the par id
	 * @param itemGroup the item group
	 * @param intermediaryIntmNo the intermediary intm no
	 * @param perilCd the peril cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWCommInvoicePeril(int parId, int itemGroup, int intermediaryIntmNo, int perilCd) throws SQLException;
	
	/**
	 * Deletes comm invoice perils by list
	 * 
	 * @param commInvoicePerils The list of comm invoice perils 
	 * @return
	 * @throws SQLException
	 */
	boolean deleteWCommInvoicePerilsByList(List<GIPIWCommInvoicePeril> commInvoicePerils) throws SQLException;
	
	List<Map<String, Object>> prepareGIPIWCommInvoicePerilForDelete(JSONArray delRows) throws JSONException;
}
