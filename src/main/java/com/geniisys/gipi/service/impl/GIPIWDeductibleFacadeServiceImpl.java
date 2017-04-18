/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.math.MathContext;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWDeductibleDAO;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWDeductibleFacadeServiceImpl.
 */
public class GIPIWDeductibleFacadeServiceImpl implements GIPIWDeductibleFacadeService{

	/** The gipi w deductible dao. */
	private GIPIWDeductibleDAO gipiWDeductibleDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWDeductibleFacadeServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWDeductibleFacadeService#getWDeductibles(int, int)
	 */
	@Override
	public List<GIPIWDeductible> getWDeductibles(int parId, int deductibleLevel)
			throws SQLException {
		List<GIPIWDeductible> wdeductibleList = null;
		
		if (1 == deductibleLevel){
			log.info("Retrieving WPolicy Deductible...");
			wdeductibleList = this.getGipiWDeductibleDAO().getWPolicyDeductibles(parId);
			log.info("WPolicy Deductible Size(): " + wdeductibleList.size());			
		} else if (2 == deductibleLevel){
			log.info("Retrieving WItem Deductible...");
			wdeductibleList = this.getGipiWDeductibleDAO().getWItemDeductibles(parId);
			log.info("WItem Deductible Size(): " + wdeductibleList.size());			
		} else if (3 == deductibleLevel){
			log.info("Retrieving WPeril Deductible...");
			wdeductibleList = this.getGipiWDeductibleDAO().getWPerilDeductibles(parId);
			log.info("WPeril Deductible Size(): " + wdeductibleList.size());			
		}
		
		return wdeductibleList;
	}

	/**
	 * Sets the gipi w deductible dao.
	 * 
	 * @param gipiWDeductibleDAO the new gipi w deductible dao
	 */
	public void setGipiWDeductibleDAO(GIPIWDeductibleDAO gipiWDeductibleDAO) {
		this.gipiWDeductibleDAO = gipiWDeductibleDAO;
	}

