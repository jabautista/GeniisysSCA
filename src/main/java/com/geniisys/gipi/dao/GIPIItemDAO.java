package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIItem;

public interface GIPIItemDAO {

	List<GIPIItem> getGIPIItemForEndt(int parId) throws SQLException;
	
	/**
	 * Retrives a list of Items for a given policy
	 * @param   policyId
	 * @returns list of Items
	 * @throws  SQLException
	 */
	List<GIPIItem> getRelatedItemInfo(HashMap<String,Object> params) throws SQLException;
	List<Map<String, Object>> getItemGroupList(HashMap<String,Object> params) throws SQLException;
	String getNonMCItemTitle(Map<String, Object> params) throws SQLException;
	String updatePolicyItemCoverage(Map<String, Object> allParams) throws SQLException;
	List<Integer> getEndtItemList(Map<String, Object> params) throws SQLException;
	List<GIPIItem> getItemAnnTsiPrem(int parId) throws SQLException;//monmon
	List<Map<String, Object>> getAttachments(Integer policyId, Integer itemNo) throws SQLException;
}
