package com.geniisys.giac.service.impl;

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
import com.geniisys.giac.dao.GIACTranMmDAO;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.giac.entity.GIACTranMm;
import com.geniisys.giac.service.GIACTranMmService;

public class GIACTranMmServiceImpl implements GIACTranMmService{

	private GIACTranMmDAO giacTranMmDAO;

	@Override
	public List<GIACTranMm> getClosedTransactionMonthYear(Map<String, Object> params)	throws SQLException {
		return giacTranMmDAO.getClosedTransactionMonthYear(params);
	}
	/**
	 * @return the giacTranMmDAO
	 */
	public GIACTranMmDAO getGiacTranMmDAO() {
		return giacTranMmDAO;
	}
	/**
	 * @param giacTranMmDAO the giacTranMmDAO to set
	 */
	public void setGiacTranMmDAO(GIACTranMmDAO giacTranMmDAO) {
		this.giacTranMmDAO = giacTranMmDAO;
	}
	@Override
	public String checkBookingDate(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		params.put("bookingMonth", request.getParameter("bookingMonth"));
		return this.giacTranMmDAO.checkBookingDate(params);
	}
	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		return this.getGiacTranMmDAO().getClosedTag(params);
	}
	
	@Override
	public JSONObject showGiacs038(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs038RecList");	
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiacs038(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACTranMm.class));
		params.put("appUser", userId);
		this.giacTranMmDAO.saveGiacs038(params);
	}
	
	public String checkFunctionGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("functionCode", request.getParameter("functionCode"));
		params.put("userId", userId);
		return this.giacTranMmDAO.checkFunctionGiacs038(params);
	}

	public Integer getNextTranYrGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		return this.giacTranMmDAO.getNextTranYrGiacs038(params);
	}
	
	public Integer checkTranYrGiacs038(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranYr", request.getParameter("tranYr"));
		return this.giacTranMmDAO.checkTranYrGiacs038(params);
	}
	
	public String generateTranMmGiacs038(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranYr", request.getParameter("tranYr"));
		params.put("userId", userId);
		
		return this.giacTranMmDAO.generateTranMmGiacs038(params);
	}
	
	@Override
	public JSONObject getTranMmStatHistGiacs038(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs038TranMmStatHist");	
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranYr", request.getParameter("tranYr"));
		params.put("tranMm", request.getParameter("tranMm"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject getClmTranMmStatHistGiacs038(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs038ClmTranMmStatHist");	
		params.put("fundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranYr", request.getParameter("tranYr"));
		params.put("tranMm", request.getParameter("tranMm"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
}