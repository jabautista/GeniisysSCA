package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACLossRiCollns;

public interface GIACLossRiCollnsService {

	PaginatedList getLossAdviceList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	List<GIACLossRiCollns> getGIACLossRiCollns(Integer gaccTranId) throws SQLException;
	List<Map<String, Object>> validateFLA(HashMap<String, Object> params) throws SQLException;  //shan 07.24.2013; SR-13688 changed from Map to List to handle FLA with different payee types
	Map<String, Object> validateCurrencyCode(Map<String, Object> params) throws SQLException;
	Map<String, Object> prepareParametersGIACLossRiCollns(HttpServletRequest request, GIISUser USER, Integer gaccTranId, String gaccBranchCd, String gaccFundCd) throws JSONException;
	String saveLossesRecov(Map<String, Object> params) throws SQLException;
	List<GIACLossRiCollns> prepareGIACLossRiCollnsJSON(JSONArray rows, String userId) throws JSONException;
	HashMap<String, Object> getLossAdviceListTableGrid(HashMap<String, Object> params) throws SQLException, JSONException;
}
