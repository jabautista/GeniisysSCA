package com.geniisys.quote.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.quote.dao.GIPIDeductiblesDAO;
import com.geniisys.quote.entity.GIPIDeductibles;
import com.geniisys.quote.service.GIPIDeductiblesService;
import com.seer.framework.util.StringFormatter;

public class GIPIDeductiblesServiceImpl implements GIPIDeductiblesService{

	private GIPIDeductiblesDAO gipiDeductiblesDAO2;
	
	public GIPIDeductiblesDAO getGipiDeductiblesDAO2() {
		return gipiDeductiblesDAO2;
	}

	public void setGipiDeductiblesDAO2(GIPIDeductiblesDAO gipiDeductiblesDAO2) {
		this.gipiDeductiblesDAO2 = gipiDeductiblesDAO2;
	}

	@Override
	public String saveDeductibleInfo(String rowParams,
			Map<String, Object> params) throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(rowParams);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), (String)params.get("userId"), GIPIDeductibles.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), (String)params.get("userId"), GIPIDeductibles.class));
		return this.getGipiDeductiblesDAO2().saveDeductibleInfo(allParams, params);
	}

	@Override
	public String getDeductibleInfoGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDeductibleInfoTG");
		params.put("quoteId", Integer.parseInt(request.getParameter("quoteId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		return grid;
	}

	@Override
	public String checkDeductibleText() throws SQLException {
		return this.getGipiDeductiblesDAO2().checkDeductibleText();
	}
}
