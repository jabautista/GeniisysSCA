package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;

public interface GIPIWGrpItemsBeneficiaryService {

	List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary2(Integer parId) throws SQLException;
	List<GIPIWGrpItemsBeneficiary> getRetGipiWGrpItemsBeneficiary(Map<String, Object> params) throws SQLException;
	List<GIPIWGrpItemsBeneficiary> prepareGIPIWGrpItemsBeneficiaryForInsertUpdate(JSONArray setRows) throws JSONException, ParseException;
	List<Map<String, Object>> prepareGIPIWGrpItemsBeneficiaryForDelete(JSONArray delRows) throws JSONException;
	
	void saveBeneficiaries(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateBenNo(HttpServletRequest request) throws SQLException;
	/*added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)*/
	Map<String, Object> validateBenNo2(HttpServletRequest request) throws SQLException;
	/*END SR21720*/
}
