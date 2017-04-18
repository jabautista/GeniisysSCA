package com.geniisys.giis.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISPerilClauses;
import com.geniisys.common.entity.GIISPerilTariff;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISPerilMaintenanceDAO;
import com.geniisys.giis.entity.GIISPeril;
import com.geniisys.giis.service.GIISPerilMaintenanceService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIISPerilMaintenanceServiceImpl implements
		GIISPerilMaintenanceService {
	
	GIISPerilMaintenanceDAO giisPerilMaintenanceDAO ;
	
	public GIISPerilMaintenanceDAO getGiisPerilMaintenanceDAO() {
		return giisPerilMaintenanceDAO;
	}

	public void setGiisPerilMaintenanceDAO(GIISPerilMaintenanceDAO gissPerilMaintenanceDAO) {
		this.giisPerilMaintenanceDAO = gissPerilMaintenanceDAO;
	}

	@Override
	public JSONObject getPerilList(HttpServletRequest request) throws JSONException, SQLException, IOException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISPerilGIISS003");
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> perilMaintenance = TableGridUtil.getTableGrid(request, params);
		perilMaintenance.put("allPerils", this.getGiisPerilMaintenanceDAO().getAllGIISPerilGIISS003(request.getParameter("lineCd"))); //pol cruz 01.14.2015
		JSONObject json = new JSONObject(perilMaintenance);
		return json;
	}
	
	@Override
	public String savePeril(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISPeril.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISPeril.class));
		
		return this.getGiisPerilMaintenanceDAO().savePeril(allParams);
	}

	@Override
	public String validateDeletePeril(HttpServletRequest request) throws SQLException{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilCd", request.getParameter("perilCd"));
		return this.getGiisPerilMaintenanceDAO().validateDeletePeril(param);
	}

	@Override
	public String perilIsExist(HttpServletRequest request) throws JSONException, SQLException, ParseException{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilCd", request.getParameter("perilCd"));
		return this.getGiisPerilMaintenanceDAO().perilIsExist(param);
	}
	
	@Override
	public String validatePerilSname(HttpServletRequest request) throws JSONException, SQLException, ParseException{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilSname", request.getParameter("perilSname"));
		return this.getGiisPerilMaintenanceDAO().validatePerilSname(param);
	}

	@Override
	public String validatePerilName(HttpServletRequest request)throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilName", request.getParameter("perilName"));
		return this.getGiisPerilMaintenanceDAO().validatePerilName(param);
	}

	@Override
	public String saveTariff(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISPerilTariff.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISPerilTariff.class));
		
		return this.getGiisPerilMaintenanceDAO().saveTariff(allParams);
	}

	@Override
	public String validateDeleteTariff(HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilCd", request.getParameter("perilCd"));
		param.put("tarfCd", request.getParameter("tarfCd"));
		return this.getGiisPerilMaintenanceDAO().validateDeleteTariff(param);
	}

	@Override
	public String saveWarrCla(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISPerilClauses.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISPerilClauses.class));
		
		return this.getGiisPerilMaintenanceDAO().saveWarrCla(allParams);
	}

	@Override
	public String validateDefaultTsi(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("perilCd", request.getParameter("perilCd"));
		param.put("defaultTsi", request.getParameter("defaultTsi"));
		param.put("bascPerlCd", request.getParameter("bascPerlCd"));
		return this.getGiisPerilMaintenanceDAO().validateDefaultTsi(param);
	}

	@Override
	public String getSublineCdName(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("sublineCd", request.getParameter("sublineCd"));
		return this.getGiisPerilMaintenanceDAO().getSublineCdName(param);
	}

	@Override
	public String getBasicPerilCdName(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("bascPerlCd", request.getParameter("bascPerlCd"));
		return this.getGiisPerilMaintenanceDAO().getBasicPerilCdName(param);
	}

	@Override
	public String getZoneNameFiName(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("zoneType", request.getParameter("zoneType"));
		return this.getGiisPerilMaintenanceDAO().getZoneNameFiName(param);
	}

	@Override
	public String getZoneNameMcName(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("zoneType", request.getParameter("zoneType"));
		return this.getGiisPerilMaintenanceDAO().getZoneNameMcName(param);
	}

	@Override
	public String checkAvailableWarrcla(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		return this.getGiisPerilMaintenanceDAO().checkAvailableWarrcla(param);
	}

	@Override
	public String validateSublineName(HttpServletRequest request)
			throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("sublineName", request.getParameter("sublineName"));
		return this.getGiisPerilMaintenanceDAO().validateSublineName(param);
	}

	@Override
	public String validateFiList(HttpServletRequest request)
			throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("rvMeaning", request.getParameter("rvMeaning"));
		return this.getGiisPerilMaintenanceDAO().validateFiList(param);
	}

	@Override
	public String validateMcList(HttpServletRequest request)
			throws JSONException, SQLException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("rvMeaning", request.getParameter("rvMeaning"));
		return this.getGiisPerilMaintenanceDAO().validateMcList(param);
	}
}