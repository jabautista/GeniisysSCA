package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACFunctionDAO;
import com.geniisys.giac.entity.GIACFunction;
import com.geniisys.giac.entity.GIACFunctionColumns;
import com.geniisys.giac.entity.GIACFunctionDisplay;
import com.geniisys.giac.service.GIACFunctionService;
import com.seer.framework.util.StringFormatter;

public class GIACFunctionServiceImpl implements GIACFunctionService {

	private GIACFunctionDAO giacFunctionDAO;
	
	@Override
	public void getFunctionName(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		
		request.setAttribute("functionName", this.giacFunctionDAO.getFunctionName(params));
	}

	public void setGiacFunctionDAO(GIACFunctionDAO giacFunctionDAO) {
		this.giacFunctionDAO = giacFunctionDAO;
	}

	public GIACFunctionDAO getGiacFunctionDAO() {
		return giacFunctionDAO;
	}
	
	@Override
	public JSONObject showGiacs314(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs314RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("functionCode", request.getParameter("functionCode"));
			return this.giacFunctionDAO.valDeleteRec(params);
		} else {
			return null;
		}
	}

	@Override
	public void saveGiacs314(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACFunction.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACFunction.class));
		params.put("appUser", userId);
		this.giacFunctionDAO.saveGiacs314(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("functionCode", request.getParameter("functionCode"));
			this.giacFunctionDAO.valAddRec(params);
		}
	}
	
	@Override
	public Map<String, Object> validateGiacs314Module(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleName", request.getParameter("moduleName"));
		return this.giacFunctionDAO.validateGiacs314Module(params);
	}
	
	public JSONObject showFunctionColumn(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGiacs314FunctionColumn");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public Map<String, Object> validateGiacs314Table(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tableName", request.getParameter("tableName"));
		return this.giacFunctionDAO.validateGiacs314Table(params);
	}
	
	@Override
	public Map<String, Object> validateGiacs314Column(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tableName", request.getParameter("tableName"));
		params.put("columnName", request.getParameter("columnName"));
		return this.giacFunctionDAO.validateGiacs314Column(params);
	}
	
	@Override
	public void saveFunctionColumn(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACFunctionColumns.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACFunctionColumns.class));
		params.put("appUser", userId);
		this.giacFunctionDAO.saveFunctionColumn(params);
	}

	@Override
	public void valAddFunctionColumn(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("functionCd", request.getParameter("functionCd"));
			params.put("tableName", request.getParameter("tableName"));
			params.put("columnName", request.getParameter("columnName"));
			this.giacFunctionDAO.valAddFunctionColumn(params);
		}
	}
	
	public JSONObject showFunctionDisplay(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGiacs314FunctionDisplay");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public Map<String, Object> validateGiacs314Display(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("displayColName", request.getParameter("displayColName"));
		return this.giacFunctionDAO.validateGiacs314Display(params);
	}
	
	@Override
	public void saveColumnDisplay(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACFunctionDisplay.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACFunctionDisplay.class));
		params.put("appUser", userId);
		this.giacFunctionDAO.saveColumnDisplay(params);
	}

	@Override
	public void valAddColumnDisplay(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("functionCd", request.getParameter("functionCd"));
			params.put("displayColId", request.getParameter("displayColId"));
			this.giacFunctionDAO.valAddColumnDisplay(params);
		}
	}

	@Override
	public String checkFuncExists(HttpServletRequest request) throws SQLException { //Added by Jerome Bautista 05.28.2015 SR 4225
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("funcCode"));
		return this.giacFunctionDAO.checkFuncExists(params);
	}
}
