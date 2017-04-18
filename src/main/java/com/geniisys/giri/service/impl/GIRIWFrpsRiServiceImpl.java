package com.geniisys.giri.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.dao.GIRIWFrpsRiDAO;
import com.geniisys.giri.service.GIRIWFrpsRiService;
import com.seer.framework.util.StringFormatter;
import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;
import com.geniisys.giri.entity.GIRIWFrpsRi;

public class GIRIWFrpsRiServiceImpl implements GIRIWFrpsRiService{
	
	private GIRIWFrpsRiDAO giriWFrpsRiDAO;
	
	public GIRIWFrpsRiDAO getGiriWFrpsRiDAO(){
		return giriWFrpsRiDAO;
	}
	
	public void setGiriWFrpsRiDAO(GIRIWFrpsRiDAO giriWFrpsRiDAO){
		this.giriWFrpsRiDAO = giriWFrpsRiDAO;
	}
	
	@Override
	public String refreshGiriwFrpsRiGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIRIWFrpsRi2");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		params = TableGridUtil.getTableGrid(request, params);
		return new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
	}

	@Override
	public String getWarrDays(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		params = this.giriWFrpsRiDAO.getWarrDays(params);
		return new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getWfrpRiParams(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 5);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIRIWFrpsRi> list = this.getGiriWFrpsRiDAO().getGIRIWFrpsRiList(params);
		params.put("rows", new JSONArray((List<GIRIWFrpsRi>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}


	@Override
	public void saveRiAcceptance(String param, String userId) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("setWFrpsRi", this.prepareWFrpsRiForInsert(new JSONArray(objParams.getString("setFrpsRi")), userId));
		params.put("setWFrpsRi", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setFrpsRi")), userId, GIRIWFrpsRi.class));
		params.put("setFrperil", this.prepareFrperilForInsert(new JSONArray(objParams.getString("setFrperil")), userId));
		System.out.println("saveRiAcceptance "+params);
		this.getGiriWFrpsRiDAO().setRiAcceptance(params);
	}
	
	@SuppressWarnings("unused")
	private List<GIRIWFrpsRi> prepareWFrpsRiForInsert(JSONArray setRows, String userId) throws JSONException, ParseException {
		List<GIRIWFrpsRi> list = new ArrayList<GIRIWFrpsRi>();
		GIRIWFrpsRi ri = null;
		JSONObject riObj = null;
		SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0; i<setRows.length(); i++) {
			ri = new GIRIWFrpsRi();
			riObj = setRows.getJSONObject(i);
			
			ri.setFrpsYy(riObj.isNull("frpsYy") ? 0 : riObj.getInt("frpsYy"));
			ri.setFrpsSeqNo(riObj.isNull("frpsSeqNo") ? 0 : riObj.getInt("frpsSeqNo"));
			ri.setLineCd(riObj.isNull("lineCd") ? null : riObj.getString("lineCd"));
			ri.setRiSeqNo(riObj.isNull("riSeqNo") ? 0 : riObj.getInt("riSeqNo"));
			ri.setRiCd(riObj.isNull("riCd") ? 0 : riObj.getInt("riCd"));
			
			ri.setAddress1(riObj.isNull("address1") ? null : riObj.getString("address1"));
			ri.setAddress2(riObj.isNull("address2") ? null : riObj.getString("address2"));
			ri.setAddress3(riObj.isNull("address3") ? null : riObj.getString("address3"));
			ri.setRemarks(riObj.isNull("remarks") ? null : riObj.getString("remarks"));
			ri.setBndrRemarks1(riObj.isNull("bndrRemarks1") ? null : riObj.getString("bndrRemarks1"));
			ri.setBndrRemarks2(riObj.isNull("bndrRemarks2") ? null : riObj.getString("bndrRemarks2"));
			ri.setBndrRemarks3(riObj.isNull("bndrRemarks3") ? null : riObj.getString("bndrRemarks3"));
			ri.setRiAcceptBy(riObj.isNull("riAcceptBy") ? null : riObj.getString("riAcceptBy"));
			ri.setRiAsNo(riObj.isNull("riAsNo") ? null : riObj.getString("riAsNo"));
			ri.setRiAcceptDate((riObj.isNull("riAcceptDate") || "".equals(riObj.getString("riAcceptDate"))) ? 
					null : df.parse(riObj.getString("riAcceptDate")));
			ri.setRiShrPct(riObj.isNull("riShrPct") ? null : (riObj.getString("riShrPct").equals("") ? 
					null : new BigDecimal(riObj.getString("riShrPct"))));
			ri.setRiPremAmt(riObj.isNull("riPremAmt") ? null : (riObj.getString("riPremAmt").equals("") ? 
					null : new BigDecimal(riObj.getString("riPremAmt"))));
			ri.setRiTsiAmt(riObj.isNull("riTsiAmt") ? null : (riObj.getString("riTsiAmt").equals("") ? 
					null : new BigDecimal(riObj.getString("riTsiAmt"))));
			ri.setRiCommAmt(riObj.isNull("riCommAmt") ? null : (riObj.getString("riCommAmt").equals("") ? 
					null : new BigDecimal(riObj.getString("riCommAmt"))));
			ri.setRiCommRt(riObj.isNull("riCommRt") ? null : (riObj.getString("riCommRt").equals("") ? 
					null : new BigDecimal(riObj.getString("riCommRt"))));
			ri.setRiPremVat(riObj.isNull("riPremVat") ? null : (riObj.getString("riPremVat").equals("") ? 
					null : new BigDecimal(riObj.getString("riPremVat"))));
			ri.setRiCommVat(riObj.isNull("riCommVat") ? null : (riObj.getString("riCommVat").equals("") ? 
					null : new BigDecimal(riObj.getString("riCommVat"))));
			ri.setPremTax(riObj.isNull("premTax") ? null : (riObj.getString("premTax").equals("") ? 
					null : new BigDecimal(riObj.getString("premTax"))));
			ri.setUserId(userId);
		}
		return list;
	}
	
	private List<Map<String, Object>> prepareFrperilForInsert(
			JSONArray setRows, String userId) throws JSONException {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> frPeril = null;
		JSONObject obj = null;
		for(int i=0; i<setRows.length(); i++) {
			frPeril = new HashMap<String, Object>();
			obj = setRows.getJSONObject(i);
			
			frPeril.put("lineCd", obj.isNull("lineCd") ? null : obj.getString("lineCd"));
			frPeril.put("frpsYy", obj.isNull("frpsYy") ? null : obj.getInt("frpsYy"));
			frPeril.put("frpsSeqNo", obj.isNull("frpsSeqNo") ? null : obj.getInt("frpsSeqNo"));
			frPeril.put("riSeqNo", obj.isNull("riSeqNo") ? null : obj.getInt("riSeqNo"));
			frPeril.put("riCd", obj.isNull("riCd") ? null : obj.getInt("riCd"));
			frPeril.put("perilCd", obj.isNull("perilCd") ? null : obj.getInt("perilCd"));
			frPeril.put("riShrPct", obj.isNull("riShrPct") ? null : new BigDecimal(obj.getString("riShrPct")));
			frPeril.put("riTsiAmt", obj.isNull("riTsiAmt") ? null : new BigDecimal(obj.getString("riTsiAmt")));
			frPeril.put("riPremAmt", obj.isNull("riPremAmt") ? null : new BigDecimal(obj.getString("riPremAmt")));
			frPeril.put("annRiSAmt", obj.isNull("annRiSAmt") ? null : new BigDecimal(obj.getString("annRiSAmt")));
			frPeril.put("annRiPct", obj.isNull("annRiPct") ? null : new BigDecimal(obj.getString("annRiPct")));
			frPeril.put("riCommRt", obj.isNull("riCommRt") ? null : obj.getString("riCommRt")); // new BigDecimal(obj.getString("riCommRt"))); modified by christian 09.21.2012
			frPeril.put("riCommAmt", obj.isNull("riCommAmt") ? null : new BigDecimal(obj.getString("riCommAmt")));
			frPeril.put("riPremVat", obj.isNull("riPremVat") ? null : new BigDecimal(obj.getString("riPremVat")));
			frPeril.put("riCommVat", obj.isNull("riCommVat") ? null : new BigDecimal(obj.getString("riCommVat")));
			frPeril.put("premTax", obj.isNull("premTax") ? null : new BigDecimal(obj.getString("premTax")));
			frPeril.put("riCommAmt2", obj.isNull("riCommAmt2") ? null : obj.getString("riCommAmt2"));

			list.add(frPeril);
			frPeril = null;
		}
		System.out.println("TEST prepare ri perils: "+list.size());
		return list;
	}

	@Override
	public String createBinderGiris002(Map<String, Object> params)
			throws SQLException {
		return this.getGiriWFrpsRiDAO().createBindersGiris002(params);
	}

	private Map<String, Object> getAdjustPremVatParams(HttpServletRequest request){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riPremVat", request.getParameter("riPremVat"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("parYy", request.getParameter("parYy"));
		params.put("parSeqNo", request.getParameter("parSeqNo"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		
		return params;
	}
	
	@Override
	public String computeRiPremAmt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params = getAdjustPremVatParams(request);
		params.put("riShrPct", request.getParameter("riShrPct"));
		params.put("riShrPct2", request.getParameter("riShrPct2"));
		//params.put("totFacSpct", request.getParameter("totFacSpct")); // replaced by andrew - 1.4.2012 
		params.put("totFacSpct2", request.getParameter("totFacSpct2"));
		params.put("totFacPrem", request.getParameter("totFacPrem"));
		params = this.giriWFrpsRiDAO.computeRiPremAmt(params);
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String computeRiPremVat1(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params = getAdjustPremVatParams(request);
		params.put("var2Prem", request.getParameter("var2Prem"));
		params = this.giriWFrpsRiDAO.computeRiPremVat1(params);
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String saveRiPlacement(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("userId", USER.getUserId());
		params.put("giriDistFrpsWdistFrpsV", JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giriDistFrpsWdistFrpsV")), USER.getUserId(), GIRIDistFrpsWdistFrpsV.class));
		params.put("giriWFrpsRiSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIRIWFrpsRi.class));
		params.put("giriWFrpsRiDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRows")), USER.getUserId(), GIRIWFrpsRi.class));
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giriWFrpsRiDAO.saveRiPlacement(params))).toString();
	}

	@Override
	public String checkDelRecRiPlacement(String preBinderId) throws SQLException {
		return this.giriWFrpsRiDAO.checkDelRecRiPlacement(preBinderId);
	}

	@Override
	public String getPreviousRiGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiriFrpsRiGrid");
		params.put("distNo", request.getParameter("distNo"));
		params = TableGridUtil.getTableGrid(request, params);
		return new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
	}

	@Override
	public String adjustPremVat(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params = getAdjustPremVatParams(request);
		params = this.giriWFrpsRiDAO.adjustPremVat(params);
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String adjustPremVatGIRIS002(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params = getAdjustPremVatParams(request);
		params.remove("riPremVat");
		params = this.getGiriWFrpsRiDAO().adjustPremVatGIRIS002(params);
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String validateBinderPrinting(Map<String, Object> params)
			throws SQLException {
		return this.getGiriWFrpsRiDAO().validateBinderPrinting(params);
	}

	@Override
	public String validateFrpsPosting(Map<String, Object> params)
			throws SQLException {
		return this.getGiriWFrpsRiDAO().validateFrpsPosting(params);
	}
	@Override
	
	public Map<String, Object> getTsiPremAmt(Map<String, Object> params)
			throws SQLException {
		return this.getGiriWFrpsRiDAO().getTsiPremAmt(params);
	}

	@Override
	public String validateSharePercent(HttpServletRequest request) {
		
		BigDecimal varPercent = new BigDecimal(0);
        BigDecimal var2Percent = new BigDecimal(0);
        BigDecimal sumRiShrPct = new BigDecimal(request.getParameter("sumRiSHrPct"));
        BigDecimal oldValue = new BigDecimal(request.getParameter("oldValue"));
        BigDecimal v100TotFacSpct = new BigDecimal(request.getParameter("v100TotFacSpct"));
        
        varPercent = sumRiShrPct.subtract(oldValue);
        var2Percent = v100TotFacSpct.subtract(varPercent);
        
		return var2Percent.toString();
	}

	@Override
	public String computeRiTsiAmt(HttpServletRequest request) {
		
		BigDecimal riTsiAmt = new BigDecimal(0);
		BigDecimal value = new BigDecimal(request.getParameter("value"));
		BigDecimal v100TotFacSpct = new BigDecimal(request.getParameter("v100TotFacSpct"));
		BigDecimal v100TotFacTsi = new BigDecimal(request.getParameter("v100TotFacTsi"));
		BigDecimal temp = new BigDecimal(0);
		
		temp = value.divide(v100TotFacSpct, 30, RoundingMode.HALF_UP);
		riTsiAmt = temp.multiply(v100TotFacTsi);
		
		return riTsiAmt.toString();
	}
	
}
