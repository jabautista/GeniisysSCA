package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLLossRecoveryStatusDAO;
import com.geniisys.gicl.service.GICLLossRecoveryStatusService;

public class GICLLossRecoveryStatusServiceImpl implements GICLLossRecoveryStatusService{
	
	private GICLLossRecoveryStatusDAO giclLossRecoveryStatusDAO;
	
	
	public GICLLossRecoveryStatusDAO getGiclLossRecoveryStatusDAO() {
		return giclLossRecoveryStatusDAO;
	}


	public void setGiclLossRecoveryStatusDAO(
			GICLLossRecoveryStatusDAO giclLossRecoveryStatusDAO) {
		this.giclLossRecoveryStatusDAO = giclLossRecoveryStatusDAO;
	}


	@Override
	public JSONObject showLossRecoveryStatus(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		String recStatusType = null;
		String dateBy = request.getParameter("dateBy");
		String dateAsOf = request.getParameter("dateAsOf");
		String dateFrom = request.getParameter("dateFrom");
		String dateTo = request.getParameter("dateTo");
				
		try{
			recStatusType = request.getParameter("recStatusType");
			if (recStatusType.equals(null))
				recStatusType = "A";
			else if (recStatusType.equals("%"))
				recStatusType = "A";
		}catch(NullPointerException e){
			recStatusType = "A";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getRecoveryStatus");
		params.put("appUser", USER.getUserId());
		params.put("recStatusType", recStatusType);
		params.put("dateBy", dateBy);
		params.put("dateAsOf", dateAsOf);
		params.put("dateFrom", dateFrom);
		params.put("dateTo", dateTo);
		
		Map<String, Object> recoveryStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(recoveryStatusTableGrid);
		request.setAttribute("jsonRecoveryStatus", json);
		return json;		
	}


	@Override
	public JSONObject showGICLS269RecoveryDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		String claimId = request.getParameter("claimId");
		String recoveryId = request.getParameter("recoveryId");
		String lawyerCd = request.getParameter("lawyerCd");
		String lawyer = request.getParameter("lawyer");
		String tpItemDesc = request.getParameter("tpItemDesc");
		String recoverableAmt = request.getParameter("recoverableAmt");
		String recoveredAmtR = request.getParameter("recoveredAmtR");
		String plateNo = request.getParameter("plateNo");
		
		request.setAttribute("claimId", claimId);
		request.setAttribute("recoveryId", recoveryId);
		request.setAttribute("lawyerCd", lawyerCd);
		request.setAttribute("lawyer", lawyer);
		request.setAttribute("tpItemDesc", tpItemDesc);
		request.setAttribute("recoverableAmt", recoverableAmt);
		request.setAttribute("recoveredAmtR", recoveredAmtR);
		request.setAttribute("plateNo", plateNo);
		
		params.put("ACTION", "getRecoveryDetails");
		params.put("claimId", claimId);
		params.put("recoveryId", recoveryId);
		params.put("lawyerCd", lawyerCd);
		params.put("lawyer", lawyer);
		params.put("tpItemDesc", tpItemDesc);
		params.put("recoverableAmt", recoverableAmt);
		params.put("recoveredAmtR", recoveredAmtR);
		params.put("plateNo", plateNo);
			
		Map<String, Object> recoveryDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(recoveryDetailsTableGrid);
		request.setAttribute("jsonRecoveryDetails", json);
		return json;
	}
	
	@Override
	public JSONObject showGICLS269RecoveryHistory(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		String recoveryId = request.getParameter("recoveryId");	
		params.put("ACTION", "getRecoveryHistory");
		params.put("recoveryId", recoveryId);
		request.setAttribute("recoveryId", recoveryId);
		Map<String, Object> recoveryHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(recoveryHistoryTableGrid);
		request.setAttribute("jsonRecoveryHistory", json);
		return json;
	}


}
