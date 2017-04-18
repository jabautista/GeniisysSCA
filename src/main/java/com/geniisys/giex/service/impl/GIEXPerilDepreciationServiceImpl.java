package com.geniisys.giex.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.dao.GIEXPerilDepreciationDAO;
import com.geniisys.giex.entity.GIEXLine;
import com.geniisys.giex.entity.GIEXPerilDepreciation;
import com.geniisys.giex.service.GIEXPerilDepreciationService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIEXPerilDepreciationServiceImpl implements GIEXPerilDepreciationService{

	private GIEXPerilDepreciationDAO giexPerilDepreciationDAO;
	
	public GIEXPerilDepreciationDAO getGiexPerilDepreciationDAO() {
		return giexPerilDepreciationDAO;
	}

	public void setGiexPerilDepreciationDAO(GIEXPerilDepreciationDAO giexPerilDepreciationDAO) {
		this.giexPerilDepreciationDAO = giexPerilDepreciationDAO;
	}

	@Override
	public List<GIEXLine> getLineList() throws SQLException, IOException {
		return giexPerilDepreciationDAO.getLineList();
	}

	@Override
	public JSONObject  getPerilList(HttpServletRequest request) throws JSONException, SQLException, IOException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss208PerilDepreciationList");
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> perilDepreciationList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(perilDepreciationList);
		return json;
	}

	@Override
	public String savePerilDep(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIEXPerilDepreciation.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIEXPerilDepreciation.class));
		return this.getGiexPerilDepreciationDAO().savePerilDepreciation(allParams);
	}

	@Override
	public String validateAddPerilCd(HttpServletRequest request)
			throws JSONException, SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("ACTION"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		return this.getGiexPerilDepreciationDAO().validateAddPerilCd(params);
	}

}
