/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.service.impl
	File Name: GICLClmDocsServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 9, 2011
	Description: 
*/


package com.geniisys.gicl.service.impl;

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
import com.geniisys.gicl.dao.GICLClmDocsDAO;
import com.geniisys.gicl.entity.GICLClmDocs;
import com.geniisys.gicl.service.GICLClmDocsService;
import com.seer.framework.util.StringFormatter;

public class GICLClmDocsServiceImpl implements GICLClmDocsService{
	private GICLClmDocsDAO giclClmDocsDAO;
	@Override
	public List<GICLClmDocs> getClmDocsList(Map<String, Object> params)
			throws SQLException {
		return this.getGiclClmDocsDAO().getClmDocsList(params);
	}
	/**
	 * @param giclClmDocsDAO the giclClmDocsDAO to set
	 */
	public void setGiclClmDocsDAO(GICLClmDocsDAO giclClmDocsDAO) {
		this.giclClmDocsDAO = giclClmDocsDAO;
	}
	/**
	 * @return the giclClmDocsDAO
	 */
	public GICLClmDocsDAO getGiclClmDocsDAO() {
		return giclClmDocsDAO;
	}
	@Override
	public JSONObject showGicls110(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmDocsGicls110List");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	@Override
	public void saveGicls110(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLClmDocs.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLClmDocs.class));
		params.put("appUser", userId);
		this.giclClmDocsDAO.saveGicls181(params);
	}
	@Override
	public void valDeleteRec(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("clmDocCd", request.getParameter("clmDocCd"));
		this.giclClmDocsDAO.valDeleteRec(params);
	}
}
