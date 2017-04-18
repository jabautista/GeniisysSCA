package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;

public interface GIPIWItmperlBeneficiaryService {

	List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary2(Integer parId) throws SQLException;
	List<GIPIWItmperlBeneficiary> prepareGIPIWItmperlBeneficiaryForInsertUpdate(JSONArray setRows) throws JSONException;
	List<Map<String, Object>> prepareGIPIWItmperlBeneficiaryForDelete(JSONArray delRows) throws JSONException;
}
