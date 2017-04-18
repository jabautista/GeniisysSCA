package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIMortgageeDAO;
import com.geniisys.gipi.entity.GIPIMortgagee;
import com.geniisys.gipi.service.GIPIMortgageeService;
import com.seer.framework.util.StringFormatter;

public class GIPIMortgageeServiceImpl implements GIPIMortgageeService{

	private GIPIMortgageeDAO gipiMortgageeDAO;

	public GIPIMortgageeDAO getGipiMortgageeDAO() {
		return gipiMortgageeDAO;
	}

	public void setGipiMortgageeDAO(GIPIMortgageeDAO gipiMortgageeDAO) {
		this.gipiMortgageeDAO = gipiMortgageeDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getMortgageeList(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIMortgagee> mortgageeList = this.getGipiMortgageeDAO().getMortgageeList(params);
		params.put("rows", new JSONArray((List<GIPIMortgagee>)StringFormatter.escapeHTMLInList(mortgageeList)));
		grid.setNoOfPages(mortgageeList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getItemMortgagees(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIMortgagee> vehicleMortgagees = this.getGipiMortgageeDAO().getItemMortgagees(params);
		params.put("rows", new JSONArray((List<GIPIMortgagee>)StringFormatter.escapeHTMLInList(vehicleMortgagees)));
		grid.setNoOfPages(vehicleMortgagees);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public JSONObject getMortgageesTableGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getMortgageesTableGrid");				
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;
	}

	//kenneth SR 5483 05.26.2016
	@Override
	public BigDecimal getPerItemAmount(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPerItemAmount");
		params.put("policyId", request.getParameter("policyId"));
		params.put("mortgCd", request.getParameter("mortgCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		return gipiMortgageeDAO.getPerItemAmount(params);
	}
	//MarkS SR 5483 09.07.2016
	@Override
	public String getPerItemMortgName(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPerItemMortgName");
		params.put("policyId", request.getParameter("policyId"));
		params.put("mortgCd", request.getParameter("mortgCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		return gipiMortgageeDAO.getPerItemMortgName(params);
	}
}
