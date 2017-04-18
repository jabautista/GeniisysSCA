package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClaimPaymentDAO;
import com.geniisys.gicl.service.GICLClaimPaymentService;

public class GICLClaimPaymentServiceImpl implements GICLClaimPaymentService {
	
	private GICLClaimPaymentDAO giclClaimPaymentDAO;
	
	public GICLClaimPaymentDAO getGiclClaimPaymentDAO() {
		return giclClaimPaymentDAO;
	}

	public void setGiclClaimPaymentDAO(GICLClaimPaymentDAO giclClaimPaymentDAO) {
		this.giclClaimPaymentDAO = giclClaimPaymentDAO;
	}
	
	@Override
	public JSONObject showClaimPayment(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClaimPayment");				
		/*if((request.getParameter("claimId").compareTo("") == 0) && (request.getParameter("claimId").isEmpty())){
			
		}
		else{*/
			params.put("claimId", request.getParameter("claimId") == null ||request.getParameter("claimId") == "" ? 0 : Integer.parseInt(request.getParameter("claimId")));
		//}
		Map<String, Object> claimPaymentTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClaimPayment = new JSONObject(claimPaymentTableGrid);
		request.setAttribute("jsonClaimPayment", jsonClaimPayment);
		return jsonClaimPayment;
	}

	@Override
	public JSONObject showClaimPaymentAdv(HttpServletRequest request,
			GIISUser uSER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmAdvice");
		if((request.getParameter("adviceId").compareTo("") == 0) && (request.getParameter("adviceId").isEmpty())){
			params.put("adviceId", 0);	
		}
		else{
			params.put("adviceId", Integer.parseInt(request.getParameter("adviceId")));
		}
		
		if((request.getParameter("clmLossId").compareTo("") == 0) && (request.getParameter("clmLossId").isEmpty())){
			params.put("clmLossId", 0);	
		}
		else{
			params.put("clmLossId", Integer.parseInt(request.getParameter("clmLossId")));
		}
		if((request.getParameter("claimId").compareTo("") == 0) && (request.getParameter("claimId").isEmpty())){
			params.put("claimId", 0);
		}
		else{
			params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		}
		Map<String, Object> claimPaymentAdvTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClaimPaymentAdv = new JSONObject(claimPaymentAdvTableGrid);
		request.setAttribute("jsonClaimPaymentAdv", jsonClaimPaymentAdv);
		return jsonClaimPaymentAdv;
	}

	@Override
	public String validateEntries(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("clmLineCd", request.getParameter("clmLineCd"));
		params.put("clmSublineCd", request.getParameter("clmSublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("clmYy", request.getParameter("clmYy"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("clmSeqNo", request.getParameter("clmSeqNo"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		//params.put("ACTION", "validateEntries");
		return giclClaimPaymentDAO.validateEntries(params);
	}

}
