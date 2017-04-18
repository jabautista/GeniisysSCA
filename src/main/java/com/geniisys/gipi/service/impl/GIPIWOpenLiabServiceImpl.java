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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWOpenLiabDAO;
import com.geniisys.gipi.entity.GIPIWOpenCargo;
import com.geniisys.gipi.entity.GIPIWOpenLiab;
import com.geniisys.gipi.entity.GIPIWOpenPeril;
import com.geniisys.gipi.service.GIPIWOpenLiabService;


/**
 * The Class GIPIWOpenLiabServiceImpl.
 */
public class GIPIWOpenLiabServiceImpl implements GIPIWOpenLiabService{

	/** The gipi w open liab dao. */
	private GIPIWOpenLiabDAO gipiWOpenLiabDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenLiabServiceImpl.class);
	
	/**
	 * Sets the gipi w open liab dao.
	 * 
	 * @param gipiWOpenLiabDAO the new gipi w open liab dao
	 */
	public void setGipiWOpenLiabDAO(GIPIWOpenLiabDAO gipiWOpenLiabDAO) {
		this.gipiWOpenLiabDAO = gipiWOpenLiabDAO;
	}
	
	/**
	 * Gets the gipi w open liab dao.
	 * 
	 * @return the gipi w open liab dao
	 */
	public GIPIWOpenLiabDAO getGipiWOpenLiabDAO() {
		return gipiWOpenLiabDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenLiabService#getWOpenLiab(int)
	 */
	@Override
	public GIPIWOpenLiab getWOpenLiab(int parId) throws SQLException {
		
		log.info("Retrieving WOpenLiab...");
		GIPIWOpenLiab wopenLiab = this.getGipiWOpenLiabDAO().getWOpenLiab(parId); 
		log.info("WOpenLiab retrieved");
		
		return wopenLiab;
	}

	@Override
	public boolean deleteWOpenLiab(int parId, int geogCd) throws SQLException {
		
		log.info("Deleting GIPIWOpenLiab...");
		this.getGipiWOpenLiabDAO().deleteWOpenLiab(parId, geogCd);
		log.info("GIPIWOpenLiab deleted.");
		
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean saveLimitOfLiability(Map<String, Object> params)
			throws Exception {
		GIPIWOpenLiab wopenLiab = this.prepareWOpenLiab((Map<String, Object>) params.get("insWOpenLiab")); 
		List<GIPIWOpenCargo> wopenCargos = this.prepareWOpenCargo((Map<String, Object>) params.get("insWOpenCargo"));
		List<GIPIWOpenPeril> wopenPerils = this.prepareWOpenPeril((Map<String, Object>) params.get("insWOpenPeril"));
		Map<String, Object> postParams   = this.preparePostParams(wopenLiab, (Map<String, Object>) params.get("checkParams"));
		
		Map<String, Object> preparedParams = new HashMap<String, Object>();
		preparedParams.put("delWOpenLiab", params.get("delWOpenLiab"));
		preparedParams.put("wopenLiab", wopenLiab);
		preparedParams.put("delWOpenCargo", params.get("delWOpenCargo"));
		preparedParams.put("wopenCargos", wopenCargos);
		preparedParams.put("delWOpenPeril", params.get("delWOpenPeril"));
		preparedParams.put("wopenPerils", wopenPerils);
		preparedParams.put("checkParams", params.get("checkParams"));
		preparedParams.put("postParams", postParams);
		
		this.getGipiWOpenLiabDAO().saveLimitOfLiability(preparedParams);
		
		return true;
	}
	
	private GIPIWOpenLiab prepareWOpenLiab(Map<String, Object> insWOpenLiab) throws SQLException{
		
		int parId 					= (Integer) insWOpenLiab.get("parId");
		int geogCd 					= (Integer) insWOpenLiab.get("geogCd");
		int currencyCd				= (Integer) insWOpenLiab.get("currencyCd");
		BigDecimal currencyRate 	= (BigDecimal) insWOpenLiab.get("currencyRate");
		BigDecimal limitOfLiability = (BigDecimal) insWOpenLiab.get("limitOfLiability");
		String voyLimit 			= (String) insWOpenLiab.get("voyLimit");
		String withInvoiceTag		= (String) insWOpenLiab.get("withInvoiceTag");
		String userId 				= (String) insWOpenLiab.get("userId");
		
		GIPIWOpenLiab wopenLiab = null;
		
		if (geogCd != 0){
			wopenLiab = new GIPIWOpenLiab();
			
			wopenLiab.setParId(parId);
			wopenLiab.setGeogCd(geogCd);
			wopenLiab.setCurrencyCd(currencyCd);
			wopenLiab.setCurrencyRate(currencyRate);
			wopenLiab.setLimitOfLiability(limitOfLiability);
			wopenLiab.setVoyLimit(voyLimit);
			wopenLiab.setWithInvoiceTag(withInvoiceTag);
			wopenLiab.setUserId(userId);
		}
		
		return wopenLiab;
	}
	
	private List<GIPIWOpenCargo> prepareWOpenCargo(Map<String, Object> insWOpenCargo) throws SQLException {
		String[] cargoClassCds = (String[]) insWOpenCargo.get("cargoClassCds");
		int parId  			   = (Integer) insWOpenCargo.get("parId");
		int geogCd			   = (Integer) insWOpenCargo.get("geogCd");
		String userId 		   = (String) insWOpenCargo.get("userId");
		
		List<GIPIWOpenCargo> wopenCargos = new ArrayList<GIPIWOpenCargo>();
		
		if (cargoClassCds != null){
			GIPIWOpenCargo wopenCargo = null;
			for (int i = 0; i < cargoClassCds.length; i++){
				wopenCargo = new GIPIWOpenCargo();
				
				wopenCargo.setParId(parId);
				wopenCargo.setGeogCd(geogCd);
				wopenCargo.setCargoClassCd(Integer.parseInt(cargoClassCds[i]));
				wopenCargo.setUserId(userId);
				
				wopenCargos.add(wopenCargo);
			}
		}
		
		return wopenCargos;		
	}
	
	private List<GIPIWOpenPeril> prepareWOpenPeril(Map<String, Object> insWOpenPeril) throws SQLException{
		int parId 			  = (Integer) insWOpenPeril.get("parId");
		int geogCd 			  = (Integer) insWOpenPeril.get("geogCd");
		String lineCd 		  = (String) insWOpenPeril.get("lineCd");
		String[] perilCds 	  = (String[]) insWOpenPeril.get("perilCds");
		String[] premiumRates = (String[]) insWOpenPeril.get("premiumRates");
		String[] remarks 	  = (String[]) insWOpenPeril.get("remarks");
		String userId 		  = (String) insWOpenPeril.get("userId");
		BigDecimal premTemp   = new BigDecimal("0"); 
		
		List<GIPIWOpenPeril> wopenPerils = new ArrayList<GIPIWOpenPeril>();
		
		if (perilCds != null){
			GIPIWOpenPeril wopenPeril = null;
			//log.info("Inserting WOpenPeril/s...");
			for(int i=0; i<perilCds.length; i++){
				wopenPeril = new GIPIWOpenPeril();
				
				wopenPeril.setParId(parId);
				wopenPeril.setGeogCd(geogCd);
				wopenPeril.setLineCd(lineCd);
				wopenPeril.setPerilCd(Integer.parseInt(perilCds[i]));
				//wopenPeril.setPremiumRate((premiumRates[i].trim() == "" ? null : new BigDecimal(premiumRates[i])));
				premTemp = (premiumRates[i].trim() == "" ? null : new BigDecimal(premiumRates[i]));
				if(premTemp != null) {
					wopenPeril.setPremiumRate(premTemp.doubleValue());
				} 
				wopenPeril.setRemarks(remarks[i]);
				wopenPeril.setUserId(userId);
								
				wopenPerils.add(wopenPeril);
				//this.getGipiWOpenPerilDAO().saveWOpenPeril(wopenPeril);
			}
			//log.info(perilCds.length + " WOpenPeril/s inserted.");
		}
		
		return wopenPerils;
	}
	
	private Map<String, Object> preparePostParams(GIPIWOpenLiab wopenLiab, Map<String, Object> checkParams) throws SQLException{	
		Map<String, Object> postParams = new HashMap<String, Object>();
		
		if(wopenLiab != null){
			postParams.put("parId", wopenLiab.getParId());
			postParams.put("limitOfLiability", wopenLiab.getLimitOfLiability());
			postParams.put("currencyCd", wopenLiab.getCurrencyCd());
			postParams.put("currencyRate", wopenLiab.getCurrencyRate());
			postParams.put("userId", wopenLiab.getUserId());
			postParams.put("issCd", checkParams.get("issCd"));
			postParams.put("lineCd", checkParams.get("lineCd"));			
			//postParams.put("mode", checkParams.get("mode"));
		}
		
		return postParams;
	}

	@Override
	public GIPIWOpenLiab getWOpenLiab(int parId, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		
		log.info("Retrieving WOpenLiab...");
		GIPIWOpenLiab wopenLiab = this.getGipiWOpenLiabDAO().getWOpenLiab(params); 
		log.info("WOpenLiab retrieved");
		
		return wopenLiab;
	}

	@Override
	public HashMap<String, Object> getEndtLolVars(Integer parId)
			throws SQLException {
		return this.getGipiWOpenLiabDAO().getEndtLolVars(parId);
	}
	
	@Override
	public String saveEndtLimitOfLiability(HttpServletRequest request, String userId)
			throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setCargoRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setCargoRows")), userId, GIPIWOpenCargo.class));
		allParams.put("delCargoRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delCargoRows")), userId, GIPIWOpenCargo.class));
		allParams.put("setPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setPerilRows")), userId, GIPIWOpenPeril.class));
		allParams.put("delPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delPerilRows")), userId, GIPIWOpenPeril.class));
		allParams.put("deleteSw", request.getParameter("deleteSw"));
		allParams.put("parId", Integer.parseInt(request.getParameter("globalParId")));
		allParams.put("geogCd", request.getParameter("geogCd"));
		allParams.put("userId", userId);
		allParams.put("gipiWOpenLiab", request.getParameter("geogCd").equals("") ? null : prepareGIPIWOpenLiab(request, userId));
		allParams.put("postFormParams", preparePostFormParams(request));
		
		return this.getGipiWOpenLiabDAO().saveEndtLimitOfLiability(allParams);
	}
	
	private GIPIWOpenLiab prepareGIPIWOpenLiab(HttpServletRequest request, String userId){
		BigDecimal limitLiability = new BigDecimal(request.getParameter("inputLimit").equals("") ? "0" : ((String)request.getParameter("inputLimit")).replaceAll(",", ""));
		BigDecimal currencyRt = request.getParameter("inputCurrencyRate").equals("") ? null : new BigDecimal(((String)request.getParameter("inputCurrencyRate")).replaceAll(",", ""));
		GIPIWOpenLiab gipiWOpenLiab = new GIPIWOpenLiab();
		gipiWOpenLiab.setParId(Integer.parseInt(request.getParameter("globalParId")));
		gipiWOpenLiab.setGeogCd(request.getParameter("geogCd").equals("") ? 0 : Integer.parseInt(request.getParameter("geogCd")));
		gipiWOpenLiab.setRecFlag(request.getParameter("recFlag"));
		gipiWOpenLiab.setLimitOfLiability(limitLiability);
		gipiWOpenLiab.setCurrencyCd(Integer.parseInt(request.getParameter("currencyCd")));
		gipiWOpenLiab.setCurrencyRate(currencyRt);
		gipiWOpenLiab.setVoyLimit(request.getParameter("inputVoyLimit"));
		gipiWOpenLiab.setWithInvoiceTag(request.getParameter("withInvoiceTag"));
		gipiWOpenLiab.setUserId(userId);
		return gipiWOpenLiab;
	}
	
	private HashMap<String, Object> preparePostFormParams(HttpServletRequest request){
		HashMap<String, Object> postFormParams = new HashMap<String, Object>();
		postFormParams.put("parId", Integer.parseInt(request.getParameter("globalParId")));
		postFormParams.put("limitLiability", request.getParameter("inputLimit").equals("") ? "0" : ((String)request.getParameter("inputLimit")).replaceAll(",", ""));
		postFormParams.put("currencyCd", request.getParameter("currencyCd").equals("") ? null : Integer.parseInt(request.getParameter("currencyCd")));
		postFormParams.put("currencyRt", request.getParameter("inputCurrencyRate").equals("") ? null : Float.parseFloat(request.getParameter("inputCurrencyRate")));
		postFormParams.put("lineCd", request.getParameter("lineCd"));
		postFormParams.put("issCd", request.getParameter("issCd"));
		postFormParams.put("userId", request.getParameter("userId"));
		return postFormParams;
	}

	@Override
	public Map<String, Object> getDefaultCurrency(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		return this.getGipiWOpenLiabDAO().getDefaultCurrency(params);
	}

	@Override
	public Map<String, Object> checkRiskNote(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("geogCd", Integer.parseInt(request.getParameter("geogCd")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		return this.getGipiWOpenLiabDAO().checkRiskNote(params);
	}

	// Start of methods for GIPIS173
	@Override
	public Map<String, Object> getDefaultCurrencyGIPIS173(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("currencyRate", request.getParameter("currencyRate"));
		params.put("currencyDesc", request.getParameter("currencyDesc"));
		return this.getGipiWOpenLiabDAO().getDefaultCurrencyGIPIS173(params);
	}
	
	@Override
	public String saveEndtLolGIPIS173(HttpServletRequest request, String userId)
			throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		
		allParams.put("setPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setPerilRows")), userId, GIPIWOpenPeril.class));
		allParams.put("delPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delPerilRows")), userId, GIPIWOpenPeril.class));
		allParams.put("deleteSw", request.getParameter("deleteSw"));
		allParams.put("parId", Integer.parseInt(request.getParameter("globalParId")));
		allParams.put("lineCd", request.getParameter("lineCd"));
		allParams.put("geogCd", request.getParameter("geogCd"));
		allParams.put("userId", userId);
		allParams.put("gipiWOpenLiab", request.getParameter("geogCd") == "" ? null : prepareGIPIWOpenLiab(request, userId));
		allParams.put("postFormParams", preparePostFormParams(request)); 
		return this.getGipiWOpenLiabDAO().saveEndtLolGIPIS173(allParams);
	}

	@Override
	public Map<String, Object> getRecFlagGIPIS173(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("geogCd", request.getParameter("geogCd").equals("") ? 0 : Integer.parseInt(request.getParameter("geogCd")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("recFlag", request.getParameter("recFlag"));
		params.put("message", "");
		
		return this.getGipiWOpenLiabDAO().getRecFlagGIPIS173(params);
	}
}
