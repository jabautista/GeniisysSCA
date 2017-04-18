package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACApdcPaytDtlDAO;
import com.geniisys.giac.entity.GIACApdcPaytDtl;
import com.geniisys.giac.service.GIACApdcPaytDtlService;
import com.seer.framework.util.StringFormatter;

public class GIACApdcPaytDtlServiceImpl implements GIACApdcPaytDtlService{

	private GIACApdcPaytDtlDAO giacApdcPaytDtlDAO;
	private static Logger log = Logger.getLogger(GIACApdcPaytDtlServiceImpl.class);
	
	public GIACApdcPaytDtlDAO getGiacApdcPaytDtlDAO() {
		return giacApdcPaytDtlDAO;
	}
	
	public void setGiacApdcPaytDtlDAO(GIACApdcPaytDtlDAO giacApdcPaytDtlDAO) {
		this.giacApdcPaytDtlDAO = giacApdcPaytDtlDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytDtlService#getApdcPaytDtlTableGrid(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getApdcPaytDtlTableGrid(
			Map<String, Object> params) throws SQLException, JSONException {
		log.info("getApdcPaytDtlTableGrid");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		Map<String, Object> filterMap = this.prepareApdcPaytDtlFilter(params.get("filter") == null ? null : params.get("filter").toString());
		params.put("filter", filterMap);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACApdcPaytDtl> list = this.giacApdcPaytDtlDAO.getApdcPaytDtlTableGrid(params);
		params.put("rows", new JSONArray((List<GIACApdcPaytDtl>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());

		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareApdcPaytDtlFilter(String filter) throws JSONException {
		Map<String, Object> apdcPaytDtlMap = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		if (null == filter){
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		apdcPaytDtlMap.put("checkAmt", jsonFilter.isNull("checkAmt") ? "%%" : '%' + jsonFilter.getString("checkAmt").toUpperCase() + '%');
		apdcPaytDtlMap.put("bankSname", jsonFilter.isNull("bankCd") ? "%%" : '%' + jsonFilter.getString("bankCd").toUpperCase() + '%');
		apdcPaytDtlMap.put("bankBranch", jsonFilter.isNull("bankBranch") ? "%%" : '%' + jsonFilter.getString("bankBranch").toUpperCase() + '%');
		apdcPaytDtlMap.put("checkClass", jsonFilter.isNull("checkClass") ? "%%" : '%' + jsonFilter.getString("checkClass").toUpperCase() + '%');
		apdcPaytDtlMap.put("checkDate", jsonFilter.isNull("checkDate") ? "%%" : '%' + jsonFilter.getString("checkDate").toUpperCase() + '%');
		apdcPaytDtlMap.put("currencyName", jsonFilter.isNull("currencyCd") ? "%%" : '%' + jsonFilter.getString("currencyCd").toUpperCase() + '%');
		apdcPaytDtlMap.put("checkStatus", jsonFilter.isNull("checkStatus") ? "%%" : '%' + jsonFilter.getString("checkStatus").toUpperCase() + '%');
		
		return apdcPaytDtlMap;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytDtlService#gpdcPremPostQuery(java.util.Map)
	 */
	public Map<String, Object> gpdcPremPostQuery(Map<String, Object> params) throws SQLException{
		this.giacApdcPaytDtlDAO.gpdcPremPostQuery(params);
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytDtlService#checkGeneratedOR(java.lang.Integer)
	 */
	public String checkGeneratedOR(Integer apdcId) throws SQLException{
		return this.giacApdcPaytDtlDAO.checkGeneratedOR(apdcId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytDtlService#generatePdcId()
	 */
	public Integer generatePdcId() throws SQLException{
		return this.getGiacApdcPaytDtlDAO().generatePdcId();
	}

	@Override
	public Integer getApdcSw(Integer tranId) throws SQLException {
		return this.getGiacApdcPaytDtlDAO().getApdcSw(tranId);
	}
	
	@Override
	public JSONObject showGiacs091(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs091RecList");
		params.put("extractDate", request.getParameter("extractDate"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public void saveGiacs091(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACApdcPaytDtl.class));
		params.put("appUser", userId);
		this.giacApdcPaytDtlDAO.saveGiacs091(StringFormatter.escapeHTMLInMap(params));
	}
	
	public void saveOrParticulars(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcId", request.getParameter("pdcId"));
		params.put("payor", request.getParameter("payor"));
		params.put("address1", request.getParameter("address1"));
		params.put("address2", request.getParameter("address2"));
		params.put("address3", request.getParameter("address3"));
		params.put("tin", request.getParameter("tin"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("particulars", request.getParameter("particulars"));
		params.put("userId", userId);
		//this.giacApdcPaytDtlDAO.saveOrParticulars(StringFormatter.escapeHTMLInMap(params)); removed by jdiago 08.05.2014
		this.giacApdcPaytDtlDAO.saveOrParticulars(params); //added by jdiago 08.05.2014 : needs to escape only if to be displayed in page.
	}
	
	@Override
	public JSONObject showDatedChecksDetails(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDatedChecksDetails");
		params.put("pdcId", request.getParameter("pdcId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public Map<String, Object> multipleOR(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checkDate", request.getParameter("checkDate"));
		params.put("pdcId", request.getParameter("pdcId"));
		params.put("appUser", userId);
		params.put("userId", userId);	//added by albert 10.25.2016 (UCPBGEN SR 23081)
		return this.giacApdcPaytDtlDAO.multipleOR(params);
	}
	
	public Map<String, Object> groupOr(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("group", new JSONArray(request.getParameter("group")));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checkDate", request.getParameter("checkDate"));
		params.put("appUser", userId);
		params.put("userId", userId);	//added by albert 10.25.2016 (UCPBGEN SR 23081)
		return this.giacApdcPaytDtlDAO.groupOr(params);
	}
	
	public Map<String, Object> validateDcbNo(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcId", request.getParameter("pdcId"));
		params.put("appUser", userId);
		params.put("checkDate", request.getParameter("checkDate"));
		return this.giacApdcPaytDtlDAO.validateDcbNo(params);
	}
	
	public void createDbcNo(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcId", request.getParameter("pdcId"));
		params.put("checkDate", request.getParameter("checkDate"));
		params.put("appUser", userId);
		this.giacApdcPaytDtlDAO.createDbcNo(StringFormatter.escapeHTMLInMap(params));
	}
	
	public Map<String, Object> giacs091DefaultBank(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcId", request.getParameter("pdcId"));
		params.put("appUser", userId);
		return this.giacApdcPaytDtlDAO.giacs091DefaultBank(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map <String, Object>> getGiacs091Funds(String userId) throws SQLException {
		return (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(this.giacApdcPaytDtlDAO.getGiacs091Funds(userId));
	}

	@Override
	public String giacs091ValidateTransactionDate(Map<String, Object> params)
			throws SQLException {
		return this.giacApdcPaytDtlDAO.giacs091ValidateTransactionDate(params);
	}
	/*added by MarkS SR-5881 12.14.2016*/
	@Override
	public String giacs091CheckSOABalance(Map<String, Object> params)
			throws SQLException {
		return this.giacApdcPaytDtlDAO.giacs091CheckSOABalance(params);
	}
}
