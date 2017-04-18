package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACUserFunctionsDAO;
import com.geniisys.giac.entity.GIACUserFunctions;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.seer.framework.util.StringFormatter;

public class GIACUserFunctionsServiceImpl implements GIACUserFunctionsService {
	
	private GIACUserFunctionsDAO giacUserFunctionsDAO;
	
	private static Logger log = Logger.getLogger(GIACUserFunctionsServiceImpl.class);

	public void setGiacUserFunctionsDAO(GIACUserFunctionsDAO giacUserFunctionsDAO) {
		this.giacUserFunctionsDAO = giacUserFunctionsDAO;
	}

	public GIACUserFunctionsDAO getGiacUserFunctionsDAO() {
		return giacUserFunctionsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACUserFunctionsService#checkIfUserHasFunction(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String checkIfUserHasFunction(String functionCd, String moduleName,
			String userId) throws SQLException {
		log.info("checkIfUserHasFunction");
		String exists = this.getGiacUserFunctionsDAO().checkIfUserHasFunction(functionCd, moduleName, userId);
		
		if (exists == null) {
			exists = "N";
		}
		
		return exists;
	}

	@Override
	public String checkOverdueUser(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiacUserFunctionsDAO().checkOverdueUser(params);
	}

	@Override
	public String checkIfUserHasFunction3(Map<String, Object> params)
			throws SQLException {
		return getGiacUserFunctionsDAO().checkIfUserHasFunction3(params);
	}
	
	public String getScrnRepName(Integer moduleId) throws SQLException{
		return this.giacUserFunctionsDAO.getScrnRepName(moduleId);
	}
	
	@Override
	public JSONObject showGiacs315(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Integer moduleId = request.getParameter("moduleId") == null || request.getParameter("moduleId") == "" ? null : Integer.parseInt(request.getParameter("moduleId"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs315RecList");	
		params.put("moduleId",moduleId);
		params.put("functionCode", request.getParameter("functionCode"));
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
		
		if (moduleId != null){
			request.setAttribute("scrnRepName", this.getScrnRepName(moduleId));
		}
		
		return new JSONObject(recList);
	}

	public Integer getUserFunctionsSeq() throws SQLException{
		return this.giacUserFunctionsDAO.getUserFunctionsSeq();
	}
	
	@Override
	public void saveGiacs315(HttpServletRequest request, String userId)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", this.prepareUserFunctionForInsert(new JSONArray(request.getParameter("setRows")), userId));
		params.put("delRows", this.prepareUserFunctionForDelete(new JSONArray(request.getParameter("delRows")), userId));
		params.put("appUser", userId);
		this.giacUserFunctionsDAO.saveGiacs315(params);
	}
	
	public List<GIACUserFunctions> prepareUserFunctionForInsert(JSONArray rows, String userId) throws SQLException, JSONException, ParseException{
		GIACUserFunctions userFunctions = null;
		JSONObject json = null;
		List<GIACUserFunctions> items = new ArrayList<GIACUserFunctions>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			userFunctions = new GIACUserFunctions();
			
			userFunctions.setModuleId(json.isNull("moduleId") ? null : json.getInt("moduleId"));	
			userFunctions.setFunctionCode(json.isNull("functionCode") ? null : StringEscapeUtils.unescapeHtml(json.getString("functionCode")));
			userFunctions.setUserId(json.isNull("userId") ? null : StringEscapeUtils.unescapeHtml(json.getString("userId")));
			userFunctions.setValidTag(json.isNull("validTag") ? null : StringEscapeUtils.unescapeHtml(json.getString("validTag")));
			userFunctions.setValidityDt(json.isNull("validityDt") || json.getString("validityDt").equals("") ? null  : sdf.parse(StringEscapeUtils.unescapeHtml(json.getString("validityDt"))));
			userFunctions.setTerminationDt(json.isNull("terminationDt") || json.getString("terminationDt").equals("") ? null : sdf.parse(StringEscapeUtils.unescapeHtml(json.getString("terminationDt"))));
			userFunctions.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
			userFunctions.setTranUserId(userId);
			
			if (json.getString("recordStatus").equals("0")){	//new
				userFunctions.setUserFunctionId(this.getUserFunctionsSeq());
			}else{
				userFunctions.setUserFunctionId(json.isNull("userFunctionId") ? null : json.getInt("userFunctionId"));
			}
			
			items.add(userFunctions);
		}
		
		return items;
	}
	
	public List<GIACUserFunctions> prepareUserFunctionForDelete(JSONArray rows, String userId) throws SQLException, JSONException{
		GIACUserFunctions userFunctions = null;
		JSONObject json = null;
		List<GIACUserFunctions> items = new ArrayList<GIACUserFunctions>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			userFunctions = new GIACUserFunctions();
			
			userFunctions.setModuleId(json.isNull("moduleId") ? null : json.getInt("moduleId"));	
			userFunctions.setFunctionCode(json.isNull("functionCode") ? null : StringEscapeUtils.unescapeHtml(json.getString("functionCode")));
			userFunctions.setUserId(json.isNull("userId") ? null : StringEscapeUtils.unescapeHtml(json.getString("userId")));			
			userFunctions.setUserFunctionId(json.isNull("userFunctionId") ? null : json.getInt("userFunctionId"));
			
			items.add(userFunctions);
		}
		
		return items;
	}
	
	public Map<String, Object> checkUserFunctionValidity(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return this.giacUserFunctionsDAO.checkUserFunctionValidity(params);
	}
	
	/*@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		params.put("userId", request.getParameter("userId"));
		params.put("userFunctionId", request.getParameter("userFunctionId"));
		this.giacUserFunctionsDAO.valDeleteRec(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		params.put("userId", request.getParameter("userId"));
		params.put("userFunctionId", request.getParameter("userFunctionId"));
		this.giacUserFunctionsDAO.valAddRec(params);
	}*/

}
