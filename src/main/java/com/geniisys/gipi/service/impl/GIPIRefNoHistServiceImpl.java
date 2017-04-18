package com.geniisys.gipi.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIRefNoHistDAO;
import com.geniisys.gipi.service.GIPIRefNoHistService;
import com.geniisys.gipi.util.FileUtil;

public class GIPIRefNoHistServiceImpl implements GIPIRefNoHistService{

	private GIPIRefNoHistDAO gipiRefNoHistDAO;

	public GIPIRefNoHistDAO getGipiRefNoHistDAO() {
		return gipiRefNoHistDAO;
	}

	public void setGipiRefNoHistDAO(GIPIRefNoHistDAO gipiRefNoHistDAO) {
		this.gipiRefNoHistDAO = gipiRefNoHistDAO;
	}

	@Override
	public JSONObject getRefNoHistListByUser(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRefNoHistListByUser");
		params.put("userId", userId);
		
		Map<String, Object> refNoHistList = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(refNoHistList);
	}

	@Override
	public JSONObject generateBankRefNo(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("acctIssCd", request.getParameter("acctIssCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("noOfRefNo", request.getParameter("noOfRefNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return new JSONObject(this.getGipiRefNoHistDAO().generateBankRefNo(params));
	}

	@Override
	public String generateCSV(HttpServletRequest request, String userId)
			throws SQLException, IOException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("range", request.getParameter("range"));
		params.put("exactDate", request.getParameter("exactDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		
		List<Map<String, Object>> rows = this.getGipiRefNoHistDAO().generateCSV(params);
		
		return request.getHeader("Referer")+"csv/"+ FileUtil.generateCSVFile(rows, "GBRN", request.getSession().getServletContext().getRealPath(""));
	}
	
}
