package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIVehicleDAO;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.service.GIPIVehicleService;
import com.seer.framework.util.StringFormatter;

public class GIPIVehicleServiceImpl implements GIPIVehicleService{
	
	private GIPIVehicleDAO	gipiVehicleDAO;

	public GIPIVehicleDAO getGipiVehicleDAO() {
		return gipiVehicleDAO;
	}

	public void setGipiVehicleDAO(GIPIVehicleDAO gipiVehicleDAO) {
		this.gipiVehicleDAO = gipiVehicleDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getMotorCars(java.util.HashMap)
	 */
	@Override
	public JSONObject getMotorCars (HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMotorCars2");
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("motorNo", request.getParameter("motorNo"));
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("serialNo", request.getParameter("serialNo"));
		params.put("modelYear", request.getParameter("modelYear"));
		params.put("cocType", request.getParameter("cocType"));
		params.put("cocSerialNo", request.getParameter("cocSerialNo"));
		params.put("cocYy", request.getParameter("cocYy"));
		params.put("policyNo", request.getParameter("policyNo"));
		params.put("polFlag", request.getParameter("polFlag"));
		Map<String, Object> motorCarMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMotorCar = new JSONObject(motorCarMap);
		return jsonMotorCar;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getVehicleInfo(java.util.HashMap)
	 */
	@Override
	public GIPIVehicle getVehicleInfo(HashMap<String, Object> params) throws SQLException {
		return gipiVehicleDAO.getVehicleInfo(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getMotorCoCTableGrid(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getMotorCoCTableGrid(HashMap<String, Object> params) 
		throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> vehicleList = this.getGipiVehicleDAO().getMotorCoCList(params);
		params.put("rows", new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(vehicleList)));
		grid.setNoOfPages(vehicleList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#updateVehiclesGIPIS091(java.lang.String, java.lang.String)
	 */
	@Override
	public void updateVehiclesGIPIS091(String param, String userId)
			throws SQLException, JSONException {	
		JSONArray objArray = new JSONArray(param);
		JSONObject obj = null;
		Map<String, Object> vehicleObj = null;
		List<Map<String, Object>> vehicleList = new ArrayList<Map<String,Object>>();
		
		for(int i=0; i<objArray.length(); i++) {
			vehicleObj = new HashMap<String, Object>();
			obj = objArray.getJSONObject(i);
			
			vehicleObj.put("appUser", userId);
			vehicleObj.put("policyId", obj.isNull("policyId") ? null : obj.getInt("policyId"));
			vehicleObj.put("itemNo", obj.isNull("itemNo") ? null : obj.getInt("itemNo"));
			vehicleObj.put("cocYy", obj.isNull("cocYy") ? null : obj.getInt("cocYy"));
			//marco - added || condition - 07.01.2013
			vehicleObj.put("cocSerialNo", obj.isNull("cocSerialNo") || obj.get("cocSerialNo").toString().equals("") ? 0 : obj.getInt("cocSerialNo"));
			vehicleObj.put("cocAtcn", obj.isNull("cocAtcn") ? null : obj.getString("cocAtcn"));
			
			vehicleList.add(vehicleObj);
		}
		
		this.getGipiVehicleDAO().updateVehiclesGIPIS091(vehicleList);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#checkExistingCOCSerial(java.util.Map)
	 */
	@Override
	public String checkExistingCOCSerial(Map<String, Object> params)
			throws SQLException {
		return this.getGipiVehicleDAO().checkExistingCOCSerial(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getPlateDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPlateDtl(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> plateDtlList = this.getGipiVehicleDAO().getPlateDtl(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(plateDtlList)));
		grid.setNoOfPages(plateDtlList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getMotorDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getMotorDtl(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> motorDtlList = this.getGipiVehicleDAO().getMotorDtl(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(motorDtlList)));
		grid.setNoOfPages(motorDtlList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIVehicleService#getSerialDtl(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getSerialDtl(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> serialDtlList = this.getGipiVehicleDAO().getSerialDtl(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(serialDtlList)));
		grid.setNoOfPages(serialDtlList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	/**
	 * @author rey
	 * @date 08.18.2011
	 * carrier lists
	 */
	@Override
	public List<GIPIVehicle> getCarrierList(HashMap<String, Object> params)
			throws SQLException {
		List<GIPIVehicle> carrierList = gipiVehicleDAO.getCarrierListDAO(params);
		return carrierList;
	}

	@Override
	public GIPIVehicle getMotcarItemDtls(Map<String, Object> params)
			throws SQLException {
		return this.getGipiVehicleDAO().getMotcarItemDtls(params);
	}

	@Override
	public JSONObject getCTPLPolicies(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCTPLPolicies");
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("plateEnding", request.getParameter("plateEnding"));
		params.put("dateBasis", request.getParameter("dateBasis"));
		params.put("dateRange", request.getParameter("dateRange"));
		params.put("reinsurance", request.getParameter("reinsurance"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		Map<String, Object> ctplPoliciesTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(ctplPoliciesTG);
	}

	@Override
	public JSONObject getPolListingPerMake(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPolListingPerMake");
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("companyCd", request.getParameter("companyCd"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		params.put("credBranch", request.getParameter("credBranch"));
		System.out.println("********* " + userId + " *********");
		Map<String, Object> polListingPerMakeTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPolListingPerMakeTable = new JSONObject(polListingPerMakeTable);
		request.setAttribute("jsonPolListingPerMakeTable", jsonPolListingPerMakeTable);
		return jsonPolListingPerMakeTable;
	}

	@Override
	public Map<String, Object> validateGipis192Make(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("make", request.getParameter("make"));
		params.put("companyCd", request.getParameter("companyCd"));
		params.put("company", request.getParameter("company"));
		return gipiVehicleDAO.validateGipis192Make(params);
	}

	@Override
	public Map<String, Object> validateGipis192Company(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("companyCd", request.getParameter("companyCd"));
		params.put("company", request.getParameter("company"));
		return gipiVehicleDAO.validateGipis192Company(params);
	}

	@Override
	public JSONObject showPolListingPerMotorType(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS194List");
		params.put("motType", request.getParameter("motType"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("dateType", request.getParameter("dateType"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		Map<String, Object> perMotorTypeTable = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(perMotorTypeTable);
		return json;
	}
	
	public JSONObject getGipis193VehicleItemSum(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("dateType", request.getParameter("dateType"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		
		params = this.gipiVehicleDAO.getGipis193VehicleItemTotals(params);
		
		return new JSONObject(params);
	}
}
