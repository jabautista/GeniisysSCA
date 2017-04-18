package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIGroupedItems;

public interface GIPIGroupedItemsDAO {
	List<GIPIGroupedItems> getGIPIGroupedItemsEndt(Map<String, Object> params) throws SQLException;
	String checkIfGroupItemIsZeroOutOrNegated(Map<String, Object> params) throws SQLException, JSONException;
	String checkIfPrincipalEnrollee(Map<String, Object> params) throws SQLException;
	
	List<GIPIGroupedItems> getCasualtyGroupedItems(HashMap<String,Object> params) throws SQLException;
	
	List<GIPIGroupedItems> getAccidentGroupedItems(HashMap<String,Object> params) throws SQLException;
}
