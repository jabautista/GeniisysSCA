package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISReportsDAO;
import com.geniisys.common.entity.GIISReports;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISReportsServiceImpl implements GIISReportsService {

	private GIISReportsDAO giisReportsDAO;
	
	public void setGiisReportsDAO(GIISReportsDAO giisReportsDAO) {
		this.giisReportsDAO = giisReportsDAO;
	}

	public GIISReportsDAO getGiisReportsDAO() {
		return giisReportsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISReportsService#getReportVersion(java.lang.String)
	 */
	@Override
	public String getReportVersion(String reportId) throws SQLException {
		return this.getGiisReportsDAO().getReportVersion(reportId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISReportsService#getReportsPerLineCd(java.lang.String)
	 */
	@Override
	public List<GIISReports> getReportsPerLineCd(String lineCd) throws SQLException {
		return this.getGiisReportsDAO().getReportsPerLineCd(lineCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISReportsService#getReportsListing()
	 */
	@Override
	public List<GIISReports> getReportsListing() throws SQLException {
		return this.getGiisReportsDAO().getReportsListing();
	}

	@Override
	public String getReportVersion(String reportId, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("reportId", reportId);
		params.put("lineCd", lineCd);
		String reportVersion = this.getGiisReportsDAO().getReportVersion(params);
		return reportVersion == null ? "" : reportVersion;
	}

	@Override
	public List<GIISReports> getReportsListing2(String lineCd)
			throws SQLException {
		List<GIISReports> list = this.getGiisReportsDAO().getReportsListing2(lineCd);
		return list;
	}

	@Override
	public String getReportDesname2(String reportId) throws SQLException {
		return this.getGiisReportsDAO().getReportDesname2(reportId);
	}

	@Override
	public List<GIISReports> getGicls201Reports() throws SQLException {
		return this.getGiisReportsDAO().getGicls201Reports();
	}

	@Override
	public String validateReportId(String reportId) throws SQLException {
		return this.getGiisReportsDAO().validateReportId(reportId);
	}

	@Override
	public JSONObject showGiiss090(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss090RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reportId") != null){
			String recId = request.getParameter("reportId");
			this.giisReportsDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss090(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISReports.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISReports.class));
		params.put("appUser", userId);
		this.giisReportsDAO.saveGiiss090(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reportId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("recId", request.getParameter("reportId"));
			params.put("recDesc", request.getParameter("reportTitle"));
			this.giisReportsDAO.valAddRec(params);
		}
	}
	
}