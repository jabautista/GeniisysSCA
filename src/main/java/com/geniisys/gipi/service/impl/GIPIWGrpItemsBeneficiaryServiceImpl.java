package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWGrpItemsBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.geniisys.gipi.service.GIPIWGrpItemsBeneficiaryService;
import com.geniisys.gipi.util.DateFormatter;
import com.seer.framework.util.StringFormatter;

public class GIPIWGrpItemsBeneficiaryServiceImpl implements GIPIWGrpItemsBeneficiaryService{
	
	private GIPIWGrpItemsBeneficiaryDAO gipiWGrpItemsBeneficiaryDAO;

	public GIPIWGrpItemsBeneficiaryDAO getGipiWGrpItemsBeneficiaryDAO() {
		return gipiWGrpItemsBeneficiaryDAO;
	}

	public void setGipiWGrpItemsBeneficiaryDAO(
			GIPIWGrpItemsBeneficiaryDAO gipiWGrpItemsBeneficiaryDAO) {
		this.gipiWGrpItemsBeneficiaryDAO = gipiWGrpItemsBeneficiaryDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary(
			Integer parId, Integer itemNo) throws SQLException {
		return (List<GIPIWGrpItemsBeneficiary>) StringFormatter.replaceQuotesInList(this.gipiWGrpItemsBeneficiaryDAO.getGipiWGrpItemsBeneficiary(parId, itemNo));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary2(
			Integer parId) throws SQLException {
		//return (List<GIPIWGrpItemsBeneficiary>) StringFormatter.replaceQuotesInList(this.gipiWGrpItemsBeneficiaryDAO.getGipiWGrpItemsBeneficiary2(parId));
		return this.gipiWGrpItemsBeneficiaryDAO.getGipiWGrpItemsBeneficiary2(parId); //replaced by: Mark C. 04152015 SR4302
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIWGrpItemsBeneficiary> getRetGipiWGrpItemsBeneficiary(
			Map<String, Object> params) throws SQLException{
		//return (List<GIPIWGrpItemsBeneficiary>) StringFormatter.replaceQuotesInList(this.gipiWGrpItemsBeneficiaryDAO.getRetGipiWGrpItemsBeneficiary(params));
		return this.gipiWGrpItemsBeneficiaryDAO.getRetGipiWGrpItemsBeneficiary(params); //replaced by: Mark C. 04152015 SR4302
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWGrpItemsBeneficiaryForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delList = new ArrayList<Map<String, Object>>();
		JSONObject objWGrpItemsBen = null;
		Map<String, Object> delMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			delMap = new HashMap<String, Object>();
			objWGrpItemsBen = delRows.getJSONObject(i);
			
			delMap.put("parId", objWGrpItemsBen.isNull("parId") ? null : objWGrpItemsBen.getInt("parId"));
			delMap.put("itemNo", objWGrpItemsBen.isNull("itemNo") ? null : objWGrpItemsBen.getInt("itemNo"));
			delMap.put("groupedItemNo", objWGrpItemsBen.isNull("groupedItemNo") ? null : objWGrpItemsBen.getInt("groupedItemNo"));
			delMap.put("beneficiaryNo", objWGrpItemsBen.isNull("beneficiaryNo") ? null : objWGrpItemsBen.getString("beneficiaryNo"));
			
			delList.add(delMap);
			delMap = null;
		}
		
		return delList;
	}

	@Override
	public List<GIPIWGrpItemsBeneficiary> prepareGIPIWGrpItemsBeneficiaryForInsertUpdate(
			JSONArray setRows) throws JSONException, ParseException {
		List<GIPIWGrpItemsBeneficiary> beneficiaryList = new ArrayList<GIPIWGrpItemsBeneficiary>();
		GIPIWGrpItemsBeneficiary beneficiary = null;
		JSONObject objBeneficiary = null;
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i < length; i++){
			beneficiary = new GIPIWGrpItemsBeneficiary();
			objBeneficiary = setRows.getJSONObject(i);
			
			beneficiary.setParId(objBeneficiary.isNull("parId") ? null : objBeneficiary.getInt("parId"));
			beneficiary.setItemNo(objBeneficiary.isNull("itemNo") ? null : objBeneficiary.getInt("itemNo"));
			beneficiary.setGroupedItemNo(objBeneficiary.isNull("groupedItemNo") ? null : objBeneficiary.getString("groupedItemNo"));
			beneficiary.setBeneficiaryNo(objBeneficiary.isNull("beneficiaryNo") ? null : objBeneficiary.getString("beneficiaryNo"));
			beneficiary.setBeneficiaryName(objBeneficiary.isNull("beneficiaryName") ? null : StringEscapeUtils.unescapeHtml(objBeneficiary.getString("beneficiaryName")));
			beneficiary.setBeneficiaryAddr(objBeneficiary.isNull("beneficiaryAddr") ? null : StringEscapeUtils.unescapeHtml(objBeneficiary.getString("beneficiaryAddr")));
			beneficiary.setRelation(objBeneficiary.isNull("relation") ? null : StringEscapeUtils.unescapeHtml(objBeneficiary.getString("relation")));
			//beneficiary.setDateOfBirth(objBeneficiary.isNull("dateOfBirth") ? null : sdf.parse(objBeneficiary.getString("dateOfBirth")));
			beneficiary.setDateOfBirth(objBeneficiary.isNull("dateOfBirth") ? null : (objBeneficiary.getString("dateOfBirth").equals("") ? null : DateFormatter.formatDate(objBeneficiary.getString("dateOfBirth"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			beneficiary.setAge(objBeneficiary.isNull("age") ? null : objBeneficiary.getString("age"));
			beneficiary.setCivilStatus(objBeneficiary.isNull("civilStatus") ? null : objBeneficiary.getString("civilStatus"));
			beneficiary.setSex(objBeneficiary.isNull("sex") ? null : objBeneficiary.getString("sex"));
			
			beneficiaryList.add(beneficiary);
			beneficiary = null;
		}
		return beneficiaryList;
	}

	@Override
	public void saveBeneficiaries(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setBenRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setBenRows")), userId, GIPIWGrpItemsBeneficiary.class));
		params.put("delBenRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delBenRows")), userId, GIPIWGrpItemsBeneficiary.class));
		params.put("setPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setPerilRows")), userId, GIPIWItmperlBeneficiary.class));
		params.put("delPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delPerilRows")), userId, GIPIWItmperlBeneficiary.class));
		this.getGipiWGrpItemsBeneficiaryDAO().saveBeneficiaries(params);
	}

	@Override
	public Map<String, Object> validateBenNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("beneficiaryNo", request.getParameter("beneficiaryNo"));
		return this.getGipiWGrpItemsBeneficiaryDAO().validateBenNo(params);
	}
	
	/*added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)*/
	@Override
	public Map<String, Object> validateBenNo2(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("beneficiaryNo", request.getParameter("beneficiaryNo"));
		return this.getGipiWGrpItemsBeneficiaryDAO().validateBenNo2(params);
	}
	/*END SR21720*/
}
