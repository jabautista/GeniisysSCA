package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISPerilClassDAO;
import com.geniisys.giis.entity.GIISPerilClass;
import com.geniisys.giis.service.GIISPerilClassService;
import com.seer.framework.util.StringFormatter;

public class GIISPerilClassServiceImpl implements GIISPerilClassService {

	private GIISPerilClassDAO giisPerilClassDAO;
	
	/**
	 * @return the giisPerilClassDAO
	 */
	public GIISPerilClassDAO getGiisPerilClassDAO() {
		return giisPerilClassDAO;
	}

	/**
	 * @param giisPerilClassDAO the giisPerilClassDAO to set
	 */
	public void setGiisPerilClassDAO(GIISPerilClassDAO giisPerilClassDAO) {
		this.giisPerilClassDAO = giisPerilClassDAO;
	}
	
	public void savePerilClass(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setPerilClass", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPerilClass.class));
		params.put("delPerilClass", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPerilClass.class));
		getGiisPerilClassDAO().savePerilClass(params);
	}
	
	@Override
	public Map<String, Object> getPerilsPerClass(HttpServletRequest request,
			GIISUser USER) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		String modId = "GIISS062";
		params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
		params.put("appUser", USER.getUserId());
		Map<String, Object> perilClassTableGrid = TableGridUtil.getTableGrid(request, params);
		return perilClassTableGrid;
	}

	@Override
	public Map<String, Object> getPerilsPerClassDetails(HttpServletRequest request,
			GIISUser USER) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		String modId = "GIISS062";
		params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
		params.put("appUser", USER.getUserId());
		params.put("classCd", request.getParameter("classCd"));
		Map<String, Object> perilClassTableGrid = TableGridUtil.getTableGrid(request, params);
		return perilClassTableGrid;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getAllPerilsPerClassDetails(HttpServletRequest request,
			String userId) throws SQLException, JSONException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		params.put("classCd", request.getParameter("classCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("appUser", userId);
		result = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(getGiisPerilClassDAO().getAllPerilsPerClassDetails(params));
		JSONArray allPerilsPerClassDetailsObj = new JSONArray(result);
		System.out.println("allPerilsPerClassDetailsObj: "+ allPerilsPerClassDetailsObj.toString());
		return allPerilsPerClassDetailsObj.toString();
	}
}