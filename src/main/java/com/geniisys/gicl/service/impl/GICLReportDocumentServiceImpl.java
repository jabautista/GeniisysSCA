package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReportDocumentDAO;
import com.geniisys.gicl.entity.GICLRepairType;
import com.geniisys.gicl.entity.GICLReportDocument;
import com.geniisys.gicl.service.GICLReportDocumentService;

public class GICLReportDocumentServiceImpl implements GICLReportDocumentService {
	
	private GICLReportDocumentDAO giclReportDocumentDAO;

	@Override
	public JSONObject showGICLS180(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS180RecList");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGICLS180(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLReportDocument.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLReportDocument.class));
		params.put("appUser", userId);
		this.giclReportDocumentDAO.saveGICLS180(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reportId") != null){
			String reportId = request.getParameter("reportId");
			this.giclReportDocumentDAO.valDeleteRec(reportId);
		}
	}

	public GICLReportDocumentDAO getGiclReportDocumentDAO() {
		return giclReportDocumentDAO;
	}

	public void setGiclReportDocumentDAO(GICLReportDocumentDAO giclReportDocumentDAO) {
		this.giclReportDocumentDAO = giclReportDocumentDAO;
	}
}
