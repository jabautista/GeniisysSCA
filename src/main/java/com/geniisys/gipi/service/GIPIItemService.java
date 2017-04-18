package com.geniisys.gipi.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIItem;

public interface GIPIItemService {

	List<GIPIItem> getGIPIItemForEndt(int parId) throws SQLException;
	
	/**
	 * Retrieves List of Items for a given policy
	 * @param   a HashMap containing table grid parameters and policyId
	 * @returns HashMap that contains list of Items
	 * @throws  SQLException
	 */
	HashMap<String, Object> getRelatedItemInfo(HashMap<String, Object> params) throws SQLException;
	String getNonMCItemTitle(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String updatePolicyItemCoverage(HttpServletRequest request, String userId) throws JSONException, SQLException;
	JSONObject getGIPIS175Items(HttpServletRequest request) throws JSONException, SQLException;
	List<Integer> getEndtItemList(HttpServletRequest request) throws SQLException;
	List<GIPIItem> getItemAnnTsiPrem(int parId) throws SQLException, ParseException;//monmon
	Integer getAttachmentTotalSize(Integer policyId, Integer itemNo) throws SQLException, IOException;
}
