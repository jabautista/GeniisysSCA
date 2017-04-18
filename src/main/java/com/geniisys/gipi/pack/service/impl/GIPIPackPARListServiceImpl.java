package com.geniisys.gipi.pack.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.pack.dao.GIPIPackPARListDAO;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.giri.entity.GIRIPackWInPolbas;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIPIPackPARListServiceImpl implements GIPIPackPARListService {

	private GIPIPackPARListDAO gipiPackPARListDAO;
	private static Logger log = Logger.getLogger(GIPIPackPARListServiceImpl.class);
	
	public GIPIPackPARListDAO getGipiPackPARListDAO(){
		return gipiPackPARListDAO;
		
	}
	@Override
	public GIPIPackPARList saveGIPIPackPar(GIPIPackPARList gipiPackPar) throws SQLException {
		Integer packParId = gipiPackPar.getPackParId();
		
		if (0 == packParId){
			packParId = this.getGipiPackPARListDAO().getNewPackParId();
			gipiPackPar.setPackParId(packParId);
			log.info("Generated new pack_par_id: " + packParId);
		}
		else {
			packParId = gipiPackPar.getPackParId();
		}
		this.getGipiPackPARListDAO().saveGipiPackPAR(gipiPackPar);
		
		GIPIPackPARList savedPackPAR = this.getGipiPackPARListDAO().getGIPIPackParDetails(packParId);
	
		return savedPackPAR;
		
	}
	
	@Override
	public GIPIPackPARList saveGIPIPackPar(Map<String, Object> params)
			throws SQLException {
		GIPIPackPARList gipiPackPar = (GIPIPackPARList) params.get("preparedPackPar");
		Integer packParId = gipiPackPar.getPackParId();
		
		if (0 == packParId){
			packParId = this.getGipiPackPARListDAO().getNewPackParId();
			gipiPackPar.setPackParId(packParId);
			log.info("Generated new pack_par_id: " + packParId);
		}
		else {
			packParId = gipiPackPar.getPackParId();
		}
		
		
		//GIPIPackPARList savedPackPAR = this.getGipiPackPARListDAO().getGIPIPackParDetails(packParId); moved to saveGipiPackPAR(Map<String, Object> params)
	
		return this.getGipiPackPARListDAO().saveGipiPackPAR(params);
	}
	
	
	@Override
	public GIPIPackPARList getGIPIPackParDetails(Integer packParId) throws SQLException {
		return (GIPIPackPARList) StringFormatter.escapeHTMLInObject(this.getGipiPackPARListDAO().getGIPIPackParDetails(packParId)); //change by steven 10.17.2013 from:replaceQuotesInObject  to:escapeHTMLInObject
	}
	
	public void setGipiPackPARListDAO(GIPIPackPARListDAO gipiPackPARListDAO) {
		this.gipiPackPARListDAO = gipiPackPARListDAO;
	}
	
	@Override
	public void updatePackStatusFromQuote(Integer quoteId, Integer parStatus)
			throws SQLException {
		this.gipiPackPARListDAO.updatePackStatusFromQuote(quoteId, parStatus);
		
	}
	@Override
	public String checkPackParQuote(Integer packParId) throws SQLException {
		return this.gipiPackPARListDAO.checkPackParQuote(packParId);
	}
	@Override
	public String checkIfLineSublineExist(Map<String, Object> params) throws SQLException {
		
		String message = null;
		
		Log.info("Checking line and subline. . .");
		Map<String, Object> checkParams = this.getGipiPackPARListDAO().checkIfLineSublineExist(params);
		message = (String) checkParams.get("message");
		return message;
	}
	@Override
	public void createParListWPack(Map<String, Object> params)
			throws SQLException {
		this.getGipiPackPARListDAO().createParListWPack(params);
	}
	
	@Override
	public JSONArrayList getGipiPackParList(String lineCd, int pageNo, String keyword, String userId) 
			throws SQLException {
		List<GIPIPackPARList> packParList = this.getGipiPackPARListDAO().getGipiPackParList(lineCd, keyword, userId);
		//PaginatedList packParListing = new PaginatedList(packParList, ApplicationWideParameters.PAGE_SIZE);
		//packParListing.gotoPage(pageNo - 1); commented by: nica 11.22.2010
		JSONArrayList packParListing = new JSONArrayList(packParList , pageNo);
		return packParListing;
	}
	
	@Override
	public void deletePackPar(Map<String, Object> params) throws SQLException,
			Exception {
		this.getGipiPackPARListDAO().deletePackPar(params);
	}
	@Override
	public Map<String, Object> checkRITablesBeforeDeletion(Integer packParId)
			throws SQLException {
		return this.getGipiPackPARListDAO().checkRITablesBeforeDeletion(packParId);
	}
	@Override
	public void cancelPackPar(Map<String, Object> params) throws SQLException,
			Exception {
		this.getGipiPackPARListDAO().cancelPackPar(params);
	}
	@Override
	public JSONArrayList getGipiEndtPackParList(String lineCd, int pageNo,
			String keyword, String userId) throws SQLException {
		List<GIPIPackPARList> packEndtParList = this.getGipiPackPARListDAO().getGipiEndtPackParList(lineCd, keyword, userId);
		//PaginatedList packEndtParListing = new PaginatedList(packEndtParList, ApplicationWideParameters.PAGE_SIZE);
		//packEndtParListing.gotoPage(pageNo - 1); commented by: nica 11.22.2010
		JSONArrayList packEndtParListing = new JSONArrayList(packEndtParList, pageNo);
		return packEndtParListing;
	}
	
	@Override
	public void updatePackParRemarks(JSONArray updatedRows)
			throws SQLException, JSONException {
		try{
			List<GIPIPackPARList> packParList = preparePackParListForUpdate(updatedRows);
			this.getGipiPackPARListDAO().updatePackParRemarks(packParList);
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}catch (JSONException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}
	}
	
	private List<GIPIPackPARList> preparePackParListForUpdate(JSONArray updatedRows) throws JSONException{
		List<GIPIPackPARList> packParList = new ArrayList<GIPIPackPARList>();
		GIPIPackPARList packPar;
		try{
			if(updatedRows != null){
				for(int i=0; i<updatedRows.length(); i++){
					packPar = new GIPIPackPARList();
					packPar.setPackParId(updatedRows.getJSONObject(i).isNull("packParId") ? null : updatedRows.getJSONObject(i).getInt("packParId"));
					packPar.setRemarks(updatedRows.getJSONObject(i).isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(updatedRows.getJSONObject(i).getString("remarks")));
					
					packParList.add(packPar);
				}
			
			}
			return packParList;
		}catch(JSONException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiPackParListing(
			HashMap<String, Object> params) throws SQLException, JSONException {
/*		Integer page = (Integer) params.get("currentPage") == null ? 1 : (Integer) params.get("currentPage");
		Integer pageSize = ApplicationWideParameters.PAGE_SIZE;
		TableGridUtil grid = new TableGridUtil(page, pageSize);
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPackPARList> packParList = this.getGipiPackPARListDAO().getGipiPackParListing(params);
		List<GIPIPackPARList> returnedList = new ArrayList<GIPIPackPARList>();
		
		int startRec = (page-1) * pageSize;
		int endRec = (pageSize * page - 1) < packParList.size()-1 ? pageSize * page - 1 : packParList.size()-1; 
		for (int i=startRec; i<=endRec; i++){
			returnedList.add(packParList.get(i));
		}
		double total = (float) packParList.size() / (float) pageSize;
		int finalTotal = (int) Math.ceil(total);
		
		params.put("rows", new JSONArray((List<GIPIPackPARList>)StringFormatter.replaceQuotesInList(returnedList)));
		params.put("pages", finalTotal);
		params.put("total", packParList.size());*/
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.preparePackParListDetailFilter((String) params.get("filter"), (String) params.get("riSwitch")));
		List<GIPIPackPARList> list = this.getGipiPackPARListDAO().getGipiPackParListing(params);
		params.put("rows", new JSONArray((List<GIPIPackPARList>) StringFormatter.escapeHTMLJavascriptInList(list))); // andrew - 02.24.2011 - replaced replaceQuotesInList with escapeHTML
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}
	
	private GIPIPackPARList preparePackParListDetailFilter(String filter, String riSwitch) throws JSONException{
		GIPIPackPARList packParList = new GIPIPackPARList();
		JSONObject jsonPackParListFilter = null;
		
		if(null == filter){
			jsonPackParListFilter = new JSONObject();
		}else{
			jsonPackParListFilter = new JSONObject(filter);
		}
		if ("Y".equals(riSwitch)) {
			packParList.setIssCd("RI"); 	
		} else {	
			packParList.setIssCd(jsonPackParListFilter.isNull("issCd") ? "" : jsonPackParListFilter.getString("issCd").toUpperCase());
		}
		packParList.setParYy(jsonPackParListFilter.isNull("parYy") ? null : jsonPackParListFilter.getInt("parYy"));
		packParList.setParSeqNo(jsonPackParListFilter.isNull("parSeqNo") ? null : jsonPackParListFilter.getInt("parSeqNo"));
		packParList.setQuoteSeqNo(jsonPackParListFilter.isNull("quoteSeqNo") ? null : jsonPackParListFilter.getInt("quoteSeqNo"));
		packParList.setAssdName(jsonPackParListFilter.isNull("assdName") ? "" : jsonPackParListFilter.getString("assdName"));
		packParList.setUnderwriter(jsonPackParListFilter.isNull("underwriter") ? "" : jsonPackParListFilter.getString("underwriter"));
		packParList.setStatus(jsonPackParListFilter.isNull("status") ? "" : jsonPackParListFilter.getString("status"));
		packParList.setBankRefNo(jsonPackParListFilter.isNull("bankRefNo") ? "" : jsonPackParListFilter.getString("bankRefNo"));
		return packParList;
	}
	@Override
	public Map<String, Object> saveRIPackPar(Map<String, Object> params, String userId) throws SQLException, JSONException,
			ParseException, Exception {
		//Map<String, Object> params = new HashMap<String, Object>();
		String parameters = (String) params.get("parameters");
		JSONObject objParams = new JSONObject(parameters);
		params.put("preparedRIPackPar", preparePackRIParams(objParams, userId, (String) params.get("parType")));
		params.put("gipiPackWInPolbas", this.prepareGIRIPackWInPolbas(new JSONObject(objParams.getString("packWInPolbas")), userId));
		params.put("userId", userId);
		params = getGipiPackPARListDAO().savePackInitialAcceptance(params);
		return params;
	}
	
	private GIPIPackPARList preparePackRIParams(JSONObject obj, String userId, String parType) throws JSONException {
		Debug.print("Preparing RI Pack Params -- "+obj);
		GIPIPackPARList gipiPackPARList = new GIPIPackPARList();
		gipiPackPARList.setIssCd(obj.isNull("issCd") ? null : obj.getString("issCd"));
		gipiPackPARList.setLineCd(obj.isNull("lineCd") ? null : obj.getString("lineCd"));
		gipiPackPARList.setParYy(obj.isNull("parYy") ? null : obj.getInt("parYy"));
		gipiPackPARList.setQuoteSeqNo(obj.isNull("quoteSeqNo") ? null : obj.getInt("quoteSeqNo"));
		gipiPackPARList.setUnderwriter(userId);
		gipiPackPARList.setAssdNo(obj.isNull("assdNo") ? null : obj.getInt("assdNo"));
		gipiPackPARList.setRemarks(obj.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(obj.getString("remarks")));
		gipiPackPARList.setParType(obj.isNull("parType") ? null : parType);
		gipiPackPARList.setPackParId(obj.isNull("packParId") ? null : (obj.getString("packParId") == "" ? 0 : obj.getInt("packParId")));
		gipiPackPARList.setParSeqNo(obj.isNull("parSeqNo") ? null : obj.getInt("parSeqNo"));
		gipiPackPARList.setAddress1(obj.isNull("address1") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address1")));
		gipiPackPARList.setAddress1(obj.isNull("address2") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address2")));
		gipiPackPARList.setAddress1(obj.isNull("address3") ? null : StringEscapeUtils.unescapeHtml(obj.getString("address3")));
		gipiPackPARList.setUserId(userId);
		return gipiPackPARList;
	}
	
	private GIRIPackWInPolbas prepareGIRIPackWInPolbas(JSONObject obj, String userId)throws JSONException {
		Debug.print("Preparing GIPIPackWInPolbas -- "+obj);
		GIRIPackWInPolbas giriPackWInPolbas = new GIRIPackWInPolbas();
		giriPackWInPolbas.setAcceptBy(obj.isNull("acceptBy") ? userId : StringEscapeUtils.unescapeHtml(obj.getString("acceptBy")));
		giriPackWInPolbas.setPackAcceptNo(obj.isNull("packAcceptNo") ? null : (obj.getString("packAcceptNo") == "" ? 0 : obj.getInt("packAcceptNo")));
		giriPackWInPolbas.setRefAcceptNo(obj.isNull("refAcceptNo") ? null : StringEscapeUtils.unescapeHtml(obj.getString("refAcceptNo")));	
		giriPackWInPolbas.setPackParId(obj.isNull("packParId") ? null : (obj.getString("packParId") == "" ? 0 : obj.getInt("packParId")));
		giriPackWInPolbas.setRiCd(obj.isNull("riCd") ? null : obj.getInt("riCd"));
		giriPackWInPolbas.setAcceptDate(obj.isNull("acceptDate") ? null : obj.getString("acceptDate"));
		giriPackWInPolbas.setRiPolicyNo(obj.isNull("riPolicyNo") ? null : StringEscapeUtils.unescapeHtml(obj.getString("riPolicyNo")));
		giriPackWInPolbas.setRiEndtNo(obj.isNull("riEndtNo") ? null : StringEscapeUtils.unescapeHtml(obj.getString("riEndtNo")));
		giriPackWInPolbas.setRiBinderNo(obj.isNull("riBinderNo") ? null : StringEscapeUtils.unescapeHtml(obj.getString("riBinderNo")));
		giriPackWInPolbas.setWriterCd(obj.isNull("writerCd") ? null : (obj.getString("writerCd").equals("") ? null : obj.getInt("writerCd")));
		giriPackWInPolbas.setOfferDate(obj.isNull("offerDate") ? null : (obj.getString("offerDate")/*.equals("") ? null : df.parse(obj.getString("offerDate"))*/));
		giriPackWInPolbas.setOrigTsiAmt(obj.isNull("origTsiAmt") ? null : 
				(obj.getString("origTsiAmt").equals("") ? null : new BigDecimal(obj.getString("origTsiAmt"))));
		giriPackWInPolbas.setOrigPremAmt(obj.isNull("origPremAmt") ? null : 
				(obj.getString("origPremAmt").equals("") ? null : new BigDecimal(obj.getString("origPremAmt"))));
		giriPackWInPolbas.setRemarks(obj.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(obj.getString("remarks")));
		giriPackWInPolbas.setRiSName(obj.isNull("riSName") ? null : StringEscapeUtils.unescapeHtml(obj.getString("riSName")));
		giriPackWInPolbas.setRiSName2(obj.isNull("riSName2") ? null : StringEscapeUtils.unescapeHtml(obj.getString("riSName2")));
		giriPackWInPolbas.setUserId(userId);
		
		return giriPackWInPolbas;
	}
	@Override
	public Integer generatePackParIdGiuts008a() throws SQLException {
		return this.getGipiPackPARListDAO().generatePackParIdGiuts008a();
	}
	@Override
	public HashMap<String, Object> getPackParListGiuts008a(Integer packPolicyId)
			throws SQLException {
		return (HashMap<String, Object>) this.getGipiPackPARListDAO().getPackParListGiuts008a(packPolicyId);
	}
	@Override
	public void insertPackParListGiuts008a(Map<String, Object> params)
			throws SQLException {
		this.getGipiPackPARListDAO().insertPackParListGiuts008a(params);
	}
	@Override
	public String getPackSharePercentage(Integer packParId) throws SQLException {
		return this.getGipiPackPARListDAO().getPackSharePercentage(packParId);
	}
	@Override
	public String checkGipis095PackPeril(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("parId", request.getParameter("parId"));
		return getGipiPackPARListDAO().checkGipis095PackPeril(params);
	}
}


