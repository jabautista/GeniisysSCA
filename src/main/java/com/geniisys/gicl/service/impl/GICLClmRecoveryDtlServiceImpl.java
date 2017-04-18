package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmRecoveryDtlDAO;
import com.geniisys.gicl.service.GICLClmRecoveryDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLClmRecoveryDtlServiceImpl implements GICLClmRecoveryDtlService{
	
	private GICLClmRecoveryDtlDAO giclClmRecoveryDtlDAO;

	public GICLClmRecoveryDtlDAO getGiclClmRecoveryDtlDAO() {
		return giclClmRecoveryDtlDAO;
	}

	public void setGiclClmRecoveryDtlDAO(GICLClmRecoveryDtlDAO giclClmRecoveryDtlDAO) {
		this.giclClmRecoveryDtlDAO = giclClmRecoveryDtlDAO;
	}

	@Override
	public void getGiclClmRecoveryDtlGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("lineCd", request.getParameter("lineCd")); 
		params.put("pageSize", 5);
		params.put("ACTION", "getGiclClmRecoveryDtlGrid");
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryDtlTG", grid);
		request.setAttribute("object", grid); 
	}
	
}
