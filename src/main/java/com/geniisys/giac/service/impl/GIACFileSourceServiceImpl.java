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
import com.geniisys.giac.dao.GIACFileSourceDAO;
import com.geniisys.giac.entity.GIACFileSource;
import com.geniisys.giac.service.GIACFileSourceService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIACFileSourceServiceImpl implements GIACFileSourceService{

	private GIACFileSourceDAO giacFileSourceDAO;
	
	public void setGiacFileSourceDAO(GIACFileSourceDAO giacFileSourceDAO) {
		this.giacFileSourceDAO = giacFileSourceDAO;
	}

	public GIACFileSourceDAO getGiacFileSourceDAO() {
		return giacFileSourceDAO;
	}
	
	
	@Override
	public JSONObject getFileSourceRecords(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showFileSource");
		Map<String, Object> fileSourceTable = TableGridUtil.getTableGrid(request, params);
		JSONObject objFileSourceTable = new JSONObject(fileSourceTable);
		return objFileSourceTable;
	}

	@Override
	public String saveFileSource(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACFileSource.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIACFileSource.class));
		return this.getGiacFileSourceDAO().saveFileSource(allParams);
	}

	

}
