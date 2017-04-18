package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWAccidentItem;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;

public interface GIPIWAccidentItemDAO {

	List<GIPIWAccidentItem> getGipiWAccidentItem(Integer parId) throws SQLException;
	void saveGIPIParAccidentItem(Map<String, Object> params) throws SQLException;
	String saveGIPIParAccidentItemModal(Map<String, Object> params) throws SQLException;
	GIPIWAccidentItem getEndtGipiWItemAccidentDetails(Map<String, Object>params) throws SQLException;
	Map<String, Object> getEndtGipiWItemAccidentDetails2(Map<String, Object>params)throws SQLException;
	String preInsertAccident(Map<String, Object>params) throws SQLException;
	void saveEndtAccidentItemInfoPage(Map<String, Object> params) throws SQLException;
	GIPIWAccidentItem preInsertEndtAccident(Map<String, Object>params)throws SQLException;
	String checkUpdateGipiWPolbasValidity(Map<String, Object> params) throws SQLException;
	String checkCreateDistributionValidity(Integer parId) throws SQLException;
	String checkGiriDistfrpsExist(Integer parId) throws SQLException;
	void changeItemAccGroup(Integer parId) throws SQLException;
	public void insertGIPIWItemAcc(GIPIWAccidentItem itemAcc) throws SQLException;
	boolean saveAccidentItem(Map<String, Object> param) throws SQLException;
	
	String saveGIPIEndtAccidentItemModal(Map<String, Object> params) throws SQLException;
	public String saveGipiWAccidentGroupedItemsModal(Map<String, Object> params) throws SQLException;
	String checkRetrieveGroupedItems(Map<String, Object> params) throws SQLException;
	Map<String, Object> retrieveGroupedItems(Map<String, Object> params) throws SQLException;
	
	public List<GIPIWGroupedItems> retGrpItmsGipiWGroupedItems(Map<String, Object> params) throws SQLException;
	public List<GIPIWItmperlGrouped> retGrpItmsGipiWItmperlGrouped(Map<String, Object> params) throws SQLException;
	
	void insertRetrievedGroupedItems(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> gipis012NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIWAccidentItem(Map<String, Object> params) throws SQLException, JSONException;
	void gipis065NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveEndtACGroupedItemsModal(Map<String, Object> params) throws SQLException, JSONException;
	String gipis065CheckIfPerilExists(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis065InsertRecGrpWItem(Map<String, Object> params) throws SQLException;
	void saveAccidentGroupedItemsModalTG(Map<String, Object> params) throws SQLException, JSONException;
	void populateBenefits(Map<String, Object> params) throws SQLException;
}
