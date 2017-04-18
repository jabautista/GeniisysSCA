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

import com.geniisys.gipi.dao.GIPIWItmperlBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.geniisys.gipi.service.GIPIWItmperlBeneficiaryService;
import com.seer.framework.util.StringFormatter;

public class GIPIWItmperlBeneficiaryServiceImpl implements GIPIWItmperlBeneficiaryService{

	private GIPIWItmperlBeneficiaryDAO gipiWItmperlBeneficiaryDAO;

	public GIPIWItmperlBeneficiaryDAO getGipiWItmperlBeneficiaryDAO() {
		return gipiWItmperlBeneficiaryDAO;
	}

	public void setGipiWItmperlBeneficiaryDAO(
			GIPIWItmperlBeneficiaryDAO gipiWItmperlBeneficiaryDAO) {
		this.gipiWItmperlBeneficiaryDAO = gipiWItmperlBeneficiaryDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary(
			Integer parId, Integer itemNo) throws SQLException {
		return (List<GIPIWItmperlBeneficiary>) StringFormatter.replaceQuotesInList(this.gipiWItmperlBeneficiaryDAO.getGipiWItmperlBeneficiary(parId, itemNo));
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary2(
			Integer parId) throws SQLException {
		return (List<GIPIWItmperlBeneficiary>) StringFormatter.replaceQuotesInList(this.gipiWItmperlBeneficiaryDAO.getGipiWItmperlBeneficiary2(parId));
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWItmperlBeneficiaryForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delList = new ArrayList<Map<String, Object>>();
		JSONObject objDelBen = null;
		Map<String, Object> delMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			delMap = new HashMap<String, Object>();
			objDelBen = delRows.getJSONObject(i);
			
			delMap.put("parId", objDelBen.isNull("parId") ? null : objDelBen.getInt("parId"));
			delMap.put("itemNo", objDelBen.isNull("itemNo") ? null : objDelBen.getInt("itemNo"));
			delMap.put("groupedItemNo", objDelBen.isNull("groupedItemNo") ? null : objDelBen.getInt("groupedItemNo"));
			delMap.put("beneficiaryNo", objDelBen.isNull("beneficiaryNo") ? null : objDelBen.getInt("beneficiaryNo"));
			delMap.put("perilCd", objDelBen.isNull("perilCd") ? null : objDelBen.getInt("perilCd"));
			
			delList.add(delMap);
			delMap = null;
		}		
		
		return delList;
	}

	@Override
	public List<GIPIWItmperlBeneficiary> prepareGIPIWItmperlBeneficiaryForInsertUpdate(
			JSONArray setRows) throws JSONException {
		List<GIPIWItmperlBeneficiary> beneficiaryList = new ArrayList<GIPIWItmperlBeneficiary>();
		GIPIWItmperlBeneficiary beneficiary = null;
		JSONObject objBeneficiary = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			beneficiary = new GIPIWItmperlBeneficiary();
			objBeneficiary = setRows.getJSONObject(i);
			System.out.println("Prem Rt: " + objBeneficiary.getString("premRt"));
			beneficiary.setParId(objBeneficiary.isNull("parId") ? null : objBeneficiary.getInt("parId"));
			beneficiary.setItemNo(objBeneficiary.isNull("itemNo") ? null : objBeneficiary.getInt("itemNo"));
			beneficiary.setGroupedItemNo(objBeneficiary.isNull("groupedItemNo") ? null : objBeneficiary.getString("groupedItemNo"));
			beneficiary.setBeneficiaryNo(objBeneficiary.isNull("beneficiaryNo") ? null : objBeneficiary.getString("beneficiaryNo"));
			beneficiary.setLineCd(objBeneficiary.isNull("lineCd") ? null : objBeneficiary.getString("lineCd"));
			beneficiary.setPerilCd(objBeneficiary.isNull("perilCd") ? null : objBeneficiary.getString("perilCd"));
			beneficiary.setRecFlag(objBeneficiary.isNull("recFlag") ? null : objBeneficiary.getString("recFlag"));
			beneficiary.setPremRt(objBeneficiary.isNull("premRt") ? null : objBeneficiary.getString("premRt").equals("")? null : new BigDecimal(objBeneficiary.getString("premRt").replaceAll(",", "")));
			beneficiary.setTsiAmt(objBeneficiary.isNull("tsiAmt") ? null : objBeneficiary.getString("tsiAmt").equals("") ? null : new BigDecimal(objBeneficiary.getString("tsiAmt").replaceAll(",", "")));
			beneficiary.setPremAmt(objBeneficiary.isNull("premAmt") ? null : objBeneficiary.getString("premAmt").equals("") ? null : new BigDecimal(objBeneficiary.getString("premAmt").replaceAll(",", "")));
			beneficiary.setAnnTsiAmt(objBeneficiary.isNull("annTsiAmt") ? null : objBeneficiary.getString("annTsiAmt").equals("") ? null : new BigDecimal(objBeneficiary.getString("annTsiAmt").replaceAll(",", "")));
			beneficiary.setAnnPremAmt(objBeneficiary.isNull("annPremAmt") ? null : objBeneficiary.getString("annPremAmt").equals("") ? null : new BigDecimal(objBeneficiary.getString("annPremAmt").replaceAll(",", "")));
			
			beneficiaryList.add(beneficiary);
			beneficiary = null;
		}
		
		return beneficiaryList;
	}	
}