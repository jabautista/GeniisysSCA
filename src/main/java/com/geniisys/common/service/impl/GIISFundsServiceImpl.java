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

import com.geniisys.common.dao.GIISFundsDAO;
import com.geniisys.common.entity.GIISFunds;
import com.geniisys.common.service.GIISFundsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;

public class GIISFundsServiceImpl implements GIISFundsService {
	
	/** The DAO */
	private GIISFundsDAO giisFundsDAO;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIISFundsServiceImpl.class);

	public void setGiisFundsDAO(GIISFundsDAO giisFundsDAO) {
		this.giisFundsDAO = giisFundsDAO;
	}

	public GIISFundsDAO getGiisFundsDAO() {
		return giisFundsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getFundCdLOVList(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getFundCdLOVList(Integer pageNo, String keyword)
			throws SQLException {
		log.info("getFundCdLOVList");
		List<Map<String, Object>> fundCdList = this.getGiisFundsDAO().getFundCdLOVList(keyword);
		PaginatedList paginatedList = new PaginatedList(fundCdList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	@Override
	public JSONObject showGiacs302(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs302RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("fundCd") != null){
			String recId = request.getParameter("fundCd");
			this.giisFundsDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs302(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISFunds.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISFunds.class));
		params.put("appUser", userId);
		this.giisFundsDAO.saveGiacs302(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("fundCd") != null){
			String recId = request.getParameter("fundCd");
			this.giisFundsDAO.valAddRec(recId);
		}
	}
}
