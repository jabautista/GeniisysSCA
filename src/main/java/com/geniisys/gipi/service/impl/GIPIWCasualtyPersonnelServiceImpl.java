package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWCasualtyPersonnelDAO;
import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;
import com.geniisys.gipi.service.GIPIWCasualtyPersonnelService;
import com.seer.framework.util.StringFormatter;

public class GIPIWCasualtyPersonnelServiceImpl implements GIPIWCasualtyPersonnelService{

	private GIPIWCasualtyPersonnelDAO gipiWCasualtyPersonnelDAO;	
	
	public GIPIWCasualtyPersonnelDAO getGipiWCasualtyPersonnelDAO() {
		return gipiWCasualtyPersonnelDAO;
	}

	public void setGipiWCasualtyPersonnelDAO(
			GIPIWCasualtyPersonnelDAO gipiWCasualtyPersonnelDAO) {
		this.gipiWCasualtyPersonnelDAO = gipiWCasualtyPersonnelDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCasualtyPersonnel> getGipiWCasualtyPersonnel(Integer parId)
			throws SQLException {
		//return (List<GIPIWCasualtyPersonnel>) StringFormatter.escapeHTMLJavascriptInList(this.gipiWCasualtyPersonnelDAO.getGipiWCasualtyPersonnel(parId)); Gzelle 02262015
		//return (List<GIPIWCasualtyPersonnel>) StringFormatter.escapeHTMLInList4(this.gipiWCasualtyPersonnelDAO.getGipiWCasualtyPersonnel(parId));
		return this.gipiWCasualtyPersonnelDAO.getGipiWCasualtyPersonnel(parId); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public Map<String, Object> getCasualtyPersonnelDetails(
			HttpServletRequest request) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("personnelNo", Integer.parseInt(request.getParameter("personnelNo")));
		
		return this.getGipiWCasualtyPersonnelDAO().getCasualtyPersonnelDetails(params);
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWCasualtyPersonnelForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delPersonnelList = new ArrayList<Map<String, Object>>();
		Map<String, Object> delPersonnelMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			delPersonnelMap = new HashMap<String, Object>();
			delPersonnelMap.put("parId", delRows.getJSONObject(i).isNull("parId") ? null : delRows.getJSONObject(i).getInt("parId"));
			delPersonnelMap.put("itemNo", delRows.getJSONObject(i).isNull("itemNo") ? null : delRows.getJSONObject(i).getInt("itemNo"));
			delPersonnelMap.put("personnelNo", delRows.getJSONObject(i).isNull("personnelNo") ? null : delRows.getJSONObject(i).getString("personnelNo"));
			delPersonnelList.add(delPersonnelMap);
			delPersonnelMap = null;
		}
		
		return delPersonnelList;
	}	

	@Override
	public List<GIPIWCasualtyPersonnel> prepareGIPIWCasualtyPersonnelForInsertUpdate(
			JSONArray setRows) throws JSONException {
		List<GIPIWCasualtyPersonnel> personnelList = new ArrayList<GIPIWCasualtyPersonnel>();
		GIPIWCasualtyPersonnel cp = null;
		JSONObject objCasPer = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			cp = new GIPIWCasualtyPersonnel();
			objCasPer = setRows.getJSONObject(i);
			
			cp.setParId(objCasPer.isNull("parId") ? null : objCasPer.getString("parId"));
			cp.setItemNo(objCasPer.isNull("itemNo") ? null : objCasPer.getString("itemNo"));
			cp.setPersonnelNo(objCasPer.isNull("personnelNo") ? null : objCasPer.getString("personnelNo"));
			cp.setPersonnelName(objCasPer.isNull("personnelName") ? null : StringEscapeUtils.unescapeHtml(objCasPer.getString("personnelName")));
			cp.setIncludeTag(objCasPer.isNull("includeTag") ? null : objCasPer.getString("includeTag"));
			cp.setCapacityCd(objCasPer.isNull("capacityCd") ? null : objCasPer.getString("capacityCd"));
			cp.setAmountCovered(objCasPer.isNull("amountCovered") ? null : new BigDecimal(objCasPer.getString("amountCovered").replaceAll(",", "")));
			cp.setRemarks(objCasPer.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(objCasPer.getString("remarks")));
			cp.setDeleteSw(objCasPer.isNull("deleteSw") ? null : objCasPer.getString("deleteSw"));
			
			personnelList.add(cp);
			cp = null;
		}
		
		return personnelList;
	}

}
