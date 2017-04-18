package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmRecoveryDAO;
import com.geniisys.gicl.entity.GICLClmRecovery;
import com.geniisys.gicl.entity.GICLRecHist;
import com.geniisys.gicl.entity.GICLRecoveryPayor;
import com.geniisys.gicl.service.GICLClmRecoveryService;
import com.seer.framework.util.StringFormatter;

public class GICLClmRecoveryServiceimpl implements GICLClmRecoveryService{

	private GICLClmRecoveryDAO giclClmRecoveryDAO;

	public GICLClmRecoveryDAO getGiclClmRecoveryDAO() {
		return giclClmRecoveryDAO;
	}

	public void setGiclClmRecoveryDAO(GICLClmRecoveryDAO giclClmRecoveryDAO) {
		this.giclClmRecoveryDAO = giclClmRecoveryDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#getGiclClmRecoveryGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmRecoveryGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("ACTION", "getGiclClmRecoveryGrid");
		params.put("pageSize", 1);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryTG", grid);
		request.setAttribute("object", grid); 
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#getGiclClmRecoveryPayorGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmRecoveryPayorGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("ACTION", "getGiclRecoveryPayorGrid");
		params.put("pageSize", StringUtils.isEmpty(request.getParameter("pageSize")) ? 1 :Integer.parseInt(request.getParameter("pageSize")));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryPayorTG", grid);
		request.setAttribute("object", grid); 
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#getGiclClmRecoveryHistGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmRecoveryHistGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("ACTION", "getGiclRecHistGrid");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryHistTG", grid);
		request.setAttribute("object", grid); 
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#getGiclClmRecoveryGrid2(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmRecoveryGrid2(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("ACTION", "getGiclClmRecoveryGrid2");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryTG", grid);
		request.setAttribute("object", grid); 
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#saveRecoveryInfo(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String saveRecoveryInfo(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("lineCd", request.getParameter("lineCd")); 
		params.put("setRecovs", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRecovs")), USER.getUserId(), GICLClmRecovery.class));
		params.put("delRecovs", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRecovs")), USER.getUserId(), GICLClmRecovery.class));
		params.put("recoverable", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("recoverable"))));
		params.put("setPayors", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setPayors")), USER.getUserId(), GICLRecoveryPayor.class));
		params.put("delPayors", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delPayors")), USER.getUserId(), GICLRecoveryPayor.class));
		params.put("setHist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setHist")), USER.getUserId(), GICLRecHist.class));
		params.put("delHist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delHist")), USER.getUserId(), GICLRecHist.class));
		return StringFormatter.escapeHTML(this.giclClmRecoveryDAO.saveRecoveryInfo(params));
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#genRecHistNo(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String genRecHistNo(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recoveryId", request.getParameter("recoveryId")); 
		return this.giclClmRecoveryDAO.genRecHistNo(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#checkRecoveredAmtPerRecovery(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String checkRecoveredAmtPerRecovery(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params = this.giclClmRecoveryDAO.checkRecoveredAmtPerRecovery(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#writeOffRecovery(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void writeOffRecovery(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("button", request.getParameter("button")); 
		this.giclClmRecoveryDAO.writeOffRecovery(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#cancelRecovery(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void cancelRecovery(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("button", request.getParameter("button")); 
		this.giclClmRecoveryDAO.cancelRecovery(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmRecoveryService#closeRecovery(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void closeRecovery(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("button", request.getParameter("button")); 
		this.giclClmRecoveryDAO.closeRecovery(params);
	}

	@Override
	public void getClmRecoveryDistInfoGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("ACTION", "getClmRecoveryDistInfoGrid");
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryDistTG", grid);
		request.setAttribute("object", grid); 
	}
	
	@Override
	public JSONObject validatePrint(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("report1", request.getParameter("report1"));
		params.put("report2", request.getParameter("report2"));
		params.put("report3", request.getParameter("report3"));
		params.put("report4", request.getParameter("report4"));
		
		this.getGiclClmRecoveryDAO().validatePrint(params);
				
		return new JSONObject(params);
	}

	@Override
	public void updateDemandLetterDates(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("demandLetterDate", request.getParameter("demandLetterDate"));
		params.put("demandLetterDate2", request.getParameter("demandLetterDate2"));
		params.put("demandLetterDate3", request.getParameter("demandLetterDate3"));
		
		this.getGiclClmRecoveryDAO().updateDemandLetterDates(params);
	}

	@Override
	public Map<String, Object> getGicls025Variables(Integer claimId) throws SQLException {
		return getGiclClmRecoveryDAO().getGicls025Variables(claimId);
	}	
}

