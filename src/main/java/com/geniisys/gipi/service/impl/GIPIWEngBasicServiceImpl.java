package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWEngBasicDAO;
import com.geniisys.gipi.entity.GIPIWPrincipal;
import com.geniisys.gipi.entity.GIPIWEngBasic;
import com.geniisys.gipi.service.GIPIWEngBasicService;
import com.seer.framework.util.StringFormatter;

public class GIPIWEngBasicServiceImpl implements GIPIWEngBasicService{
	
	private GIPIWEngBasicDAO gipiWEngBasicDAO;
	
	public GIPIWEngBasicDAO getGipiWEngBasicDAO() {
		return gipiWEngBasicDAO;
	}

	public void setGipiWEngBasicDAO(GIPIWEngBasicDAO gipiWEngBasicDAO) {
		this.gipiWEngBasicDAO = gipiWEngBasicDAO;
	}

	@Override
	public GIPIWEngBasic getWEngBasicInfo(int parId) throws SQLException {
		//return (GIPIWEngBasic) StringFormatter.replaceQuotesInObject(gipiWEngBasicDAO.getWEngBasicInfo(parId)); replaced by reymon 03052013
		return (GIPIWEngBasic) gipiWEngBasicDAO.getWEngBasicInfo(parId);
	}

	/*@Override
	public void setWEngBasicInfo(GIPIWEngBasic enInfo) throws SQLException {
		this.gipiWEngBasicDAO.setWEngBasicInfo(enInfo);
	}*/
	@Override
	public void setWEngBasicInfo(String enInfo, String subline) throws SQLException, JSONException, ParseException {
		GIPIWEngBasic enBasic = new GIPIWEngBasic();
		JSONObject objParam = new JSONObject(enInfo);
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
		enBasic.setParId(objParam.isNull("parId") ? null : Integer.parseInt(objParam.getString("parId")));
		enBasic.setEnggBasicInfoNum(1);
		enBasic.setProjTitle(objParam.isNull("projTitle") ? null : StringEscapeUtils.unescapeHtml(objParam.getString("projTitle")));
		enBasic.setSiteLocation(objParam.isNull("siteLocation") ? null : StringEscapeUtils.unescapeHtml(objParam.getString("siteLocation")));
		if("CONTRACTOR_ALL_RISK".equals(subline) || "CONTRACTORS_ALL_RISK".equals(subline)) { // added by steven base on RSIC
			enBasic.setConsStartDate((objParam.getString("consStartDate")).equals("") ? null : df.parse(objParam.getString("consStartDate")));
			enBasic.setConsEndDate((objParam.getString("consEndDate")).equals("") ? null : df.parse(objParam.getString("consEndDate")));
			enBasic.setMaintStartDate((objParam.getString("maintStartDate")).equals("") ? null : df.parse(objParam.getString("maintStartDate")));
			enBasic.setMaintEndDate((objParam.getString("maintEndDate")).equals("") ? null : df.parse(objParam.getString("maintEndDate")));
		} else if (/*"EAR".equals(subline)*/"ERECTION_ALL_RISK".equals(subline)) {	// changes based on ucpb
			enBasic.setWeeksTest(objParam.isNull("weeksTest") ? null : objParam.getString("weeksTest"));
			System.out.println("Test weeks - "+enBasic.getWeeksTest());
		} else if ("MACHINERY_LOSS_OF_PROFIT".equals(subline)) {
			enBasic.setMbiPolicyNo(objParam.isNull("mbiPolNo") ? null : StringEscapeUtils.unescapeHtml(objParam.getString("mbiPolNo")));
			enBasic.setTimeExcess(objParam.isNull("timeExcess") ? null : objParam.getString("timeExcess"));
		}
		
		System.out.println("service impl: " + enBasic.getParId() + " - " + enBasic.getProjTitle() + " - " + enBasic.getMaintEndDate());
		this.gipiWEngBasicDAO.setWEngBasicInfo(enBasic);
	}

	@Override
	public List<GIPIWPrincipal> getENPrincipals(int parId, String pType)
			throws SQLException {
		return this.gipiWEngBasicDAO.getENPrincipals(parId, pType);
	}

	@Override
	public void saveENPrincipals(String principals, int parId)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(principals);
		Map<String, Object> prnParams = new HashMap<String, Object>();
		prnParams.put("enPrincipals", objParams.isNull("savedPrincipals") ? null : 
			this.prepareWPrincipals(new JSONArray(objParams.getString("savedPrincipals")), parId));
		prnParams.put("delPrincipals", objParams.isNull("delPrincipals") ? null : 
			this.prepareWPrincipals(new JSONArray(objParams.getString("delPrincipals")), parId));
		
		this.gipiWEngBasicDAO.saveENPrincipals(prnParams, parId);
	}
	
	public List<GIPIWPrincipal> prepareWPrincipals(JSONArray setRows, int parId) throws JSONException, ParseException {
		GIPIWPrincipal prn = null;
		JSONObject json = null;
		List<GIPIWPrincipal> setPrn = new ArrayList<GIPIWPrincipal>();
		for(int i=0; i<setRows.length(); i++) {
			json = setRows.getJSONObject(i);
			prn = new GIPIWPrincipal();
			if(!(json.isNull("principalCd"))) {
				prn.setParId(parId);
				prn.setPrincipalCd(json.isNull("principalCd") ? null : json.getInt("principalCd"));
				//prn.setEnBasicInfoNum(json.isNull("enBasicInfoNum") ? null : json.getInt("enBasicInfoNum"));
				//prn.setSubconSW(json.isNull("subconSW") ? null : json.getString("subconSW"));
				prn.setEnBasicInfoNum(1);
				prn.setSubconSW(json.isNull("subconSW") ? "N" : json.getString("subconSW"));
				setPrn.add(prn);
			}
		}
		return setPrn;
	}
}
