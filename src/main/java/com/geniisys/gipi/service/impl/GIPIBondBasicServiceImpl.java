package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIBondBasicDAO;
import com.geniisys.gipi.entity.GIPIBondBasic;
import com.geniisys.gipi.service.GIPIBondBasicService;
import com.seer.framework.util.StringFormatter;

public class GIPIBondBasicServiceImpl implements GIPIBondBasicService{

	private GIPIBondBasicDAO gipiBondBasicDAO;

	public GIPIBondBasicDAO getGipiBondBasicDAO() {
		return gipiBondBasicDAO;
	}

	public void setGipiBondBasicDAO(GIPIBondBasicDAO gipiBondBasicDAO) {
		this.gipiBondBasicDAO = gipiBondBasicDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void getBondPolicyData(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		FormInputUtil.prepareDateParam("lossDate", params, request);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		FormInputUtil.prepareDateParam("polEffDate", params, request);
		List<GIPIBondBasic> bondPol = (List<GIPIBondBasic>) StringFormatter.escapeHTMLInList(this.gipiBondBasicDAO.getBondPolicyData(params));
		String bond = new JSONArray((List<GIPIBondBasic>) bondPol).toString();
		if (bondPol.size() > 0){
			this.getGipiCosigntry(bondPol.get(0).getPolicyId(), request);
		}else{
			this.getGipiCosigntry(null, request);
		}
		request.setAttribute("gipiBondBasic", bond);
	}
	
	@Override
	public void getGipiCosigntry(Integer policyId, HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipiCosigntryGrid");
		params.put("policyId", policyId);
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("gipiCosigntryGrid", grid);
		request.setAttribute("object", grid);
	}
	
}
