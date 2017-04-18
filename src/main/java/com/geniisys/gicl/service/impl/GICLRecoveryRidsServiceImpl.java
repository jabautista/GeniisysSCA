package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLRecoveryRidsDAO;
import com.geniisys.gicl.entity.GICLRecoveryRids;
import com.geniisys.gicl.service.GICLRecoveryRidsService;
import com.seer.framework.util.StringFormatter;

public class GICLRecoveryRidsServiceImpl implements GICLRecoveryRidsService{
	private GICLRecoveryRidsDAO giclRecoveryRidsDAO;

	public void setGiclRecoveryRidsDAO(GICLRecoveryRidsDAO giclRecoveryRidsDAO) {
		this.giclRecoveryRidsDAO = giclRecoveryRidsDAO;
	}

	public GICLRecoveryRidsDAO getGiclRecoveryRidsDAO() {
		return giclRecoveryRidsDAO;
	}

	@Override
	public GICLRecoveryRids getFlaRecovery(Map<String, Object> params)
			throws SQLException {
		return this.getGiclRecoveryRidsDAO().getFlaRecovery(params);
	}
	
	@Override
	public String getClmRecoveryRIDistGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		params.put("recDistNo", request.getParameter("recDistNo"));
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		params.put("ACTION", "getClmRecoveryRIDistGrid");
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		return grid;
	}
}
