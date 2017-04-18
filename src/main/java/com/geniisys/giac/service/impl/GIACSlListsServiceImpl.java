package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACSlListsDAO;
import com.geniisys.giac.entity.GIACSlLists;
import com.geniisys.giac.service.GIACSlListsService;
import com.seer.framework.util.StringFormatter;

public class GIACSlListsServiceImpl implements GIACSlListsService {

	/** The logger **/
	private static Logger log = Logger.getLogger(GIACSlListsServiceImpl.class);
	
	/** The Giac SL Lists Dao **/
	private GIACSlListsDAO giacSlListsDAO;

	public void setGiacSlListsDAO(GIACSlListsDAO giacSlListsDAO) {
		this.giacSlListsDAO = giacSlListsDAO;
	}

	public GIACSlListsDAO getGiacSlListsDAO() {
		return giacSlListsDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACSlListsService#getSlListingByWhtaxId(java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getSlListingByWhtaxId(Integer pageNo, String keyword,
			Integer whtaxId) throws SQLException {
		log.info("getSlListingByWhtaxId");
		List<GIACSlLists> giacSlLists = this.getGiacSlListsDAO().getSlListingByWhtaxId(whtaxId, keyword);
		PaginatedList paginatedList = new PaginatedList(giacSlLists, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	public String getSapIntegrationSw() throws SQLException{
		return this.giacSlListsDAO.getSapIntegrationSw();
	}
	
	@Override
	public JSONObject showGiacs309(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs309RecList");	
		params.put("slTypeCd", request.getParameter("slTypeCd"));
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
		
		return new JSONObject(recList);
	}

	
	@Override
	public void saveGiacs309(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACSlLists.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACSlLists.class));
		params.put("appUser", userId);
		this.giacSlListsDAO.saveGiacs309(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("slTypeCd", request.getParameter("slTypeCd"));
		params.put("slCd", request.getParameter("slCd"));
		this.giacSlListsDAO.valAddRec(params);
	}

}
