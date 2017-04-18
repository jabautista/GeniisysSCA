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

import com.geniisys.gipi.dao.GIPIWBankScheduleDAO;
import com.geniisys.gipi.entity.GIPIWBankSchedule;
import com.geniisys.gipi.service.GIPIWBankScheduleService;
import com.seer.framework.util.StringFormatter;

public class GIPIWBankScheduleServiceImpl implements GIPIWBankScheduleService{

	private GIPIWBankScheduleDAO gipiWBankScheduleDAO;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWBankSchedule> getGIPIWBankScheduleList(Integer parId) throws SQLException {
		return (List<GIPIWBankSchedule>) StringFormatter.replaceQuotesInList(this.getGipiWBankScheduleDAO().getGIPIWBankScheduleList(parId));
	}

	public void setGipiWBankScheduleDAO(GIPIWBankScheduleDAO gipiWBankScheduleDAO) {
		this.gipiWBankScheduleDAO = gipiWBankScheduleDAO;
	}

	public GIPIWBankScheduleDAO getGipiWBankScheduleDAO() {
		return gipiWBankScheduleDAO;
	}

	@Override
	public boolean saveGIPIWBankScheduleChanges(String parameter)
			throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		
		List<GIPIWBankSchedule> bankSchedulesForInsert = this.prepareGIPIWBankScheduleForInsert(new JSONArray(objParameters.getString("setRows")));
		List<GIPIWBankSchedule> bankSchedulesForDelete = this.prepareGIPIWBankScheduleForDelete(new JSONArray(objParameters.getString("delRows")));
		params.put("bankSchedulesForInsert", bankSchedulesForInsert);
		params.put("bankSchedulesForDelete", bankSchedulesForDelete);
		this.gipiWBankScheduleDAO.saveGIPIWBankScheduleChanges(params);
		return true;
	}
	
	private List<GIPIWBankSchedule> prepareGIPIWBankScheduleForInsert(JSONArray setRows) 
		throws JSONException, ParseException {
		List<GIPIWBankSchedule> gipiWBankScheduleList = new ArrayList<GIPIWBankSchedule>();
		GIPIWBankSchedule bankSchedule = null;
		
		for (int i = 0; i < setRows.length(); i++) {
			bankSchedule = new GIPIWBankSchedule();
			
			bankSchedule.setParId(setRows.getJSONObject(i).getInt("parId"));
			bankSchedule.setBankItemNo(setRows.getJSONObject(i).getInt("bankItemNo"));
			bankSchedule.setBank(setRows.getJSONObject(i).isNull("bank") ? null : setRows.getJSONObject(i).getString("bank"));
			bankSchedule.setCashInTransit(setRows.getJSONObject(i).isNull("cashInTransit") ? null : ("".equals(setRows.getJSONObject(i).getString("cashInTransit").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("cashInTransit").replace(",", "")));
			bankSchedule.setCashInVault(setRows.getJSONObject(i).isNull("cashInVault") ? null : ("".equals(setRows.getJSONObject(i).getString("cashInVault").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("cashInVault").replace(",", "")));
			bankSchedule.setIncludeTag(setRows.getJSONObject(i).isNull("includeTag") ? null : setRows.getJSONObject(i).getString("includeTag"));
			bankSchedule.setBankAddress(setRows.getJSONObject(i).isNull("bankAddress") ? null : setRows.getJSONObject(i).getString("bankAddress"));
			bankSchedule.setRemarks(setRows.getJSONObject(i).isNull("remarks") ? null : setRows.getJSONObject(i).getString("remarks"));
			gipiWBankScheduleList.add(bankSchedule);
		}
		
		return gipiWBankScheduleList;
	}
	
	private List<GIPIWBankSchedule> prepareGIPIWBankScheduleForDelete(JSONArray delRows) 
		throws JSONException, ParseException {
		List<GIPIWBankSchedule> gipiWBankScheduleList = new ArrayList<GIPIWBankSchedule>();
		GIPIWBankSchedule bankSchedule = null;
		
		for (int i = 0; i < delRows.length(); i++) {
			bankSchedule = new GIPIWBankSchedule();
			System.out.println("service for delete parId: "+delRows.getJSONObject(i).getInt("parId"));
			bankSchedule.setParId(delRows.getJSONObject(i).getInt("parId"));
			bankSchedule.setBankItemNo(delRows.getJSONObject(i).getInt("bankItemNo"));
			gipiWBankScheduleList.add(bankSchedule);
		}
		return gipiWBankScheduleList;
	}

}
