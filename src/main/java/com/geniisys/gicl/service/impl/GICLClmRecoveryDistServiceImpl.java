package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmRecoveryDistDAO;
import com.geniisys.gicl.entity.GICLClmRecoveryDist;
import com.geniisys.gicl.entity.GICLRecoveryRids;
import com.geniisys.gicl.service.GICLClmRecoveryDistService;
import com.seer.framework.util.StringFormatter;

public class GICLClmRecoveryDistServiceImpl implements GICLClmRecoveryDistService{
	
	private GICLClmRecoveryDistDAO giclClmRecoveryDistDAO;
	
	public GICLClmRecoveryDistDAO getGiclClmRecoveryDistDAO() {
		return giclClmRecoveryDistDAO;
	}

	public void setGiclClmRecoveryDistDAO(
			GICLClmRecoveryDistDAO giclClmRecoveryDistDAO) {
		this.giclClmRecoveryDistDAO = giclClmRecoveryDistDAO;
	}

	@Override
	public String getClmRecoveryDistGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		params.put("ACTION", "getClmRecoveryDistGrid");
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		return grid;

	}
	
	@Override
	public void distributeRecovery(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId")); 
		params.put("dspLineCd", request.getParameter("dspLineCd")); 
		params.put("dspSublineCd", request.getParameter("dspSublineCd")); 
		params.put("dspIssCd", request.getParameter("dspIssCd")); 
		params.put("dspIssueYy", request.getParameter("dspIssueYy")); 
		params.put("dspPolSeqNo", request.getParameter("dspPolSeqNo")); 
		params.put("dspRenewNo", request.getParameter("dspRenewNo")); 
		params.put("effDate", request.getParameter("effDate")); 
		params.put("expiryDate", request.getParameter("expiryDate")); 
		params.put("lossDate", request.getParameter("lossDate")); 
		
		this.giclClmRecoveryDistDAO.distributeRecovery(params);
	}
	
	@Override
	public void negateDistRecovery(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId")); 
				
		this.giclClmRecoveryDistDAO.negateDistRecovery(params);

    }
	
	@Override
	public String saveRecoveryDist(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		System.out.println("testttttt: " +objParams.toString()); //belle
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("setRecovDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRecovDist")), USER.getUserId(), GICLClmRecoveryDist.class));
		//params.put("setRecovRIDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRecovRIDist")), USER.getUserId(), GICLRecoveryRids.class));
		params.put("delRecovDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRecovDist")), USER.getUserId(), GICLClmRecoveryDist.class));
		//params.put("delRecovRIDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRecovRIDist")), USER.getUserId(), GICLRecoveryRids.class));
		return StringFormatter.escapeHTML(this.giclClmRecoveryDistDAO.saveRecoveryDist(params));
	}

}
