package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACInwFaculPremCollnsDAO;
import com.geniisys.giac.entity.GIACInwFaculPremCollns;
import com.geniisys.giac.service.GIACInwFaculPremCollnsService;
import com.seer.framework.util.StringFormatter;

public class GIACInwFaculPremCollnsServiceImpl implements GIACInwFaculPremCollnsService{

	private GIACInwFaculPremCollnsDAO giacInwFaculPremCollnsDAO;
	private static Logger log = Logger.getLogger(GIACInwFaculPremCollnsServiceImpl.class);
	
	public GIACInwFaculPremCollnsDAO getGiacInwFaculPremCollnsDAO() {
		return giacInwFaculPremCollnsDAO;
	}

	public void setGiacInwFaculPremCollnsDAO(
			GIACInwFaculPremCollnsDAO giacInwFaculPremCollnsDAO) {
		this.giacInwFaculPremCollnsDAO = giacInwFaculPremCollnsDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInwFaculPremCollns> getGIACInwFaculPremCollns(
			Integer gaccTranId, GIISUser user) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", gaccTranId);
		params.put("userId", user.getUserId());
		return (List<GIACInwFaculPremCollns>) StringFormatter.replaceQuotesInObject(giacInwFaculPremCollnsDAO.getGIACInwFaculPremCollns(params));
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getInvoiceList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<Map<String, Object>> invListing = this.giacInwFaculPremCollnsDAO.getInvoiceList(params);
		PaginatedList paginatedList = new PaginatedList(invListing , 100);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	public Map<String, Object> getInvoice(HashMap<String, Object> params) throws SQLException{
		return this.getGiacInwFaculPremCollnsDAO().getInvoice(params);
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getInstNoList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<Map<String, Object>> instNoListing = this.giacInwFaculPremCollnsDAO.getInstNoList(params);
		PaginatedList paginatedList = new PaginatedList(instNoListing , 100);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public String validateInvoice(HashMap<String, Object> params)
			throws SQLException {
		return this.giacInwFaculPremCollnsDAO.validateInvoice(params);
	}

	@Override
	public HashMap<String, Object> validateInstNo(HashMap<String, Object> params)
			throws SQLException {
		return this.giacInwFaculPremCollnsDAO.validateInstNo(params);
	}

	@Override
	public String saveInwardFacul(Map<String, Object> params) throws SQLException {
		return this.giacInwFaculPremCollnsDAO.saveInwardFacul(params);
	}

	@Override
	public List<GIACInwFaculPremCollns> prepareInsertInwItems(
			HttpServletRequest request, HttpServletResponse response,
			GIISUser USER) {
		List<GIACInwFaculPremCollns> inwFaculItems = new ArrayList<GIACInwFaculPremCollns>();
		if(request.getParameterValues("inwFaculGaccTranId") != null){
			log.info("Prepare items for inserting inward facul.");
			String[] inwFaculGaccTranId	= request.getParameterValues("inwFaculGaccTranId");
			String[] inwFaculTransactionType	= request.getParameterValues("inwFaculTransactionType");
			String[] inwFaculA180RiCd	= request.getParameterValues("inwFaculA180RiCd");
			String[] inwFaculB140IssCd	= request.getParameterValues("inwFaculB140IssCd");
			String[] inwFaculB140PremSeqNo	= request.getParameterValues("inwFaculB140PremSeqNo");
			String[] inwFaculInstNo	= request.getParameterValues("inwFaculInstNo");
			String[] inwFaculPremiumAmt	= request.getParameterValues("inwFaculPremiumAmt");
			String[] inwFaculCommAmt	= request.getParameterValues("inwFaculCommAmt");
			String[] inwFaculWholdingTax	= request.getParameterValues("inwFaculWholdingTax");
			String[] inwFaculparticulars	= request.getParameterValues("inwFaculparticulars");
			String[] inwFaculCurrencyCd	= request.getParameterValues("inwFaculCurrencyCd");
			String[] inwFaculConvertRate	= request.getParameterValues("inwFaculConvertRate");
			String[] inwFaculForeignCurrAmt	= request.getParameterValues("inwFaculForeignCurrAmt");
			String[] inwFaculCollectionAmt	= request.getParameterValues("inwFaculCollectionAmt");
			String[] inwFaculOrPrintTag	= request.getParameterValues("inwFaculOrPrintTag");
			String[] inwFaculCpiRecNo	= request.getParameterValues("inwFaculCpiRecNo");
			String[] inwFaculCpiBranchCd	= request.getParameterValues("inwFaculCpiBranchCd");
			String[] inwFaculTaxAmount	= request.getParameterValues("inwFaculTaxAmount");
			String[] inwFaculCommVat	= request.getParameterValues("inwFaculCommVat");
			String[] inwFaculSavedItem = request.getParameterValues("inwFaculSavedItem");
			
			for (int a=0;a<inwFaculGaccTranId.length;a++){
				inwFaculItems.add(new GIACInwFaculPremCollns(Integer.parseInt(inwFaculGaccTranId[a]),Integer.parseInt(inwFaculTransactionType[a]),
						Integer.parseInt(inwFaculA180RiCd[a]),inwFaculB140IssCd[a],Integer.parseInt(inwFaculB140PremSeqNo[a]),
						Integer.parseInt(inwFaculInstNo[a]),
						(inwFaculPremiumAmt[a] == null || inwFaculPremiumAmt[a] == "" ? null : new BigDecimal(inwFaculPremiumAmt[a].replaceAll(",", ""))),
						(inwFaculCommAmt[a] == null || inwFaculCommAmt[a] == "" ? null : new BigDecimal(inwFaculCommAmt[a].replaceAll(",", ""))),
						(inwFaculWholdingTax[a] == null || inwFaculWholdingTax[a] == "" ? null : new BigDecimal(inwFaculWholdingTax[a].replaceAll(",", ""))),
						inwFaculparticulars[a],inwFaculCurrencyCd[a].equals("") ? null :Integer.parseInt(inwFaculCurrencyCd[a]),
						(inwFaculConvertRate[a] == null || inwFaculConvertRate[a] == "" ? null : new BigDecimal(inwFaculConvertRate[a].replaceAll(",", ""))),
						(inwFaculForeignCurrAmt[a] == null || inwFaculForeignCurrAmt[a] == "" ? null : new BigDecimal(inwFaculForeignCurrAmt[a].replaceAll(",", ""))),
						(inwFaculCollectionAmt[a] == null || inwFaculCollectionAmt[a] == "" ? null : new BigDecimal(inwFaculCollectionAmt[a].replaceAll(",", ""))),
						inwFaculOrPrintTag[a],inwFaculCpiRecNo[a].equals("") ? null :Integer.parseInt(inwFaculCpiRecNo[a]),inwFaculCpiBranchCd[a],
						(inwFaculTaxAmount[a] == null || inwFaculTaxAmount[a] == "" ? null : new BigDecimal(inwFaculTaxAmount[a].replaceAll(",", ""))),
						(inwFaculCommVat[a] == null || inwFaculCommVat[a] == "" ? null : new BigDecimal(inwFaculCommVat[a].replaceAll(",", ""))),
						inwFaculSavedItem[a],USER.getUserId()
						));
			}
		}
		return inwFaculItems;
	}
	
	@Override
	public List<GIACInwFaculPremCollns> prepareDelInwItems(HttpServletRequest request, HttpServletResponse response,GIISUser USER){
		List<GIACInwFaculPremCollns> inwFaculDelItems = new ArrayList<GIACInwFaculPremCollns>();
		if(request.getParameterValues("delInwGaccTranId") != null){
			log.info("Prepare items for deleting inward facul.");
			String[] delInwGaccTranId = request.getParameterValues("delInwGaccTranId");	
			String[] delInwTransactionType = request.getParameterValues("delInwTransactionType");
			String[] delInwA180RiCd = request.getParameterValues("delInwA180RiCd");
			String[] delInwB140IssCd = request.getParameterValues("delInwB140IssCd");
			String[] delInwB140PremSeqNo = request.getParameterValues("delInwB140PremSeqNo");
			String[] delInwInstNo = request.getParameterValues("delInwInstNo");
			String[] delInwCollectionAmt = request.getParameterValues("delInwCollectionAmt");
			String[] delInwPremiumAmt = request.getParameterValues("delInwPremiumAmt");
			String[] delInwCommAmt = request.getParameterValues("delInwCommAmt");
			String[] delInwWholdingTax = request.getParameterValues("delInwWholdingTax");
			String[] delInwTaxAmount = request.getParameterValues("delInwTaxAmount");
			String[] delInwCommVat = request.getParameterValues("delInwCommVat");
			for (int a=0;a<delInwGaccTranId.length;a++){
				inwFaculDelItems.add(new GIACInwFaculPremCollns(
						Integer.parseInt(delInwGaccTranId[a]),Integer.parseInt(delInwTransactionType[a]),
						Integer.parseInt(delInwA180RiCd[a]),delInwB140IssCd[a],Integer.parseInt(delInwB140PremSeqNo[a]),
						Integer.parseInt(delInwInstNo[a]),
						(delInwPremiumAmt[a] == null || delInwPremiumAmt[a] == "" ? null : new BigDecimal(delInwPremiumAmt[a].replaceAll(",", ""))),
						(delInwCommAmt[a] == null || delInwCommAmt[a] == "" ? null : new BigDecimal(delInwCommAmt[a].replaceAll(",", ""))),
						(delInwWholdingTax[a] == null || delInwWholdingTax[a] == "" ? null : new BigDecimal(delInwWholdingTax[a].replaceAll(",", ""))),
						"", null, null, null,
						(delInwCollectionAmt[a] == null || delInwCollectionAmt[a] == "" ? null : new BigDecimal(delInwCollectionAmt[a].replaceAll(",", ""))),
						"",null,"",
						(delInwTaxAmount[a] == null || delInwTaxAmount[a] == "" ? null : new BigDecimal(delInwTaxAmount[a].replaceAll(",", ""))),
						(delInwCommVat[a] == null || delInwCommVat[a] == "" ? null : new BigDecimal(delInwCommVat[a].replaceAll(",", ""))),
						"",USER.getUserId()
					));
			}
		}
		return inwFaculDelItems;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRelatedInwFaculPremCollns(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACInwFaculPremCollns> inwFaculList = this.giacInwFaculPremCollnsDAO.getRelatedInwFaculPremCollns(params);
		params.put("rows", new JSONArray((List<GIACInwFaculPremCollns>)StringFormatter.escapeHTMLInList(inwFaculList)));
		grid.setNoOfPages(inwFaculList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getInvoiceListTableGrid(
			HashMap<String, Object> params) throws SQLException, JSONException {
		if ((String) params.get("filter")!=null){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> instNoListing = this.giacInwFaculPremCollnsDAO.getInvoiceListTableGrid(params);
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInListOfMap(instNoListing)));
		grid.setNoOfPages(instNoListing);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	public List<GIACInwFaculPremCollns> getOtherInwFaculPremCollns(Integer gaccTranId) throws SQLException{
		return this.giacInwFaculPremCollnsDAO.getOtherInwFaculPremCollns(gaccTranId);
	}
	
	//added john 11.3.2014
	@Override
	public String checkPremPaytForRiSpecial(HttpServletRequest request)
			throws SQLException {
		HashMap<String, Object> params =  new HashMap<String, Object>();
		params.put("a180RiCd", request.getParameter("a180RiCd"));
		params.put("b140IssCd", request.getParameter("b140IssCd"));
		params.put("transactionType", request.getParameter("transactionType"));
		params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
		return this.giacInwFaculPremCollnsDAO.checkPremPaytForRiSpecial(params);
	}
	
	//added john 11.4.2014
	@Override
	public String checkPremPaytForCancelled(HttpServletRequest request, GIISUser userId)
			throws SQLException {
		HashMap<String, Object> params =  new HashMap<String, Object>();
		params.put("a180RiCd", request.getParameter("a180RiCd"));
		params.put("b140IssCd", request.getParameter("b140IssCd"));
		params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
		params.put("userId", userId.getUserId());
		return this.giacInwFaculPremCollnsDAO.checkPremPaytForCancelled(params);
	}
	
	//added john 2.24.2015
	@Override
	public String validateDelete(HttpServletRequest request) throws SQLException {
		if(request.getParameter("gaccTranId") != null){
			return this.giacInwFaculPremCollnsDAO.validateDelete(request.getParameter("gaccTranId"));
		} else {
			return null;
		}
		
	}
	
	@Override
	public Map<String, Object> updateOrDtls(HttpServletRequest request) throws SQLException { //Deo [01.20.2017]: SR-5909
		HashMap<String, Object> params =  new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("riCd", Integer.parseInt(request.getParameter("riCd")));
		giacInwFaculPremCollnsDAO.updateOrDtls(params);
		return this.giacInwFaculPremCollnsDAO.getUpdatedOrDtls(params);
	}
}
