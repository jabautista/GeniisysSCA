package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISInspectorDAO;
import com.geniisys.common.entity.GIISInspector;
import com.geniisys.common.service.GIISInspectorService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;

public class GIISInspectorServiceImpl implements GIISInspectorService{

	private Logger log = Logger.getLogger(GIISInspectorServiceImpl.class);
	
	private GIISInspectorDAO giisInspectorDAO;

	public GIISInspectorDAO getGiisInspectorDAO() {
		return giisInspectorDAO;
	}

	public void setGiisInspectorDAO(GIISInspectorDAO giisInspectorDAO) {
		this.giisInspectorDAO = giisInspectorDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISInspectorService#getInspectorListing(java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getInspectorListing(Map<String, Object> params)
			throws SQLException {
		log.info("getInspectorListing");
		String searchKeyword = '%'+params.get("keyword").toString().toUpperCase()+'%';
		List<GIISInspector> inspectorList = this.getGiisInspectorDAO().getInspectorListing(searchKeyword);
		PaginatedList paginatedList = new PaginatedList(inspectorList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage((Integer) params.get("page"));
		return paginatedList;
	}

	@Override
	public JSONObject showGiiss169(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss169List");		
		Map<String, Object> giiss169List = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGiiss169List = new JSONObject(giiss169List);	
		return jsonGiiss169List;
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("inspCd") != null){
			String recId = request.getParameter("inspCd");
			this.getGiisInspectorDAO().valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss169(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISInspector.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISInspector.class));
		params.put("appUser", userId);
		this.getGiisInspectorDAO().saveGiiss169(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("inspName") != null){
			String inspName = request.getParameter("inspName");
			this.getGiisInspectorDAO().valAddRec(inspName);
		}
	}

	@Override
	public List<GIISInspector> getInspNameList() throws SQLException {
		return this.getGiisInspectorDAO().getInspNameList();
	}
}
