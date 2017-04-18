package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWAccidentItem;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;

public interface GIPIWAccidentItemService {

	GIPIWAccidentItem getEndtGipiWAccidentItemDetails(Map<String, Object> params) throws SQLException;
	List<GIPIWAccidentItem> getGipiWAccidentItem(Integer parId) throws SQLException;
	void saveGIPIParAccidentItem(Map<String, Object> params) throws SQLException;
	String saveGIPIParAccidentItemModal(Map<String, Object> params) throws SQLException;
	Map<String, Object> getEndtGipiWAccidentItemDetails2(Map<String, Object>params) throws SQLException;
	void saveEndtAccidentItemInfoPage(Map<String, Object> params) throws SQLException, JSONException;
	String preInsertAccident(Map<String, Object>params) throws SQLException;
	GIPIWAccidentItem preInsertEndtAccident(Map<String, Object>params) throws SQLException;
	String checkUpdateGipiWPolbasValidity(Map<String, Object> params) throws SQLException;
	String checkCreateDistributionValidity(Integer parId) throws SQLException;
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException;
	void changeItemAccGroup(Integer parId) throws SQLException;
	
	String saveGIPIEndtAccidentItemModal(Map<String, Object> params) throws SQLException;
	public String saveGipiWAccidentGroupedItemsModal(String params) throws SQLException, JSONException, ParseException;
	String checkRetrieveGroupedItems(Map<String, Object> params) throws SQLException;
	Map<String, Object> retrieveGroupedItems(Map<String, Object> params) throws SQLException, JSONException, ParseException ;
	void insertRetrievedGroupedItems(Map<String, Object> params) throws SQLException;
	
	public List<GIPIWGroupedItems> retGrpItmsGipiWGroupedItems(Map<String, Object> params) throws SQLException;
	public List<GIPIWItmperlGrouped> retGrpItmsGipiWItmperlGrouped(Map<String, Object> params) throws SQLException;

	boolean saveAccidentItem(Map<String, Object> param) throws SQLException;
	
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWAccidentItem(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	Map<String, Object> showACGroupedItems(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> gipis065NewFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void showEndtACGroupedItems(Map<String, Object> params) throws SQLException, JSONException;
	void saveEndtACGroupedItemsModal(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	String gipis065CheckIfPerilExists(Map<String, Object> params) throws SQLException;
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> showACGroupedItemsTG(Map<String, Object> params) throws SQLException, JSONException;
	void saveAccidentGroupedItemsModalTG(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	Map<String, Object> showPopulateBenefits(Map<String, Object> params) throws SQLException, JSONException;
	void populateBenefits(Map<String, Object> params) throws SQLException, JSONException, ParseException;
}
