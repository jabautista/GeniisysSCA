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
import com.geniisys.common.dao.GIISLostBidDAO;
import com.geniisys.common.entity.GIISLostBid;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLostBidService;
import com.geniisys.framework.util.JSONUtil;
import com.seer.framework.util.StringFormatter;

public class GIISLostBidServiceImpl implements GIISLostBidService{
	
	private GIISLostBidDAO giisLostBidDAO;
	
	private Logger log = Logger.getLogger(GIISLostBidServiceImpl.class);
	
	public void setGiisLostBidDAO(GIISLostBidDAO giisLostBidDAO) {
		this.giisLostBidDAO = giisLostBidDAO;
	}

	public GIISLostBidDAO getGiisLostBidDAO() {
		return giisLostBidDAO;
	}

	@Override
	public boolean deleteLostBidReason(Map<String, Object> params) throws SQLException {
		String[] reasonCds = (String[]) params.get("reasonCds");
		
		if(reasonCds != null) {
			Map<String, Object> delParams = new HashMap<String, Object>();
			log.info("Deleting Reason...");
			for(int i=0; i<reasonCds.length; i++) {
				delParams.put("reasonCds", reasonCds[i]);
				this.getGiisLostBidDAO().deleteLostBidReason(delParams);
			}
			log.info(reasonCds.length + " reason/s deleted...");
		}
		return true;
	}
	
	@Override
	public Integer generateReasonCd() throws SQLException {
		log.info("Retrieving new reasonCd...");
		Integer rCode = this.getGiisLostBidDAO().generateReasonCd();
		log.info("Reason Code retrieved - " + rCode);
		return rCode;
	}
	
	public Integer generateReasonCd2() throws SQLException {
		log.info("Retrieving new reasonCd...");
		Integer rCode = this.getGiisLostBidDAO().generateReasonCd2();
		log.info("Reason Code retrieved - " + rCode);
		return rCode;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLostBid> getLostBidReasonList(String userId) throws SQLException {
		log.info("Retrieving List of Reasons for Denial...");
		List<GIISLostBid> lostBidList = (List<GIISLostBid>) StringFormatter.replaceQuotesInObject(this.getGiisLostBidDAO().getLostBidReasonList(userId));
		log.info(lostBidList.size() + " Reason/s Retrieved.");
		return lostBidList;
	}

	@Override
	public boolean saveLostBidReason(Map<String, Object> allParameters) throws Exception {
		log.info("Saving reason...");
		this.giisLostBidDAO.saveLostBidReason2(allParameters);
		log.info("Reason Saved.");
		return true;
	}
	
	public void saveReasonUpdates(HttpServletRequest request, GIISUser USER)throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delParams")), USER.getUserId(), GIISLostBid.class));
		params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("insParams")), USER.getUserId(), GIISLostBid.class));
	//	this.getGiisLostBidDAO().saveReasonUpdates();
	}
	
	@Override
	public Map<String, Object> valUpdateRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("reasonCd",request.getParameter("reasonCd"));		
		return this.giisLostBidDAO.valUpdateRec(params);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reasonCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("reasonCd",request.getParameter("reasonCd"));		
			this.giisLostBidDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss204(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLostBid.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLostBid.class));
		params.put("appUser", userId);
		this.giisLostBidDAO.saveGiiss204(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reasonCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();			
			params.put("reasonCd",request.getParameter("reasonCd"));		
			this.giisLostBidDAO.valDeleteRec(params);
		}
	}
}
