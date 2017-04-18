package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPICoInsurerDAO;
import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.geniisys.gipi.service.GIPICoInsurerService;
import com.seer.framework.util.StringFormatter;

public class GIPICoInsurerServiceImpl implements GIPICoInsurerService{
	
	private GIPICoInsurerDAO gipiCoInsurerDAO;
		
	public GIPICoInsurerDAO getGipiCoInsurerDAO() {
		return gipiCoInsurerDAO;
	}

	public void setGipiCoInsurerDAO(GIPICoInsurerDAO gipiCoInsurerDAO) {
		this.gipiCoInsurerDAO = gipiCoInsurerDAO;
	}

	@Override
	public List<GIPICoInsurer> getCoInsurerDetails(int parId)
			throws SQLException {
		return this.getGipiCoInsurerDAO().getCoInsurerDetails(parId);
	}

	@Override
	public GIPIMainCoIns getCoInsurerAmts(int parId) throws SQLException {
		return this.getGipiCoInsurerDAO().getCoInsurerAmts(parId);
	}

	@Override
	public Map<String, Object> getCoInsurerSharePct(Integer parId)
			throws SQLException {
		return this.getGipiCoInsurerDAO().getCoInsurerSharePct(parId);
	}

	@Override
	public Map<String, Object> getCoInsurerDefaultParams(Map<String, Object> params)
			throws SQLException {
		return this.getGipiCoInsurerDAO().getCoInsurerDefaultParams(params);
	}

	@Override
	public List<GIPICoInsurer> getDefaultCoInsurers(int policyId)
			throws SQLException {
		return this.getGipiCoInsurerDAO().getDefaultCoInsurers(policyId);
	}

	@Override
	public Map<String, Object> saveEnteredCoInsurers(String param, String userId) throws SQLException,
			JSONException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", objParams.getInt("parId"));
		params.put("premAmt", objParams.isNull("totalPremAmt") ? null : new BigDecimal(objParams.getString("totalPremAmt")));
		params.put("tsiAmt", objParams.isNull("totalTsiAmt") ? null : new BigDecimal(objParams.getString("totalTsiAmt")));
		params.put("userId", userId);
		params.put("setRows", this.prepareCoInsurersForInsert(new JSONArray(objParams.getString("setRows")), userId));
		params.put("delRows", this.prepareCoInsurerForDelete(new JSONArray(objParams.getString("delRows"))));
		
		return this.getGipiCoInsurerDAO().saveEnteredcoInsurer(params);
	}
	
	private List<GIPICoInsurer> prepareCoInsurersForInsert(JSONArray setRows, String userId) throws JSONException {
		List<GIPICoInsurer> coInsurer = new ArrayList<GIPICoInsurer>();
		GIPICoInsurer coRiItem = null;
		JSONObject coRiObj = null;
		
		for(int i=0, length = setRows.length(); i<length; i++) {
			coRiItem = new GIPICoInsurer();
			coRiObj = setRows.getJSONObject(i);
			
			if(coRiObj != null) {
				coRiItem.setParId(coRiObj.isNull("parId") ? null : coRiObj.getInt("parId"));
				coRiItem.setCoRiCd(coRiObj.isNull("coRiCd") ? null : coRiObj.getInt("coRiCd"));
				coRiItem.setCoRiPremAmt(coRiObj.isNull("coRiPremAmt") ? null : new BigDecimal(coRiObj.getString("coRiPremAmt")));
				coRiItem.setCoRiTsiAmt(coRiObj.isNull("coRiTsiAmt") ? null : new BigDecimal(coRiObj.getString("coRiTsiAmt")));
				coRiItem.setCoRiShrPct(coRiObj.isNull("coRiShrPct") ? null : new BigDecimal(coRiObj.getString("coRiShrPct")));
				coRiItem.setUserId(userId);
				
				coInsurer.add(coRiItem);
				coRiItem = null;
			}
		}
		return coInsurer;
	}
	
	private List<Map<String, Object>> prepareCoInsurerForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delCoInsurers = new ArrayList<Map<String,Object>>();
		Map<String, Object> delCoRiMap = null;
		
		for(int i=0, length=delRows.length(); i<length; i++) {
			delCoRiMap = new HashMap<String, Object>();
			delCoRiMap.put("parId", delRows.getJSONObject(i).isNull("parId") ? null : delRows.getJSONObject(i).getInt("parId"));
			delCoRiMap.put("coRiCd", delRows.getJSONObject(i).isNull("coRiCd") ? null : delRows.getJSONObject(i).getInt("coRiCd"));
			
			delCoInsurers.add(delCoRiMap);
			delCoRiMap = null;
		}
		
		return delCoInsurers;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPICoInsurerService#getCoInsurers(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCoInsurers(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		//List<HashMap<String, Object>> invoiceList = this.getGipiInvoiceDAO().getPolicyInvoice(params);
		List<GIPICoInsurer> coInsurerList = this.getGipiCoInsurerDAO().getCoInsurers(params);
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(coInsurerList)));
		grid.setNoOfPages(coInsurerList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public String checkCoInsurerAccess(Integer parId) throws SQLException {
		return this.getGipiCoInsurerDAO().checkCoInsurerAccess(parId);
	}

	@Override
	public void processDefaultEndtCoIns(Map<String,Object> params) throws SQLException {
		this.getGipiCoInsurerDAO().processDefaultEndtCoIns(params);
	}
}
