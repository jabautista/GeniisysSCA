package com.geniisys.gipi.pack.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.pack.dao.GIPIWPackageInvTaxDAO;
import com.geniisys.gipi.pack.service.GIPIWPackageInvTaxService;

public class GIPIWPackageInvTaxServiceImpl implements GIPIWPackageInvTaxService{
	private GIPIWPackageInvTaxDAO gipiWPackageInvTaxDAO;	

	public GIPIWPackageInvTaxDAO getGipiWPackageInvTaxDAO() {
		return gipiWPackageInvTaxDAO;
	}

	public void setGipiWPackageInvTaxDAO(GIPIWPackageInvTaxDAO gipiWPackageInvTaxDAO) {
		this.gipiWPackageInvTaxDAO = gipiWPackageInvTaxDAO;
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWPackageInvTaxForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> wpackageInvTaxes = new ArrayList<Map<String, Object>>();
		Map<String, Object> wpackageInvTaxMap = null;
		JSONObject objWPackageInvTax = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			wpackageInvTaxMap = new HashMap<String, Object>();
			objWPackageInvTax = delRows.getJSONObject(i);
			
			wpackageInvTaxMap.put("parId", objWPackageInvTax.isNull("parId") ? null : objWPackageInvTax.getInt("parId"));
			wpackageInvTaxMap.put("itemGrp", objWPackageInvTax.isNull("itemGrp") ? null : objWPackageInvTax.getInt("itemGrp"));
			wpackageInvTaxMap.put("lineCd", objWPackageInvTax.isNull("lineCd") ? null : objWPackageInvTax.getString("lineCd"));
			
			wpackageInvTaxes.add(wpackageInvTaxMap);
			wpackageInvTaxMap = null;
		}
		
		return wpackageInvTaxes;
	}

}