	/**
	 * Gets the gipi w deductible dao.
	 * 
	 * @return the gipi w deductible dao
	 */
	public GIPIWDeductibleDAO getGipiWDeductibleDAO() {
		return gipiWDeductibleDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWDeductibleFacadeService#deleteAllWDeductibles(int, int)
	 */
	@Override
	public boolean deleteAllWDeductibles(int parId, int deductibleLevel) throws SQLException {
		
		if (1 == deductibleLevel){
			log.info("Deleting all WPolicy Deductibles...");
			this.getGipiWDeductibleDAO().deleteAllWPolicyDeductibles(parId);
			log.info("All WPolicy Deductibles deleted.");			
		} else if (2 == deductibleLevel) {
			log.info("Deleting all WItem Deductibles...");
			this.getGipiWDeductibleDAO().deleteAllWItemDeductibles(parId);
			log.info("All WItem Deductibles deleted.");
		} else if (3 == deductibleLevel) {
			log.info("Deleting all WPeril Deductibles...");
			this.getGipiWDeductibleDAO().deleteAllWPerilDeductibles(parId);
			log.info("All WPeril Deductibles deleted.");
		}
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWDeductibleFacadeService#saveGIPIWDeductible(java.util.Map, int)
	 */
	@Override
	public boolean saveGIPIWDeductible(Map<String, Object> parameters, int deductibleLevel)	throws SQLException, JSONException {
		String[] itemNos 			= (String[]) parameters.get("itemNos");
		String[] perilCds 			= (String[]) parameters.get("perilCds");
		String[] deductibleCds 		= (String[]) parameters.get("deductibleCds");
		String[] deductibleAmounts 	= (String[]) parameters.get("deductibleAmounts");
		String[] deductibleRates	= (String[]) parameters.get("deductibleRates");
		String[] deductibleTexts 	= (String[]) parameters.get("deductibleTexts");
		String[] aggregateSws 		= (String[]) parameters.get("aggregateSws");
		String[] ceilingSws 		= (String[]) parameters.get("ceilingSws");
		Integer parId 				= (Integer) parameters.get("parId");
		String dedLineCd 			= (String) parameters.get("dedLineCd");
		String dedSublineCd 		= (String) parameters.get("dedSublineCd");
		String userId 				= (String) parameters.get("userId");	
		
		this.deleteAllWDeductibles(parId, deductibleLevel);
		
		GIPIWDeductible wdeductible = null;
		
		if(null != deductibleCds){			
			for (int i=0; i < deductibleCds.length; i++)	{
				wdeductible = new GIPIWDeductible();
				
				wdeductible.setParId(parId); 
				wdeductible.setDedLineCd(dedLineCd); 
				wdeductible.setDedSublineCd(dedSublineCd);
				wdeductible.setUserId(userId); 
				wdeductible.setItemNo(Integer.parseInt(itemNos[i]));
				wdeductible.setPerilCd(Integer.parseInt(perilCds[i]));
				wdeductible.setDedDeductibleCd(deductibleCds[i].replaceAll("slash", "/"));
				wdeductible.setDeductibleAmount((deductibleAmounts[i] == null || deductibleAmounts[i] == "" ? null : new BigDecimal(deductibleAmounts[i].replaceAll(",", "")))); 
				wdeductible.setDeductibleRate((deductibleRates[i] == null || deductibleRates[i] == "" ? null : new BigDecimal(deductibleRates[i].replaceAll(",", ""))));
				wdeductible.setDeductibleText(deductibleTexts[i]);
				wdeductible.setAggregateSw((aggregateSws[i] == null || aggregateSws[i] == "" ? "N" : aggregateSws[i]));  
				wdeductible.setCeilingSw((ceilingSws[i] == null || ceilingSws[i] == "" ? "N" : ceilingSws[i])); 
					
				this.getGipiWDeductibleDAO().saveGIPIWDeductible(wdeductible);
			}
		}
		
		return true;		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWDeductibleFacadeService#checkWDeductible(int, java.lang.String, int, int)
	 */
	@Override
	public String checkWDeductible(int parId, String deductibleType, int deductibleLevel, int itemNo)
			throws SQLException {
		
		String result;
		
		log.info("Checking WDeductibles... ");
		result = this.getGipiWDeductibleDAO().checkWDeductible(parId, deductibleType, deductibleLevel, itemNo);
		log.info("WDeductibles cheked.");
		
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWDeductibleFacadeService#deleteWPerilDeductibles(int, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean deleteWPerilDeductibles(int parId, String lineCd,
			String nbtSublineCd) throws SQLException {
		this.getGipiWDeductibleDAO().deleteWPerilDeductibles(parId, lineCd, nbtSublineCd);
		return true;
	}

	@Override
	public boolean deleteAllWPolicyDeductibles2(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		return this.getGipiWDeductibleDAO().deleteAllWPolicyDeductibles2(parId, lineCd, sublineCd);
	}

	@Override
	public String isExistGipiWdeductible(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		return this.getGipiWDeductibleDAO().isExistGipiWdeductible(parId, lineCd, sublineCd);
	}

	@Override
	public boolean deleteGipiWDeductibles2(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		this.getGipiWDeductibleDAO().deleteGipiWDeductibles2(parId, lineCd, sublineCd);
		return true;
	}

	@Override
	public List<GIPIWDeductible> getDeductibleItemAndPeril(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		return this.getGipiWDeductibleDAO().getDeductibleItemAndPeril(parId, lineCd, sublineCd);
	}	
	
	public List<GIPIWDeductible> prepareGIPIWDeductible(Map<String, Object> parameters){
		String[] itemNos 			= (String[]) parameters.get("itemNos");
		String[] perilCds 			= (String[]) parameters.get("perilCds");
		String[] deductibleCds 		= (String[]) parameters.get("deductibleCds");
		String[] deductibleAmounts 	= (String[]) parameters.get("deductibleAmounts");
		String[] deductibleRates	= (String[]) parameters.get("deductibleRates");
		String[] deductibleTexts 	= (String[]) parameters.get("deductibleTexts");
		String[] aggregateSws 		= (String[]) parameters.get("aggregateSws");
		String[] ceilingSws 		= (String[]) parameters.get("ceilingSws");
		Integer parId 				= (Integer) parameters.get("parId");
		String dedLineCd 			= (String) parameters.get("dedLineCd");
		String dedSublineCd 		= (String) parameters.get("dedSublineCd");
		String userId 				= (String) parameters.get("userId");
		
		List<GIPIWDeductible> wdeductibles = new ArrayList<GIPIWDeductible>();
		GIPIWDeductible wdeductible = null;		
		if(null != deductibleCds){			
			for (int i=0; i < deductibleCds.length; i++) {
				wdeductible = new GIPIWDeductible();
				
				wdeductible.setParId(parId); 
				wdeductible.setDedLineCd(dedLineCd); 
				wdeductible.setDedSublineCd(dedSublineCd);
				wdeductible.setUserId(userId); 
				wdeductible.setItemNo(Integer.parseInt(itemNos[i]));
				wdeductible.setPerilCd(Integer.parseInt(perilCds[i]));
				wdeductible.setDedDeductibleCd(deductibleCds[i].replaceAll("slash", "/"));
				wdeductible.setDeductibleAmount((deductibleAmounts[i] == null || deductibleAmounts[i] == "" ? null : new BigDecimal(deductibleAmounts[i].replaceAll(",", "")))); 
				wdeductible.setDeductibleRate((deductibleRates[i] == null || deductibleRates[i] == "" ? null : new BigDecimal(deductibleRates[i].replaceAll(",", ""))));
				wdeductible.setDeductibleText(deductibleTexts[i]);
				wdeductible.setAggregateSw((aggregateSws[i] == null || aggregateSws[i] == "" ? "N" : aggregateSws[i]));  
				wdeductible.setCeilingSw((ceilingSws[i] == null || ceilingSws[i] == "" ? "N" : ceilingSws[i])); 
					
				wdeductibles.add(wdeductible);
			}
		}
		
		return wdeductibles;
	}

	@Override
	public List<GIPIWDeductible> prepareGIPIWDeductibleForInsert(
			JSONArray jsonArray) throws JSONException {
		List<GIPIWDeductible> wdeductibles = new ArrayList<GIPIWDeductible>();
		GIPIWDeductible wdeductible = null;
		JSONObject objDeductible = null;
		
		for (int index=0; index < jsonArray.length(); index++) {
			wdeductible = new GIPIWDeductible();
			objDeductible = jsonArray.getJSONObject(index);

			wdeductible.setParId((Integer) JSONObject.stringToValue(objDeductible.getString("parId")));
			wdeductible.setDedLineCd((String) JSONObject.stringToValue(objDeductible.getString("dedLineCd")));
			wdeductible.setDedSublineCd((String) JSONObject.stringToValue(objDeductible.getString("dedSublineCd")));
			wdeductible.setUserId(objDeductible.getString("userId"));
			wdeductible.setAppUser(objDeductible.getString("userId")); // added by: Nica 07.04.2012
			wdeductible.setItemNo(objDeductible.isNull("itemNo") ? null : objDeductible.getInt("itemNo"));
			wdeductible.setPerilCd(objDeductible.isNull("perilCd") ? null : objDeductible.getInt("perilCd"));
			//wdeductible.setDedDeductibleCd(JSONObject.stringToValue(objDeductible.getString("dedDeductibleCd").replaceAll("slash", "/")).toString()); // replace by: Nica 06.05.2012					
			//wdeductible.setDedDeductibleCd(objDeductible.isNull("dedDeductibleCd") ? null : objDeductible.getString("dedDeductibleCd").replaceAll("slash", "/")); 
			wdeductible.setDedDeductibleCd(objDeductible.isNull("dedDeductibleCd") ? null : StringFormatter.unescapeHtmlJava(objDeductible.getString("dedDeductibleCd").replaceAll("slash", "/"))); //replaced by: Mark C. 03.10.2015 SR4302
			wdeductible.setDeductibleAmount(objDeductible.isNull("deductibleAmount") ? null : new BigDecimal(objDeductible.getString("deductibleAmount").replaceAll(",", "")));
			//wdeductible.setDeductibleRate((objDeductible.isNull("deductibleRate") ? null : new BigDecimal(objDeductible.getString("deductibleRate").replaceAll(",", "")))); //Commented out by Jerome 11.29.2016 SR 5737
			
			if (!objDeductible.isNull("deductibleRate")){ //Added by Jerome 12.01.2016 SR 5737
				BigDecimal bdDedRate = new BigDecimal(objDeductible.getString("deductibleRate"));
				wdeductible.setDeductibleRate(new BigDecimal(bdDedRate.doubleValue(), MathContext.DECIMAL64));
			}
			wdeductible.setDeductibleText(StringFormatter.unescapeHtmlJava(objDeductible.getString("deductibleText")));
			wdeductible.setAggregateSw(objDeductible.isNull("aggregateSw") ? null : objDeductible.getString("aggregateSw"));  
			wdeductible.setCeilingSw(objDeductible.isNull("ceilingSw") ? null : objDeductible.getString("ceilingSw")); 
			
			wdeductibles.add(wdeductible);
		}
		return wdeductibles;
	}
	
	public List<GIPIWDeductible> prepareGIPIWDeductibleForDelete(JSONArray jsonArray) throws JSONException{
		List<GIPIWDeductible> wdeductibles = new ArrayList<GIPIWDeductible>();
		GIPIWDeductible wdeductible = null;
		JSONObject objDeductible = null;
		
		for (int index=0; index < jsonArray.length(); index++) {
			wdeductible = new GIPIWDeductible();
			objDeductible = jsonArray.getJSONObject(index);
			
			wdeductible.setParId((Integer) JSONObject.stringToValue(objDeductible.getString("parId")));
			wdeductible.setDedLineCd((String) JSONObject.stringToValue(objDeductible.getString("dedLineCd")));
			wdeductible.setDedSublineCd((String) JSONObject.stringToValue(objDeductible.getString("dedSublineCd")));
			wdeductible.setItemNo((Integer) JSONObject.stringToValue(objDeductible.getString("itemNo")));
			wdeductible.setPerilCd((Integer) JSONObject.stringToValue(objDeductible.getString("perilCd")));
			//wdeductible.setDedDeductibleCd(JSONObject.stringToValue(objDeductible.getString("dedDeductibleCd").replaceAll("slash", "/")).toString());	// replaced by: Nica 06.05.2012		
			wdeductible.setDedDeductibleCd(objDeductible.isNull("dedDeductibleCd") ? null : objDeductible.getString("dedDeductibleCd").replaceAll("slash", "/"));
			wdeductibles.add(wdeductible);
		}
		return wdeductibles;
	}

	@Override
	public List<GIPIWDeductible> getAllGIPIWDeductibles(Integer parId)
			throws SQLException {		
		return this.getGipiWDeductibleDAO().getAllGIPIWDeductibles(parId);
	}

}
