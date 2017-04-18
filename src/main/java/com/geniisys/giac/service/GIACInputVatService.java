package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACInputVat;

public interface GIACInputVatService {

	List<GIACInputVat> getGiacInputVat(HashMap<String, String> params) throws SQLException;
	PaginatedList getPayeeList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList getSlNameList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList getAcctCodeList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	GIACChartOfAccts validateAcctCode(HashMap<String, String> params) throws SQLException;
	String saveInputVat(Map<String, Object> params) throws SQLException, JSONException;
	List<GIACInputVat> prepareGIACInputVatJSON(JSONArray rows, String userId) throws JSONException;
}
