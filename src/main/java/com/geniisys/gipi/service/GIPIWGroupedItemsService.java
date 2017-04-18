package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWGroupedItems;

public interface GIPIWGroupedItemsService {

	List<GIPIWGroupedItems> getGipiWGroupedItems(Integer parId) throws SQLException;
	List<GIPIWGroupedItems> getGipiWGroupedItems2(Integer parId,Integer itemNo) throws SQLException;
	List<GIPIWGroupedItems> prepareGIPIWGroupedItemsForInsertUpdate(JSONArray setRows) throws JSONException, ParseException;
	List<Map<String, Object>> prepareGIPIWGroupedItemsForDelete(JSONArray delRows) throws JSONException;
	void renumberGroupedItems(Map<String, Object> params) throws SQLException;
	List<GIPIWGroupedItems> getGIPIWGroupedItems(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> validateGroupedItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGroupedItemTitle(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePrincipalCd(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGrpFromDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGrpToDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateAmtCovered(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getGroupedItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDeleteSwVars(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> setGroupedItemsVars(Map<String, Object> params) throws SQLException;
	String validateRetrieveGrpItems(Map<String, Object> params) throws SQLException;
	String preNegateDelete(Map<String, Object> params) throws SQLException;
	String checkBackEndt(Map<String, Object> params) throws SQLException;
	void negateDelete(HttpServletRequest request, String userId) throws SQLException;
	void saveGroupedItems(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void insertRetrievedGrpItems(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void copyBenefits(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void postSaveGroupedItems(HttpServletRequest request, String userId) throws SQLException;
	Integer checkGroupedItems(Map<String, Object> params) throws SQLException;
	Integer validateNoOfPersons(HttpServletRequest request) throws SQLException;
	Map<String, Object> getCAGroupedItems(HttpServletRequest request) throws SQLException; //Deo [01.26.2017]: SR-23702
}
