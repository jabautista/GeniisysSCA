package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISEventModule;
import com.geniisys.common.entity.GIISIndustry;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISEventModuleDAO;
import com.geniisys.giis.service.GIISEventModuleService;

public class GIISEventModuleServiceImpl implements GIISEventModuleService{

private GIISEventModuleDAO giisEventModuleDAO;
	
	public GIISEventModuleDAO getGissEventModuleDAO() {
		return giisEventModuleDAO;
	}

	public void setGiisEventModuleDAO(GIISEventModuleDAO giisEventModuleDAO) {
		this.giisEventModuleDAO = giisEventModuleDAO;
	}

	@Override
	public JSONObject getGiiss168EventModules(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss168EventModules");
		params.put("eventCd", request.getParameter("eventCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(map);
	}

	@Override
	public String getGiiss168SelectedModules(HttpServletRequest request)
			throws SQLException {
		return giisEventModuleDAO.getGiiss168SelectedModules(request.getParameter("eventCd"));
	}

	@Override
	public void saveGiiss168(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss168");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRowsEventModules", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRowsEventModules")), userId, GIISEventModule.class));
		//params.put("delRowsEventModules", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsEventModules")), userId, GIISEventModule.class));
		params.put("appUser", userId);
		this.giisEventModuleDAO.saveGiiss168(params);
	}

	@Override
	public JSONObject getGiiss168PassingUser(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss168PassingUser");
		params.put("eventModCd", request.getParameter("eventModCd"));
		params.put("pageSize", 3);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(map);
	}

	@Override
	public JSONObject getGiiss168ReceivingUser(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss168ReceivingUser");
		params.put("eventModCd", request.getParameter("eventModCd"));
		params.put("passingUserid", request.getParameter("passingUserid"));
		params.put("pageSize", 3);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(map);
	}

	@Override
	public String getGiiss168SelectedPassingUsers(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss168SelectedPassingUsers");
		params.put("eventModCd", request.getParameter("eventModCd"));
		params.put("passingUserid", request.getParameter("passingUserid"));
		
		System.out.println("getGiiss168SelectedPassingUsers");
		System.out.println(params);
		return giisEventModuleDAO.getGiiss168SelectedPassingUsers(params);
	}

	@Override
	public String getGiiss168SelectedReceivingUsers(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss168SelectedReceivingUsers");
		params.put("eventModCd", request.getParameter("eventModCd"));
		params.put("passingUserid", request.getParameter("passingUserid"));
		return giisEventModuleDAO.getGiiss168SelectedReceivingUsers(params);
	}

	@Override
	public void saveGiiss168UserList(HttpServletRequest request, String userId)
			throws SQLException, JSONException, Exception {
		System.out.println("Service - saveGiiss168UserList");
		JSONObject jsonObject = new JSONObject(request.getParameter("objParams"));
		JSONArray passingUserArr = new JSONArray(jsonObject.getString("setRowsPassingUser"));
		JSONArray receivingUserArr = new JSONArray(jsonObject.getString("setRowsReceivingUser"));
		JSONArray delReceivingUserArr = new JSONArray(jsonObject.getString("delRowsReceivingUser"));
		
		List<Map<String, Object>> passingUserList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0; i < passingUserArr.length(); i++){
			
			JSONObject rec = passingUserArr.getJSONObject(i);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("eventModCd", rec.getString("eventModCd"));
			map.put("userId", userId);
			map.put("passingUserid", rec.getString("passingUserid"));			
			passingUserList.add(map);
		}
		
		List<Map<String, Object>> receivingUserList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0; i < receivingUserArr.length(); i++){
			
			JSONObject rec = receivingUserArr.getJSONObject(i);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("eventUserMod", rec.getString("eventUserMod"));
			map.put("eventModCd", rec.getString("eventModCd"));
			map.put("userid", rec.getString("userid"));
			map.put("userId", userId);
			map.put("passingUserid", rec.getString("passingUserid"));
			receivingUserList.add(map);
		}
		
		List<Map<String, Object>> delReceivingUserList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0; i < delReceivingUserArr.length(); i++){
			
			JSONObject rec = delReceivingUserArr.getJSONObject(i);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("eventUserMod", rec.getString("eventUserMod"));			
			delReceivingUserList.add(map);
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("passingUserList", passingUserList);
		params.put("receivingUserList", receivingUserList);
		params.put("delReceivingUserList", delReceivingUserList);
		
		giisEventModuleDAO.saveGiiss168UserList(params);
	}

	@Override
	public void valDelGiiss168PassingUsers(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("eventModCd", request.getParameter("eventModCd"));
		params.put("passingUserid", request.getParameter("passingUserid"));
		this.giisEventModuleDAO.valDelGiiss168PassingUsers(params);
		
	}
	
}
