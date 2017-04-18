package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACLossRecoveries;

public interface GIACLossRecoveriesService {
	
	List<GIACLossRecoveries> getGIACLossRecoveries(Integer gaccTranId) throws SQLException;
	PaginatedList getRecoveryNoList(HashMap<String, Object> params, Integer pageNo)throws SQLException;
	Map<String, Object> getSumCollnAmtLossRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCurrency(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateCurrencyCode(Map<String, Object> params) throws SQLException;
	String validateDeleteLossRec(Map<String, Object> params) throws SQLException;
	String getTranFlag(Integer gaccTranId) throws SQLException;
	List<GIACLossRecoveries> prepareGIACLossRecoveriesJSON(JSONArray rows, String userId) throws JSONException;
	String saveLossRec(Map<String, Object> params) throws SQLException;
	List<String> getManualRecoveryList(Map<String, Object> params) throws SQLException;
	List<String> checkPayorNameExist(Map<String, Object> params) throws SQLException;
	String checkCollectionAmt(Map<String, Object> params) throws SQLException;
}
