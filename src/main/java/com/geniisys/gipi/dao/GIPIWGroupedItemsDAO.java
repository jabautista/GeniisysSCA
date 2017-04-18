package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWGroupedItems;

public interface GIPIWGroupedItemsDAO {

	List<GIPIWGroupedItems> getGipiWGroupedItems(Integer parId) throws SQLException;
	List<GIPIWGroupedItems> getGipiWGroupedItems2(Integer parId,Integer itemNo) throws SQLException;
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
	void negateDelete(Map<String, Object> params) throws SQLException;
	void saveGroupedItems(Map<String, Object> params) throws SQLException;
	void insertRetrievedGrpItems(Map<String, Object> params) throws SQLException, JSONException;
	void copyBenefits(Map<String, Object> params) throws SQLException, JSONException;
	void postSaveGroupedItems(Map<String, Object> params) throws SQLException;
	Integer checkGroupedItems(Map<String, Object> params) throws SQLException;
	Integer validateNoOfPersons(Map<String, Object> params) throws SQLException;
	List<String> getCAGroupedItems(Map<String, Object> params) throws SQLException; //Deo [01.26.2017]: SR-23702
}
