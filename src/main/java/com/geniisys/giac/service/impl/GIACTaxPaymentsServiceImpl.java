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
import com.geniisys.giac.dao.GIACTaxPaymentsDAO;
import com.geniisys.giac.entity.GIACTaxPayments;
import com.geniisys.giac.service.GIACTaxPaymentsService;

public class GIACTaxPaymentsServiceImpl implements GIACTaxPaymentsService{
	
	private GIACTaxPaymentsDAO giacTaxPaymentsDAO;
	
	public GIACTaxPaymentsDAO getGiacTaxPaymentsDAO() {
		return giacTaxPaymentsDAO;
	}

	public void setGiacTaxPaymentsDAO(GIACTaxPaymentsDAO giacTaxPaymentsDAO) {
		this.giacTaxPaymentsDAO = giacTaxPaymentsDAO;
	}
	
	@Override
	public JSONObject showTaxPayments(HttpServletRequest request)
			throws SQLException, JSONException {
		Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacTaxPayments");
		params.put("gaccTranId", gaccTranId);
		
		Map<String, Object> taxPaymentsTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(taxPaymentsTG);
	}

	@Override
	public Map<String, Object> getGIACS021Variables(Integer gaccTranId)
			throws SQLException {
		return this.getGiacTaxPaymentsDAO().getGIACS021Variables(gaccTranId);
	}
	
	@Override
	public List<Integer> getGIACS021Items(Integer gaccTranId)
			throws SQLException {
		return this.getGiacTaxPaymentsDAO().getGIACS021Items(gaccTranId);
	}
	
	@Override
	public void saveTaxPayments(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranSource", request.getParameter("tranSource"));
		params.put("orFlag", request.getParameter("orFlag"));
		params.put("userId", userId);
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIACTaxPayments.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delRows")), userId, GIACTaxPayments.class));
		this.getGiacTaxPaymentsDAO().saveTaxPayments(params);
	}
	
}
