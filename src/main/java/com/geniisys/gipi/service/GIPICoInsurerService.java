package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.gipi.entity.GIPIMainCoIns;

public interface GIPICoInsurerService {

	public List<GIPICoInsurer> getCoInsurerDetails(int parId) throws SQLException;
	public GIPIMainCoIns getCoInsurerAmts(int parId) throws SQLException;
	public Map<String, Object> getCoInsurerSharePct(Integer parId) throws SQLException;
	public Map<String, Object> getCoInsurerDefaultParams(Map<String, Object> params) throws SQLException;
	public List<GIPICoInsurer> getDefaultCoInsurers(int policyId) throws SQLException;
	public Map<String, Object> saveEnteredCoInsurers(String param, String userId) throws SQLException, JSONException;
	public HashMap<String, Object> getCoInsurers(HashMap<String,Object> params) throws SQLException;
	public String checkCoInsurerAccess(Integer parId) throws SQLException;
	public void processDefaultEndtCoIns(Map<String,Object> params) throws SQLException;
}
