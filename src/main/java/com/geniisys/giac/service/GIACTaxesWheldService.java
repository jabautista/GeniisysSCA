package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.giac.entity.GIACTaxesWheld;

public interface GIACTaxesWheldService {

	/**
	 * Gets the GIAC_TAXES_WHELD records of specified tran id
	 * @param gaccTranId The gacc tran Id.
	 * @return
	 * @throws SQLException
	 */
	List<GIACTaxesWheld> getGiacTaxesWheld(Integer gaccTranId) throws SQLException;
	
	/**
	 * Saves GIAC Taxes Wheld records and performs post-forms-commit of GIACS022
	 * @param setRows
	 * @param delRows
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	String saveGIACTaxesWheld(JSONArray setRows, JSONArray delRows, Map<String, Object> params) throws SQLException, JSONException, ParseException;

	String saveBir2307History(Map<String, Object> params) throws SQLException;//Added by pjsantos 12/27/2016, GENQA 5898
}
