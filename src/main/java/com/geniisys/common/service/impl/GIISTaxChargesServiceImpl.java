package com.geniisys.common.service.impl;

import java.math.BigDecimal; // dren 09.21.2015 SR: 0020311 - To include BigDecimal
import java.sql.SQLException;
import java.util.ArrayList; // dren 09.21.2015 SR: 0020311 - To include ArrayList
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTaxChargesDAO;
import com.geniisys.common.entity.GIISTaxCharges;
import com.geniisys.common.service.GIISTaxChargesService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISTaxChargesServiceImpl implements GIISTaxChargesService{

	private GIISTaxChargesDAO giisTaxChargesDAO;

	public void setGiisTaxChargesDAO(GIISTaxChargesDAO giisTaxChargesDAO) {
		this.giisTaxChargesDAO = giisTaxChargesDAO;
	}

	public GIISTaxChargesDAO getGiisTaxChargesDAO() {
		return giisTaxChargesDAO;
	}
	
	@Override
	public JSONObject showGiiss028(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss028RecList");		
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("issCd", request.getParameter("issCd"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));
		this.giisTaxChargesDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss028(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTaxCharges.class)); // dren 09.21.2015 SR: 0020311 - Comment out
		params.put("setRows", this.prepareTaxChargeForInsert(new JSONArray(request.getParameter("setRows")), userId)); // dren 09.21.2015 SR: 0020311 - Modified to pass the correct rate value
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTaxCharges.class));
		params.put("appUser", userId);
		this.giisTaxChargesDAO.saveGiiss028(params);
	}
	
	private List<GIISTaxCharges> prepareTaxChargeForInsert(JSONArray setRows, String userId) // dren 09.21.2015 SR: 0020311 - Added to pass the correct rate value - Start
			throws JSONException {
			List<GIISTaxCharges> taxChargeList = new ArrayList<GIISTaxCharges>();
			GIISTaxCharges taxCharge = null;
			JSONObject dcbObj = null;
			
			for(int i = 0; i<setRows.length(); i++) {
				taxCharge = new GIISTaxCharges();
				dcbObj = setRows.getJSONObject(i);
				
				taxCharge.setRemarks(dcbObj.isNull("remarks") ? null : dcbObj.getString("remarks"));
				taxCharge.setIssCd(dcbObj.isNull("issCd") ? null : dcbObj.getString("issCd"));
				taxCharge.setTaxType(dcbObj.isNull("taxType") ? null : dcbObj.getString("taxType"));
				taxCharge.setStrLastUpdate(dcbObj.isNull("strLastUpdate") ? null : dcbObj.getString("strLastUpdate"));
				taxCharge.setMaxSequence(dcbObj.isNull("maxSequence") ? null : dcbObj.getInt("maxSequence"));
				taxCharge.setTempTaxAmt(dcbObj.isNull("tempTaxAmt") ? null : new BigDecimal(dcbObj.getString("tempTaxAmt")));
				taxCharge.setAllocationTag(dcbObj.isNull("allocationTag") ? null : dcbObj.getString("allocationTag"));
				taxCharge.setEffStartDate(dcbObj.isNull("effStartDate") ? null : dcbObj.getString("effStartDate"));
				taxCharge.setEffEndDate(dcbObj.isNull("effEndDate") ? null : dcbObj.getString("effEndDate"));
				taxCharge.setIncludeTag(dcbObj.isNull("includeTag") ? null : dcbObj.getString("includeTag"));
				taxCharge.setTakeupAllocTag(dcbObj.isNull("takeupAllocTag") ? null : dcbObj.getString("takeupAllocTag"));
				taxCharge.setIssueDateTag(dcbObj.isNull("issueDateTag") ? null : dcbObj.getString("issueDateTag"));
				taxCharge.setLineCd(dcbObj.isNull("lineCd") ? null : dcbObj.getString("lineCd"));
				taxCharge.setFunctionName(dcbObj.isNull("functionName") ? null : dcbObj.getString("functionName"));
				taxCharge.setMaxTaxId(dcbObj.isNull("maxTaxId") ? null : dcbObj.getInt("maxTaxId"));
				taxCharge.setPerilSw(dcbObj.isNull("perilSw") ? null : dcbObj.getString("perilSw"));
				taxCharge.setPrimarySw(dcbObj.isNull("primarySw") ? null : dcbObj.getString("primarySw"));
				taxCharge.setNoRateTag(dcbObj.isNull("noRateTag") ? null : dcbObj.getString("noRateTag"));
				taxCharge.setDrGlCd(dcbObj.isNull("drGlCd") || dcbObj.get("drGlCd").equals("") ? null : dcbObj.getInt("drGlCd"));
				taxCharge.setCrGlCd(dcbObj.isNull("crGlCd") || dcbObj.get("crGlCd").equals("") ? null : dcbObj.getInt("crGlCd"));
				taxCharge.setDrSub1(dcbObj.isNull("drSub1") || dcbObj.get("drSub1").equals("") ? null : dcbObj.getInt("drSub1"));
				taxCharge.setCrSub1(dcbObj.isNull("crSub1") || dcbObj.get("crSub1").equals("") ? null : dcbObj.getInt("crSub1"));
				taxCharge.setInceptSw(dcbObj.isNull("inceptSw") ? null : dcbObj.getString("inceptSw"));
				taxCharge.setExpiredSw(dcbObj.isNull("expiredSw") ? null : dcbObj.getString("expiredSw"));
				taxCharge.setPolEndtSw(dcbObj.isNull("polEndtSw") ? null : dcbObj.getString("polEndtSw"));
				taxCharge.setCocCharge(dcbObj.isNull("cocCharge") ? null : dcbObj.getString("cocCharge"));
				taxCharge.setStrExists(dcbObj.isNull("strExists") ? null : dcbObj.getString("strExists"));
				taxCharge.setPerilCd(dcbObj.isNull("perilCd") || dcbObj.get("perilCd").equals("") ? null : dcbObj.getInt("perilCd"));
				taxCharge.setTaxCd(dcbObj.isNull("taxCd") || dcbObj.get("taxCd").equals("") ? null : dcbObj.getInt("taxCd"));
				taxCharge.setTaxDesc(dcbObj.isNull("taxDesc") ? null : dcbObj.getString("taxDesc"));
				taxCharge.setTaxId(dcbObj.isNull("taxId") || dcbObj.get("taxId").equals("") ? null : dcbObj.getInt("taxId"));
					if (dcbObj.get("rate").equals("0.000000000")){
						taxCharge.setRate(new BigDecimal(0));
					} else {
						taxCharge.setRate(dcbObj.isNull("rate") || dcbObj.get("rate").equals("") ? null : new BigDecimal(dcbObj.getString("rate")));
					}						
				taxCharge.setTaxAmount(dcbObj.isNull("taxAmount") || dcbObj.get("taxAmount").equals("") ? null : new BigDecimal(dcbObj.getString("taxAmount")));
				taxCharge.setId(dcbObj.isNull("id") ? null : dcbObj.getString("id"));
				taxCharge.setSequence(dcbObj.isNull("sequence") || dcbObj.get("sequence").equals("") ? null : dcbObj.getInt("sequence"));
				taxCharge.setRefundSw(dcbObj.isNull("refundSw") ? null : dcbObj.getString("refundSw")); //added by robert SR 20574, 20576 10.07.15
				taxChargeList.add(taxCharge);
				taxCharge = null;				
			}			
			return taxChargeList;
		} // dren 09.21.2015 SR: 0020311 - Modified to pass the correct rate value - End	

	@Override
	public String valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("taxCd", request.getParameter("taxCd"));
		return giisTaxChargesDAO.valAddRec(params);
	}

	@Override
	public String valDateOnAdd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("effStartDate", request.getParameter("effStartDate"));
		params.put("effEndDate", request.getParameter("effEndDate"));
		params.put("taxId", request.getParameter("taxId"));
		params.put("tran", request.getParameter("tran"));
		return giisTaxChargesDAO.valDateOnAdd(params);
	}

	@Override
	public void valSeqOnAdd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sequence", request.getParameter("sequence"));
		this.giisTaxChargesDAO.valSeqOnAdd(params);
	}

	@Override
	public List<GIISTaxCharges> getGiisTaxCharges(HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();	//Gzelle 10282014
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("issCd", request.getParameter("issCd"));
		return this.giisTaxChargesDAO.getGiisTaxCharges(param);
	}
}
