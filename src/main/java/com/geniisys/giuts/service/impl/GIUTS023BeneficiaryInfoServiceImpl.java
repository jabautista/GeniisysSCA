package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIGroupedItems;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.geniisys.giuts.dao.GIUTS023BeneficiaryInfoDAO;
import com.geniisys.giuts.service.GIUTS023BeneficiaryInfoService;

public class GIUTS023BeneficiaryInfoServiceImpl implements GIUTS023BeneficiaryInfoService{

	private GIUTS023BeneficiaryInfoDAO giuts023BeneficiaryInfoDAO;
	
	@SuppressWarnings("unused")
	private GIUTS023BeneficiaryInfoDAO giuts023BeneficiaryInfoDAO(){
		return giuts023BeneficiaryInfoDAO;	
	}
	
	public void setGiuts023BeneficiaryInfoDAO(GIUTS023BeneficiaryInfoDAO giuts023BeneficiaryInfoDAO){
		this.giuts023BeneficiaryInfoDAO = giuts023BeneficiaryInfoDAO;
	}
	
	@Override
	public Map<String, Object> populateGIUTS023ItemInfoTableGrid(HttpServletRequest request)throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "populateGIUTS023ItemInfoTableGrid");
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> itemInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		return itemInfoTableGrid;
	}

	@Override
	public Map<String, Object> populateGIUTS023GroupedItemsInfoTableGrid(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "populateGIUTS023GroupedItemsInfoTableGrid");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		Map<String, Object> groupedItemsInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		return groupedItemsInfoTableGrid;
	}
	

	@Override
	public List<Map<String, Object>> getGIUTS023GroupedItems(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIUTS023GroupedItems");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return giuts023BeneficiaryInfoDAO.getGIUTS023GroupedItems(params);
	}
	
	@Override
	public List<Map<String, Object>> getGIUTS023BeneficiaryNos(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		return giuts023BeneficiaryInfoDAO.getGIUTS023BeneficiaryNos(params);
	}

	@Override
	public void populateDropDownLists(Map<String, Object> params) throws SQLException, JSONException {
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("APPLICATION_CONTEXT");
		LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		String[] civilStat = {"CIVIL STATUS"};
		request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
		request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
	}

	@Override
	public String validateGroupedItemNo(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "GIUTS023ValidateGroupedItemNo");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		return giuts023BeneficiaryInfoDAO.validateGroupedItemNo(params);
	}
	
	@Override
	public String validateBeneficiaryNo(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "GIUTS023ValidateBeneficiaryNo");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("beneficiaryNo", request.getParameter("beneficiaryNo"));
		return giuts023BeneficiaryInfoDAO.validateBeneficiarymNo(params);
	}
	
	@Override
	public Map<String, Object> populateGIUTS023beneficiaryInfoTableGrid( HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "populateGIUTS023beneficiaryInfoTableGrid");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		Map<String, Object> beneficiaryInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		return beneficiaryInfoTableGrid;
	}

	@Override
	public String saveGIUTS023(String parameters, Map<String, Object> params) throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRowsGI", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRowsGI")), (String)params.get("userId"), GIPIGroupedItems.class));
		allParams.put("delRowsGI", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRowsGI")), (String)params.get("userId"), GIPIGroupedItems.class));
		allParams.put("setRowsBen", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRowsBen")), (String)params.get("userId"), GIPIGrpItemsBeneficiary.class));
		allParams.put("delRowsBen", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRowsBen")), (String)params.get("userId"), GIPIGrpItemsBeneficiary.class));
		giuts023BeneficiaryInfoDAO.saveGIUTS023(allParams);
		return null;
	}

	@Override
	public String showOtherCert(String lineCd)
			throws SQLException {
		return giuts023BeneficiaryInfoDAO.showOtherCert(lineCd);
	}
}
