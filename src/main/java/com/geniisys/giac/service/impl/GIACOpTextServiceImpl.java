package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACOpTextDAO;
import com.geniisys.giac.entity.GIACOpText;
import com.geniisys.giac.service.GIACOpTextService;
import com.seer.framework.util.StringFormatter;

public class GIACOpTextServiceImpl implements GIACOpTextService{

	public GIACOpTextDAO giacOpTextDAO;

	public GIACOpTextDAO getGiacOpTextDAO() {
		return giacOpTextDAO;
	}

	public void setGiacOpTextDAO(GIACOpTextDAO giacOpTextDAO) {
		this.giacOpTextDAO = giacOpTextDAO;
	}

	@Override
	public List<GIACOpText> getGIACOpText(Integer gaccTranId) throws SQLException {
		return this.giacOpTextDAO.getGIACOpText(gaccTranId);
	}

	@Override
	public HashMap<String, Object> whenNewFormsInsGIACS025(Integer gaccTranId)
			throws SQLException {
		return this.giacOpTextDAO.whenNewFormsInsGIACS025(gaccTranId);
	}

	@Override
	public String saveORPreview(String parameters, String userId) throws JSONException,
			SQLException {
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACOpText.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIACOpText.class));
		System.out.println(allParams);
		return this.giacOpTextDAO.saveORPreview(allParams);
	}

	@Override
	public List<GIACOpText> prepareGIACOpTextJSON(JSONArray rows, String userId)
			throws JSONException {
		GIACOpText opText = null;
		List<GIACOpText> list = new ArrayList<GIACOpText>();
		for(int index=0; index<rows.length(); index++) {
			opText = new GIACOpText();
			opText.setGaccTranId(rows.getJSONObject(index).isNull("gaccTranId") || rows.getJSONObject(index).get("gaccTranId").equals("") ? null : rows.getJSONObject(index).getInt("gaccTranId"));
			opText.setItemSeqNo(rows.getJSONObject(index).isNull("itemSeqNo") || rows.getJSONObject(index).get("itemSeqNo").equals("") ? null : rows.getJSONObject(index).getInt("itemSeqNo"));
			opText.setPrintSeqNo(rows.getJSONObject(index).isNull("printSeqNo") || rows.getJSONObject(index).get("printSeqNo").equals("") ? null : rows.getJSONObject(index).getInt("printSeqNo"));
			opText.setItemAmt(rows.getJSONObject(index).isNull("itemAmt") || rows.getJSONObject(index).get("itemAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(index).getString("itemAmt")));
			opText.setItemGenType(rows.getJSONObject(index).isNull("itemGenType") ? null :rows.getJSONObject(index).getString("itemGenType"));
			opText.setItemText(rows.getJSONObject(index).isNull("itemText") ? null :rows.getJSONObject(index).getString("itemText"));
			opText.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd") || rows.getJSONObject(index).get("currencyCd").equals("") ? null : rows.getJSONObject(index).getInt("currencyCd"));
			opText.setLine(rows.getJSONObject(index).isNull("line") ? null :rows.getJSONObject(index).getString("line"));
			opText.setBillNo(rows.getJSONObject(index).isNull("billNo") ? null :rows.getJSONObject(index).getString("billNo"));
			opText.setOrPrintTag(rows.getJSONObject(index).isNull("orPrintTag") ? null :rows.getJSONObject(index).getString("orPrintTag"));
			opText.setForeignCurrAmt(rows.getJSONObject(index).isNull("foreignCurrAmt") || rows.getJSONObject(index).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(index).getString("foreignCurrAmt")));
			opText.setCpiRecNo(rows.getJSONObject(index).isNull("cpiRecNo") || rows.getJSONObject(index).get("cpiRecNo").equals("") ? null :rows.getJSONObject(index).getInt("cpiRecNo"));
			opText.setCpiBranchCd(rows.getJSONObject(index).isNull("cpiBranchCd") ? null :rows.getJSONObject(index).getString("cpiBranchCd"));
			opText.setColumnNo(rows.getJSONObject(index).isNull("columnNo") || rows.getJSONObject(index).get("columnNo").equals("") ? null : rows.getJSONObject(index).getInt("columnNo"));
			opText.setUserId(userId);
			list.add((GIACOpText) StringFormatter.replaceQuoteTagIntoQuotesInObject(opText));
		}
		return list;
	}

	@Override
	public List<GIACOpText> generateParticulars(Integer gaccTranId)
			throws SQLException {
		return this.giacOpTextDAO.generateParticulars(gaccTranId);
	}

	@Override
	public HashMap<String, Object> checkInsertTaxCollnsGIACS025(
			HashMap<String, Object> insertTax) throws SQLException {
		return this.giacOpTextDAO.checkInsertTaxCollnsGIACS025(insertTax);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIACOpTextTableGrid(
			HashMap<String, Object> params) throws SQLException, JSONException, ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("filter", this.prepareGIACOpTextFilter((String) params.get("filter")));
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACOpText> list = this.giacOpTextDAO.getGIACOpTextTableGrid(params);
		
		params.put("rows", new JSONArray()); //added by robert 
		for (Object o: list) { 
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<GIACOpText>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<GIACOpText>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		
		//params.put("rows", new JSONArray((List<GIACOpText>) StringFormatter.replaceQuotesInList(list))); removed by robert
		
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		//for sum of amounts not included in the current page
		params = sumAmountsORPreview(params);
		return params;
	}
	
	public Map<String, Object> prepareGIACOpTextFilter(String filter) throws JSONException, ParseException{
		Map<String, Object> opTextFilter = new HashMap<String, Object>();
		JSONObject jsonOpTextFilter = null;
		
		if(null == filter){
			jsonOpTextFilter = new JSONObject();
		}else{
			jsonOpTextFilter = new JSONObject(filter);
		}
		
		opTextFilter.put("printSeqNo", jsonOpTextFilter.isNull("printSeqNo") ? null : jsonOpTextFilter.getString("printSeqNo"));
		opTextFilter.put("itemGenType", jsonOpTextFilter.isNull("itemGenType") ? null : jsonOpTextFilter.getString("itemGenType"));
		opTextFilter.put("line", jsonOpTextFilter.isNull("line") ? null : jsonOpTextFilter.getString("line"));
		opTextFilter.put("itemText", jsonOpTextFilter.isNull("itemText") ? null : jsonOpTextFilter.getString("itemText"));
		opTextFilter.put("columnNo", jsonOpTextFilter.isNull("columnNo") ? null : jsonOpTextFilter.getString("columnNo"));
		opTextFilter.put("billNo", jsonOpTextFilter.isNull("billNo") ? null : jsonOpTextFilter.getString("billNo"));
		opTextFilter.put("itemAmt", jsonOpTextFilter.isNull("itemAmt") ? null : jsonOpTextFilter.getString("itemAmt"));
		opTextFilter.put("dspCurrSname", jsonOpTextFilter.isNull("dspCurrSname") ? null : jsonOpTextFilter.getString("dspCurrSname"));
		opTextFilter.put("foreignCurrAmt", jsonOpTextFilter.isNull("foreignCurrAmt") ? null : jsonOpTextFilter.getString("foreignCurrAmt"));
		
		return opTextFilter;
	}

	@Override
	public HashMap<String, Object> genSeqNos(HashMap<String, Object> map)
			throws SQLException {
		return this.giacOpTextDAO.genSeqNos(map);
	}

	@Override
	public String checkPrintSeqNoORPreview(HashMap<String, Object> map)
			throws SQLException {
		return this.giacOpTextDAO.checkPrintSeqNoORPreview(map);
	}

	@Override
	public HashMap<String, Object> sumAmountsORPreview(
			HashMap<String, Object> params) throws SQLException {
		return this.giacOpTextDAO.sumAmountsORPreview(params);
	}

	@Override
	public HashMap<String, Object> validatePrintOP(HashMap<String, Object> map)
			throws SQLException {
		return this.giacOpTextDAO.validatePrintOP(map);
	}

	@Override
	public Map<String, Object> newFormInstanceGIACS050(Map<String, Object> params) throws SQLException {
		params = this.getGiacOpTextDAO().newFormInstanceGIACS050(params);
		return params;
	}

	@Override
	public String checkVATOR(int tranId, String branchCd, String fundCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", tranId);
		params.put("branchCd", branchCd);
		params.put("fundCd", fundCd);
		return this.getGiacOpTextDAO().checkVATOR(params);
	}

	@Override
	public HashMap<String, Object> validateORForPrint(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOpTextDAO().validateORForPrint(params);
	}

	@Override
	public List<Integer> getPrintSeqNoList(Integer gaccTranId)
			throws SQLException {
		return this.getGiacOpTextDAO().getPrintSeqNoList(gaccTranId);
	}

	@Override
	public List<Integer> getItemSeqNoList(Integer gaccTranId)
			throws SQLException {
		return this.getGiacOpTextDAO().getItemSeqNoList(gaccTranId);
	}

	@Override
	public void adjustOpTextOndDiscrep(Map<String, Object> params)
			throws SQLException {
		this.getGiacOpTextDAO().adjustOpTextOndDiscrep(params);
	}

	@Override
	public String validateORAcctgEntries(HttpServletRequest request)
			throws SQLException {
		String paramName = request.getParameter("paramName");
		return this.getGiacOpTextDAO().validateORAcctgEntries(paramName);
	}

	@Override
	public String validateBalanceAcctgEntrs(Integer gaccTranId)
			throws SQLException {
		return this.getGiacOpTextDAO().validateBalanceAcctgEntrs(gaccTranId);
	}
	
	//added john 10.24.2014
	@Override
	public void adjDocStampsGiacs025(Map<String, Object> params)
			throws SQLException {
		this.getGiacOpTextDAO().adjDocStampsGiacs025(params);
	}
	
	//added john 7.1.2015
	@Override
	public void recomputeOpText(Map<String, Object> params)
			throws SQLException {
		this.getGiacOpTextDAO().recomputeOpText(params);
	}

}
