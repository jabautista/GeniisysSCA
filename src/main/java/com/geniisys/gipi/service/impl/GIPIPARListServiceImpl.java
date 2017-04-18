/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.apache.tools.ant.types.CommandlineJava.SysProperties;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIPARListDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.giri.entity.GIRIWInPolbas;
import com.ibatis.sqlmap.client.SqlMapException;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIPARListServiceImpl.
 */
public class GIPIPARListServiceImpl implements GIPIPARListService{

	/** The gipi par list dao. */
	private GIPIPARListDAO gipiPARListDAO;
	private static Logger log = Logger.getLogger(GIPIPARListService.class);
	
	/**
	 * Gets the gipi par list dao.
	 * 
	 * @return the gipi par list dao
	 */
	public GIPIPARListDAO getGipiPARListDAO() {
		return gipiPARListDAO;
	}

	/**
	 * Sets the gipi par list dao.
	 * 
	 * @param gipiPARListDAO the new gipi par list dao
	 */
	public void setGipiPARListDAO(GIPIPARListDAO gipiPARListDAO) {
		this.gipiPARListDAO = gipiPARListDAO;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#saveGIPIPAR(com.geniisys.gipi.entity.GIPIPARList)
	 */
	@Override
	public GIPIPARList saveGIPIPAR(GIPIPARList gipiPar) throws SqlMapException, SQLException {
		log.info("saveGIPIPAR");
		Integer parId = gipiPar.getParId();
		if (0 == parId){
			parId = this.getGipiPARListDAO().getNewParId();
			gipiPar.setParId(parId);
		}
		else {
			parId = gipiPar.getParId();
		}
		this.getGipiPARListDAO().saveGIPIPAR(gipiPar);
		GIPIPARList savedPAR = this.getGipiPARListDAO().getGIPIPARDetails(parId);
		return savedPAR;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getGIPIPARDetails(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GIPIPARList getGIPIPARDetails(Integer parId, Integer packParId) throws SQLException {
		log.info("getGIPIPARDetails(parId=" + parId + "," + packParId + ")");
		return this.getGipiPARListDAO().getGIPIPARDetails(parId, packParId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getGIPIPARDetails(java.lang.Integer)
	 */
	@Override
	public GIPIPARList getGIPIPARDetails(Integer parId) throws SQLException {
		log.info("getGIPIPARDetails(parId=" + parId + ")");
		return (GIPIPARList) StringFormatter.escapeHTMLInObject(this.getGipiPARListDAO().getGIPIPARDetails(parId));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getGipiParList(java.lang.String, int, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGipiParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException {
		log.info("");
		List<GIPIPARList> parList = this.getGipiPARListDAO().getGipiParList(lineCd, keyword, userId);
		PaginatedList parListing = new PaginatedList(parList, ApplicationWideParameters.PAGE_SIZE);
		parListing.gotoPage(pageNo - 1);
		return parListing;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#checkParQuote(java.lang.Integer)
	 */
	@Override
	public String checkParQuote(Integer parId) throws SQLException {
		return this.gipiPARListDAO.checkParQuote(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#updateStatusFromQuote(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void updateStatusFromQuote(Integer quoteId, Integer parStatus)
			throws SQLException {
		this.getGipiPARListDAO().updateStatusFromQuote(quoteId, parStatus);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#insertParHist(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public void insertParHist(Integer parId, String userId, String entrySource,
			String parstatCd) throws SQLException {
		this.getGipiPARListDAO().insertParHist(parId, userId, entrySource, parstatCd);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#deleteBill(java.lang.Integer)
	 */
	@Override
	public void deleteBill(Integer parId) throws SQLException {
		this.getGipiPARListDAO().deleteBill(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#setParStatusToWithPeril(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void setParStatusToWithPeril(Integer parId, Integer packParId)
			throws SQLException {
		this.getGipiPARListDAO().setParStatusToWithPeril(parId, packParId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#setParStatusToWithPeril(java.lang.Integer)
	 */
	@Override
	public void setParStatusToWithPeril(Integer parId) throws SQLException {
		this.getGipiPARListDAO().setParStatusToWithPeril(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#updatePARStatus(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void updatePARStatus(Integer parId, Integer parStatus)
			throws SQLException {
		this.getGipiPARListDAO().updatePARStatus(parId, parStatus);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getEndtParList(java.lang.String, int, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getEndtParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException {
		List<GIPIPARList> endtParList = this.getGipiPARListDAO().getEndtParList(lineCd, keyword, userId);
		PaginatedList endtParListing = new PaginatedList(endtParList, ApplicationWideParameters.PAGE_SIZE);
		endtParListing.gotoPage(pageNo-1);
		return endtParListing;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getParNo(java.lang.Integer)
	 */
	@Override
	public String getParNo(Integer parId) throws SQLException {		
		return this.getGipiPARListDAO().getParNo(parId);
	}

	public String getParNo2(Integer policyId) throws SQLException {
		return this.getGipiPARListDAO().getParNo2(policyId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#copyParList(java.util.Map)
	 */
	@Override
	//public void copyParList(Map<String, Object> params) throws SQLException, Exception {
	public String copyParList(Map<String, Object> params) throws SQLException, Exception {
		return this.getGipiPARListDAO().copyParList(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#deletePar(java.util.Map)
	 */
	@Override
	public void deletePar(Map<String, Object> params) throws SQLException,
			Exception {
		this.getGipiPARListDAO().deletePar(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#saveParCreationPageChanges(java.util.Map)
	 */
	@Override
	public Map<String, Object> saveParCreationPageChanges(
			Map<String, Object> params) throws SQLException, Exception {
		return this.getGipiPARListDAO().saveParCreationPageChanges(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#returnPARToQuotation(int)
	 */
	@Override
	public void returnPARToQuotation(int quoteId) throws SQLException {
		this.getGipiPARListDAO().returnPARToQuotation(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#cancelPar(java.util.Map)
	 */
	@Override
	public void cancelPar(Map<String, Object> params) throws SQLException,
			Exception {
		this.getGipiPARListDAO().cancelPar(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getGipiParListing(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiParListing(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareParListDetailFilter((String) params.get("filter"), (String) params.get("riSwitch")));
		List<GIPIPARList> list = this.getGipiPARListDAO().getGipiParListing(params);
		params.put("rows", new JSONArray((List<GIPIPARList>)StringFormatter.escapeHTMLInList4(list)));  // replaced by by Kenenth L. for PHILFIRE SR 0014299 to handle \u000e
		//params.put("rows", new JSONArray((List<GIPIPARList>)StringFormatter.escapeHTMLInList(list)));  // andrew - 02.24.2011 - replaced replaceQuotesInList with escapeHTML
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @param riSwitch
	 * @return
	 * @throws JSONException
	 */
	private GIPIPARList prepareParListDetailFilter(String filter, String riSwitch) throws JSONException{
		GIPIPARList parList = new GIPIPARList();
		JSONObject jsonParListFilter = null;
		
		if(null == filter){
			jsonParListFilter = new JSONObject();
		}else{
			jsonParListFilter = new JSONObject(filter);
		}
		System.out.println("riSwitch: "+riSwitch);
		if ("Y".equals(riSwitch)) {
			parList.setIssCd("RI");
			System.out.println("IN");
		}   else {
			parList.setIssCd(jsonParListFilter.isNull("issCd") ? ""		:	jsonParListFilter.getString("issCd").toUpperCase());
		}
		parList.setParYy(jsonParListFilter.isNull("parYy") ? null	:	jsonParListFilter.getInt("parYy"));
		parList.setParSeqNo(jsonParListFilter.isNull("parSeqNo") ? null	:	jsonParListFilter.getInt("parSeqNo"));
		parList.setQuoteSeqNo(jsonParListFilter.isNull("quoteSeqNo") ? null:	jsonParListFilter.getInt("quoteSeqNo"));
		parList.setAssdName(jsonParListFilter.isNull("assdName") ? "":	jsonParListFilter.getString("assdName"));
		parList.setUnderwriter(jsonParListFilter.isNull("underwriter") ? "":	jsonParListFilter.getString("underwriter"));
		parList.setStatus(jsonParListFilter.isNull("status") ? "":				jsonParListFilter.getString("status"));
		parList.setBankRefNo(jsonParListFilter.isNull("bankRefNo")?"":		jsonParListFilter.getString("bankRefNo"));
		return parList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#checkRITablesBeforePARDeletion(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> checkRITablesBeforePARDeletion(Integer parId)
			throws SQLException {
		return this.getGipiPARListDAO().checkRITablesBeforePARDeletion(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#updateParRemarks(org.json.JSONArray)
	 */
	@Override
	public void updateParRemarks(JSONArray updatedRows) throws SQLException,
			JSONException {
		List<GIPIPARList> parList = prepareParListForUpdate(updatedRows);
		this.getGipiPARListDAO().updateParRemarks(parList);
	}
	
	/**
	 * 
	 * @param updatedRows
	 * @return
	 * @throws JSONException
	 */
	private List<GIPIPARList> prepareParListForUpdate(JSONArray updatedRows) throws JSONException{
		List<GIPIPARList> parList = new ArrayList<GIPIPARList>();
		GIPIPARList par;
		if(updatedRows != null){
			for(int i=0; i<updatedRows.length(); i++){
				par = new GIPIPARList();
				par.setParId(updatedRows.getJSONObject(i).isNull("parId")? null : updatedRows.getJSONObject(i).getInt("parId"));
				par.setRemarks(updatedRows.getJSONObject(i).isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(updatedRows.getJSONObject(i).getString("remarks")));
			
				parList.add(par);
			}
		}
		return parList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getPackItemParList(java.lang.Integer, java.lang.String)
	 */
	@Override
	public List<GIPIPARList> getPackItemParList(Integer packParId, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId);
		params.put("lineCd", lineCd);
		log.info("Retrieving pack item par list...");		
		return this.getGipiPARListDAO().getPackItemParList(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getAllPackItemParList(java.lang.Integer, java.lang.String)
	 */
	@Override
	public List<GIPIPARList> getAllPackItemParList(Integer packParId, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId);
		params.put("lineCd", lineCd);
		log.info("Retrieving pack item par list...");		
		return this.getGipiPARListDAO().getAllPackItemParList(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#checkParlistDependency(java.lang.Integer)
	 */
	@Override
	public String checkParlistDependency(Integer inspNo) throws SQLException {
		return this.getGipiPARListDAO().checkParlistDependency(inspNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getParAssuredList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getParAssuredList(HashMap<String, Object> params) throws SQLException {

		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPARList> parAssuredlist = this.getGipiPARListDAO().getParAssuredList(params);
		params.put("rows", new JSONArray((List<GIPIPARList>)StringFormatter.escapeHTMLInList(parAssuredlist)));
		grid.setNoOfPages(parAssuredlist);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#saveRIPar(java.lang.String, java.lang.String, int, java.lang.String)
	 */
	@Override
	public Map<String, Object> saveRIPar(String param, String userId, int mode, String parType)
			throws SQLException, JSONException, ParseException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject objParams = new JSONObject(param);
	
		if(mode==0) {
			//params.put("preparedPar", this.prepareRIParams(objParams, userId, parType));
			params.put("fromQuote", "N");
		}
		params.put("preparedPar", this.prepareRIParams(objParams, userId, parType));
		params.put("setWInPolbas", this.prepareWInPolbas2(new JSONObject(objParams.getString("wInPolbas")), userId));
		params = this.getGipiPARListDAO().saveInitialAcceptance(params, mode);
		return params;
	}
	
	private GIPIPARList prepareRIParams(JSONObject obj, String userId, String parType) throws JSONException {
		Debug.print("Prepare RI Params -- "+obj);
		GIPIPARList par = new GIPIPARList();
		if(obj != null) {
			System.out.println("entered here");
			par.setIssCd(obj.isNull("issCd") ? null : obj.getString("issCd"));
			par.setLineCd(obj.isNull("lineCd") ? null : obj.getString("lineCd"));
			par.setParYy(obj.isNull("parYy") ? null : obj.getInt("parYy"));
			par.setQuoteSeqNo(obj.isNull("quoteSeqNo") ? null : obj.getInt("quoteSeqNo"));
			par.setUnderwriter(userId);
			par.setAssdNo(obj.isNull("assdNo") ? null : obj.getInt("assdNo"));
			par.setRemarks(obj.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(obj.getString("remarks")));//added by steven 10/12/2012
			par.setParType(obj.isNull("parType") ? null : parType);
			par.setParId(obj.isNull("parId") ? null : (obj.getString("parId") == "" ? 0 : obj.getInt("parId")));
			par.setParSeqNo(obj.isNull("parSeqNo") ? null : obj.getInt("parSeqNo"));
			par.setQuoteId((obj.isNull("quoteId") || "".equals(obj.getString("quoteId")) || 
					"0".equals(obj.getString("quoteId"))) ? null : obj.getInt("quoteId"));
			par.setAddress1(obj.isNull("address1") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address1")));	//added by steven 10/12/2012
			par.setAddress1(obj.isNull("address2") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address2")));//added by steven 10/12/2012
			par.setAddress1(obj.isNull("address3") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address3")));//added by steven 10/12/2012
			par.setUserId(userId);
		}
		return par;
	}
	
	private Map<String, Object> prepareWInPolbas2(JSONObject obj, String userId) throws JSONException {
		Map<String, Object> newObj = new HashMap<String, Object>();
		Debug.print("Prepare WInpolbas params - "+obj);
		if (obj != null) {
			newObj.put("acceptBy", obj.isNull("acceptBy") ? userId : obj.getString("acceptBy"));
			newObj.put("acceptNo", obj.isNull("acceptNo") ? null : (obj.getString("acceptNo") == "" ? 0 : obj.getInt("acceptNo")));
			newObj.put("refAcceptNo", obj.isNull("refAcceptNo") ? null : obj.getString("refAcceptNo"));	
			newObj.put("parId", obj.isNull("parId") ? null : (obj.getString("parId") == "" ? 0 : obj.getInt("parId")));
			newObj.put("riCd", obj.isNull("riCd") ? null : obj.getInt("riCd"));
			newObj.put("acceptDate", obj.isNull("acceptDate") ? null : obj.getString("acceptDate"));
			newObj.put("riPolicyNo", obj.isNull("riPolicyNo") ? null : obj.getString("riPolicyNo"));
			newObj.put("riEndtNo", obj.isNull("riEndtNo") ? null : obj.getString("riEndtNo"));
			newObj.put("riBinderNo", obj.isNull("riBinderNo") ? null : obj.getString("riBinderNo"));
			newObj.put("writerCd", obj.isNull("writerCd") ? null : (obj.getString("writerCd").equals("") ? null : obj.getInt("writerCd")));
			newObj.put("offerDate", obj.isNull("offerDate") ? null : (obj.getString("offerDate").equals("") ? null : obj.getString("offerDate")));
			newObj.put("origTsiAmt", obj.isNull("origTsiAmt") ? null : 
					(obj.getString("origTsiAmt").equals("") ? null : new BigDecimal(obj.getString("origTsiAmt"))));
			newObj.put("origPremAmt", obj.isNull("origPremAmt") ? null : 
					(obj.getString("origPremAmt").equals("") ? null : new BigDecimal(obj.getString("origPremAmt"))));
			newObj.put("remarks", obj.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(obj.getString("remarks"))); //added StringEscapeUtils.unescapeHtml - christian 04/16/2013
			newObj.put("offeredBy", obj.isNull("offeredBy") ? null : StringEscapeUtils.unescapeHtml(obj.getString("offeredBy"))); //added StringEscapeUtils.unescapeHtml - christian 04/16/2013
			newObj.put("amountOffered", obj.isNull("amountOffered") ? null : 
				(obj.getString("amountOffered").equals("") ? null : new BigDecimal(obj.getString("amountOffered"))));
			newObj.put("updateCedant", obj.isNull("updateCedant") ? null : obj.getString("updateCedant")); // bonok :: 10.03.2014 :: if 'Y' cedant is changed
			System.out.println("Test offer date - " + 
					(obj.getString("offerDate")) + " / " + obj.getString("acceptDate"));
		}
		return newObj; 
	}
	
	/**
	 * 
	 * @param obj
	 * @param userId
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	@SuppressWarnings("unused")
	private GIRIWInPolbas prepareWInPolbas(JSONObject obj, String userId) throws JSONException, ParseException {
		GIRIWInPolbas newObj = new GIRIWInPolbas();
		Debug.print("Prepare WInpolbas params - "+obj);
		DateFormat df = new SimpleDateFormat("mm-dd-yyyy");
		if (obj != null) {
			newObj.setAcceptBy(obj.isNull("acceptBy") ? userId : obj.getString("acceptBy"));
			newObj.setAcceptNo(obj.isNull("acceptNo") ? null : (obj.getString("acceptNo") == "" ? 0 : obj.getInt("acceptNo")));
			newObj.setRefAcceptNo(obj.isNull("refAcceptNo") ? null : obj.getString("refAcceptNo"));	
			newObj.setParId(obj.isNull("parId") ? null : (obj.getString("parId") == "" ? 0 : obj.getInt("parId")));
			newObj.setRiCd(obj.isNull("riCd") ? null : obj.getInt("riCd"));
			newObj.setAcceptDate(obj.isNull("acceptDate") ? null : obj.getString("acceptDate"));
			newObj.setRiPolicyNo(obj.isNull("riPolicyNo") ? null : obj.getString("riPolicyNo"));
			newObj.setRiEndtNo(obj.isNull("riEndtNo") ? null : obj.getString("riEndtNo"));
			newObj.setRiBinderNo(obj.isNull("riBinderNo") ? null : obj.getString("riBinderNo"));
			newObj.setWriterCd(obj.isNull("writerCd") ? null : (obj.getString("writerCd").equals("") ? null : obj.getInt("writerCd")));
			newObj.setOfferDate(obj.isNull("offerDate") ? null : (obj.getString("offerDate")/*.equals("") ? null : df.parse(obj.getString("offerDate"))*/));
			newObj.setOrigTsiAmt(obj.isNull("origTsiAmt") ? null : 
					(obj.getString("origTsiAmt").equals("") ? null : new BigDecimal(obj.getString("origTsiAmt"))));
			newObj.setOrigPremAmt(obj.isNull("origPremAmt") ? null : 
					(obj.getString("origPremAmt").equals("") ? null : new BigDecimal(obj.getString("origPremAmt"))));
			newObj.setRemarks(obj.isNull("remarks") ? null : obj.getString("remarks"));
			newObj.setOfferedBy(obj.isNull("offeredBy") ? null : obj.getString("offeredBy"));
			newObj.setAmountOffered(obj.isNull("amountOffered") ? null : 
				(obj.getString("amountOffered").equals("") ? null : new BigDecimal(obj.getString("amountOffered"))));
			
			System.out.println("Test offer date - " + 
					df.parse(obj.getString("offerDate")));
		}
		System.out.println("prepareWInPolbas ::: "+newObj.getAcceptNo()+" / "+newObj.getOrigTsiAmt()+
				" / "+newObj.getAcceptDate()+" / "+newObj.getOfferDate());
		return newObj;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getPackPolicyList(java.lang.Integer)
	 */
	@Override
	public List<GIPIPARList> getPackPolicyList(Integer packParId)
			throws SQLException {
		return this.gipiPARListDAO.getPackPolicyList(packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPARListService#getParEndorsementTypeList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getParEndorsementTypeList(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPARList> parEndorsementTypelist = this.getGipiPARListDAO().getParEndorsementTypeList(params);
		params.put("rows", new JSONArray((List<GIPIPARList>)StringFormatter.escapeHTMLInList(parEndorsementTypelist)));
		grid.setNoOfPages(parEndorsementTypelist);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public List<GIPIPARList> getParListGIPIS031A(Integer packParId)
			throws SQLException {
		return this.getGipiPARListDAO().getParListGIPIS031A(packParId);
	}

	public Map<String, Object> copyParToParGiuts007(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPARListDAO().copyParToParGiuts007(params);
	}
	
	public List<GIPIPARList> getParStatusGiuts007(HashMap<String, Object> params)
			throws SQLException {
		return this.getGipiPARListDAO().getParStatusGiuts007(params);
	}
	
	@Override
	public Integer generateParIdGiuts008a() throws SQLException {
		return this.getGipiPARListDAO().generateParIdGiuts008a();
	}

	@Override
	public Map<String, Object> insertParListGiuts008a(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPARListDAO().insertParListGiuts008a(params);
	}

	@Override
	public String getSharePercentageGipis085(Integer parId) throws SQLException {
		return this.getGipiPARListDAO().getSharePercentageGipis085(parId);
	}

	@Override
	public Integer whenNewFormInstGipis017B(Integer parId) throws SQLException {
		return this.getGipiPARListDAO().whenNewFormInstGipis017B(parId);
	}
	
	public JSONObject getParListGIPIS211(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParListGIPIS211");
		params.put("globalParId", request.getParameter("globalParId"));
		params.put("globalLineCd", request.getParameter("globalLineCd")); 
		params.put("userId", userId);
		
		Map<String, Object> parListing = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonParList = new JSONObject(parListing);
		return jsonParList;
	}
	
	public JSONObject getParVehiclesGIPIS211(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParVehiclesGIPIS211");
		params.put("parId", request.getParameter("parId"));
		params.put("parStatus", request.getParameter("parStatus"));
		
		Map<String, Object> parVehicleListing = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonParVehicleList = new JSONObject(parVehicleListing);
		return jsonParVehicleList;
	}
	
	public JSONObject getParVehicleItemsGIPIS211(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParVehicleItemsGIPIS211");
		params.put("nbtLineCd", request.getParameter("nbtLineCd"));
		params.put("nbtPlateNo", request.getParameter("nbtPlateNo"));
		params.put("nbtSerialNo", request.getParameter("nbtSerialNo"));
		params.put("nbtMotorNo", request.getParameter("nbtMotorNo"));
		
		Map<String, Object> parVehicleItems = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonParVehicleItems = new JSONObject(parVehicleItems);
		return jsonParVehicleItems;
	}

	@Override
	public String checkForPostedBinder(Integer parId) throws SQLException {
		return this.getGipiPARListDAO().checkForPostedBinder(parId);
	}

	@Override
	public String checkIfInvoiceExistsRI(Integer parId) throws SQLException {
		return this.getGipiPARListDAO().checkIfInvoiceExistsRI(parId);
	}

	@Override
	public void recreateWInvoiceGiris005(Integer parId) throws SQLException {
		this.getGipiPARListDAO().recreateWInvoiceGiris005(parId);
	}
	
	@Override
	public Map<String, Object> checkAllowCancel(Integer parId)
			throws SQLException {
		return this.getGipiPARListDAO().checkAllowCancel(parId);
	}
}