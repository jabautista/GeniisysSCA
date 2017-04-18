package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWCargoCarrierDAO;
import com.geniisys.gipi.entity.GIPIWCargoCarrier;
import com.geniisys.gipi.service.GIPIWCargoCarrierService;
import com.geniisys.gipi.util.DateFormatter;
import com.seer.framework.util.StringFormatter;

public class 
GIPIWCargoCarrierServiceImpl implements GIPIWCargoCarrierService{

	private GIPIWCargoCarrierDAO gipiWCargoCarrierDAO;
	
	public void setGipiWCargoCarrierDAO(GIPIWCargoCarrierDAO gipiWCargoCarrierDAO) {
		this.gipiWCargoCarrierDAO = gipiWCargoCarrierDAO;
	}

	public GIPIWCargoCarrierDAO getGipiWCargoCarrierDAO() {
		return gipiWCargoCarrierDAO;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCargoCarrier> getGipiWCargoCarrier(Integer parId)
			throws SQLException {
		//return (List<GIPIWCargoCarrier>) StringFormatter.escapeHTMLJavascriptInList(this.gipiWCargoCarrierDAO.getGipiWCargoCarrier(parId));
		return this.gipiWCargoCarrierDAO.getGipiWCargoCarrier(parId);	//Gzelle 05292015 SR4302
	}

	public List<GIPIWCargoCarrier> prepareGIPIWCargoCarrierForInsert(JSONArray jsonArray) throws JSONException, ParseException{
		List<GIPIWCargoCarrier> carriers = new ArrayList<GIPIWCargoCarrier>();
		GIPIWCargoCarrier carrier = null;
		JSONObject json = null;
		//DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for (int index=0; index<jsonArray.length(); index++){
			json = jsonArray.getJSONObject(index);
			carrier = new GIPIWCargoCarrier();
			carrier.setParId(json.isNull("parId") ? null : json.getString("parId"));
			carrier.setItemNo(json.isNull("itemNo") ? null : json.getString("itemNo"));
			carrier.setUserId(json.isNull("userId") ? null : json.getString("userId"));
			carrier.setVesselCd(json.isNull("vesselCd") ? null : json.getString("vesselCd"));
			carrier.setPlateNo(json.isNull("plateNo") ? null : json.getString("plateNo"));
			carrier.setMotorNo(json.isNull("motorNo") ? null : json.getString("motorNo"));
			carrier.setSerialNo(json.isNull("serialNo") ? null : json.getString("serialNo"));
			carrier.setVesselLimitOfLiab(json.isNull("vesselLimitOfLiab") ? null : new BigDecimal(json.getString("vesselLimitOfLiab").replaceAll(",", "")));
			carrier.setEtd(json.isNull("etd") ? null : (json.getString("etd").equals("") ? null : DateFormatter.formatDate(json.getString("etd"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			carrier.setEta(json.isNull("eta") ? null : (json.getString("eta").equals("") ? null : DateFormatter.formatDate(json.getString("eta"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			carrier.setOrigin(json.isNull("origin") ? null : StringFormatter.unescapeHTML(StringFormatter.unescapeHtmlJava(json.getString("origin"))));
			carrier.setDestn(json.isNull("destn") ? null : StringFormatter.unescapeHTML(StringFormatter.unescapeHtmlJava(json.getString("destn"))));
			carrier.setDeleteSw(json.isNull("deleteSw") ? null : json.getString("deleteSw"));
			carrier.setVoyLimit(json.isNull("voyLimit") ? null : StringFormatter.unescapeHTML(StringFormatter.unescapeHtmlJava(json.getString("voyLimit"))));			
			
			carriers.add(carrier);
		}
		
		return carriers; 
	}
	
	public List<Map<String, Object>> prepareGIPIWCargoCarrierForDelete(JSONArray jsonArray) throws JSONException, ParseException{
		List<Map<String, Object>> carriers = new ArrayList<Map<String, Object>>();
		Map<String, Object> carrier = null;
		JSONObject json = null;
	
		for (int index=0; index<jsonArray.length(); index++){
			json = jsonArray.getJSONObject(index);
			carrier = new HashMap<String, Object>();
			carrier.put("parId", json.isNull("parId") ? null : json.getString("parId"));
			carrier.put("itemNo", json.isNull("itemNo") ? null : json.getString("itemNo"));
			carrier.put("vesselCd", json.isNull("vesselCd") ? null : json.getString("vesselCd"));
			
			carriers.add(carrier);
		}
		
		return carriers; 
	}
}
