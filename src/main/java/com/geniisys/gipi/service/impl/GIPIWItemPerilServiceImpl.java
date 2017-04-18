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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemPerilServiceImpl.
 */
public class GIPIWItemPerilServiceImpl implements GIPIWItemPerilService {

	/** The gipi w item peril dao. */
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	private Logger log = Logger.getLogger(GIPIWItemPerilServiceImpl.class);

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#getGIPIWItemPerils(java.lang.Integer)
	 */	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getGIPIWItemPerils(Integer parId)
			throws SQLException {
		return (List<GIPIWItemPeril>) StringFormatter.escapeHTMLInList4(this.getGipiWItemPerilDAO().getGIPIWItemPeril(parId)); //changed to escapeHTMLInList4 Kenneth @ FGIC// RSIC SR 14426 Kenneth L changed to escapeHTMLInList3 to handle \t		
	}

	/**
	 * Sets the gipi w item peril dao.
	 * 
	 * @param gipiWItemPerilDAO the new gipi w item peril dao
	 */
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}

	/**
	 * Gets the gipi w item peril dao.
	 * 
	 * @return the gipi w item peril dao
	 */
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#saveWItemPeril(java.util.Map)
	 */	
	@Override
	public boolean saveWItemPeril(Map<String, Object> params)
			throws SQLException {
		
		Integer parId = (Integer) params.get("parId");
		String deldiscSw = (String) params.get("deldiscSw");

		//fetching all item perils for the par id
		//List<GIPIWItemPeril> wItemPerils = getGipiWItemPerilDAO().getGIPIWItemPeril(parId);
		//temporarily deleting item perils from table, for later reinsertion
		//if (wItemPerils != null){
		//	for (GIPIWItemPeril witemperil: wItemPerils){
		//		System.out.println("Deleting perils for item no. "+witemperil.getItemNo());
		//		this.getGipiWItemPerilDAO().deleteWItemPeril(witemperil.getParId(), witemperil.getItemNo(), witemperil.getLineCd(), witemperil.getPerilCd());
		//	}
		//}
		String[] itemNos = (String[]) params.get("itemNos");
		String[] discDeleteds = (String[]) params.get("discDeleteds");
		//for (String item: itemNos){
		//	System.out.println("item: "+item);
		//}
		//Map<String, Object> itemPerils = (Map<String, Object>) params.get("itemPerils");
		if (itemNos != null){
			for (int j=0; j<itemNos.length; j++){
				
				//preinsert
				if ("Y".equals(deldiscSw)){
					if ("N".equals(discDeleteds[j])){
						this.getGipiWItemPerilDAO().deleteOtherDiscount(parId, Integer.parseInt(itemNos[j]));
					}
				}
			}
		}
		
		if(params.get("itemNos2") != null){
			String[] itemNos2 = (String[]) params.get("itemNos2");
			String[] lineCds = (String[]) params.get("lineCds");
			String[] perilCds = (String[]) params.get("perilCds");
			String[] perilRates = (String[]) params.get("perilRates");
			String[] tsiAmounts = (String[]) params.get("tsiAmounts");
			String[] premAmts = (String[]) params.get("premAmts");
			String[] compRems = (String[]) params.get("compRems");
			String[] wcSws = (String[]) params.get("wcSws");
			String[] tarfCds = (String[]) params.get("tarfCds");
			String[] annPremAmts = (String[]) params.get("annPremAmts");
			String[] prtFlags = (String[]) params.get("prtFlags");
			String[] riCommRates = (String[]) params.get("riCommRates");
			String[] riCommAmts = (String[]) params.get("riCommAmts");
			String[] surchargeSws = (String[]) params.get("surchargeSws");
			String[] baseAmts = (String[]) params.get("baseAmts");
			String[] aggregateSws = (String[]) params.get("aggregateSws");
			String[] annTsiAmts = (String[]) params.get("annTsiAmts");
			String[] discountSws = (String[]) params.get("discountSws");
			String[] bascPerlCds = (String[]) params.get("bascPerlCds");
			String[] noOfDayss = (String[]) params.get("noOfDayss");
			
			for(int index=0, length=itemNos2.length; index<length; index++){
				if(wcSws != null){
					if("Y".equals(wcSws[index])){
						this.getGipiWItemPerilDAO().insertPerilToWC(parId, lineCds[index], Integer.parseInt(perilCds[index]));
					}
				}				
				
				//insert
				GIPIWItemPeril parItemPeril = new GIPIWItemPeril();
				parItemPeril.setParId(parId);
				parItemPeril.setItemNo(Integer.parseInt(itemNos2[index]));
				parItemPeril.setLineCd(lineCds[index]);
				parItemPeril.setPerilCd(Integer.parseInt(perilCds[index]));
				parItemPeril.setPremRt(new BigDecimal(perilRates[index]));
				parItemPeril.setTsiAmt(new BigDecimal((tsiAmounts[index]).replaceAll(",", "")));
				parItemPeril.setPremAmt(new BigDecimal((premAmts[index]).replaceAll(",", "")));
				parItemPeril.setCompRem(compRems[index]);
				parItemPeril.setTarfCd(tarfCds[index]);
				parItemPeril.setAnnPremAmt((annPremAmts[index] == "" )? null : new BigDecimal((annPremAmts[index]).replaceAll(",", "")));//new BigDecimal((annPremAmts[index] == ""? "0" : annPremAmts[index]).replaceAll(",", "")));
				parItemPeril.setAnnTsiAmt((annTsiAmts[index] == "" )? null : new BigDecimal((annTsiAmts[index]).replaceAll(",", "")));//new BigDecimal((annTsiAmts[index] == ""? "0" : annTsiAmts[index]).replaceAll(",", "")));
				parItemPeril.setPrtFlag(prtFlags[index]);
				parItemPeril.setRiCommRate((riCommRates[index] == "" )? null : new BigDecimal((riCommRates[index]).replaceAll(",", "")));//(new BigDecimal((riCommRates[index] == ""? "0" : riCommRates[index]).replaceAll(",", "")));
				System.out.println("riCommAmts[index]: "+riCommAmts[index]);
				parItemPeril.setRiCommAmt((riCommAmts[index] == "" )? null : new BigDecimal((riCommAmts[index]).replaceAll(",", "")));
				parItemPeril.setBaseAmt(new BigDecimal((baseAmts[index] == ""? "0" : baseAmts[index]).replaceAll(",", "")));
				parItemPeril.setSurchargeSw(surchargeSws[index]);
				parItemPeril.setAggregateSw(aggregateSws[index]);
				parItemPeril.setDiscountSw(discountSws[index]);
				parItemPeril.setBascPerlCd(bascPerlCds[index] == "" ? null : Integer.parseInt(bascPerlCds[index]));
				parItemPeril.setNoOfDays(noOfDayss[index] == "" ? null : Integer.parseInt(noOfDayss[index]));
				this.getGipiWItemPerilDAO().insertWItemPeril(parItemPeril);
				System.out.println("Insert Here!");
			}
		}
		/*
		Map<String, Object> perilMap = (Map<String, Object>) itemPerils.get(itemNos[j]);
		String[] itemNos2 = (String[]) perilMap.get("itemNos2");
		String[] lineCds = (String[]) perilMap.get("lineCds");
		String[] perilCds = (String[]) perilMap.get("perilCds");
		String[] perilRates = (String[]) perilMap.get("perilRates");
		String[] tsiAmounts = (String[]) perilMap.get("tsiAmounts");
		String[] premAmts = (String[]) perilMap.get("premAmts");
		String[] compRems = (String[]) perilMap.get("compRems");
		String[] wcSws = (String[]) perilMap.get("wcSws");
	
		//reinsertion
		if (itemNos2 != null){
			//System.out.println("itemNos2 length: "+itemNos2.length);
			//for (String itemNo2 : itemNos2 ) {
				//System.out.println("loop itemnos2: "+itemNo2);
			//}
			for (int i=0; i<itemNos2.length; i++){
				//System.out.println("i: "+i);
				//System.out.println("SERVICE - ItemNo"+":"+itemNos2[i]);
				//System.out.println("SERVICE - LineCd"+":"+lineCds[i]);
				//System.out.println("SERVICE - perilCds"+":"+perilCds[i]);
				//System.out.println("SERVICE - perilRates"+":"+perilRates[i]);
				//System.out.println("SERVICE - tsiAmounts"+":"+tsiAmounts[i]);
				
				//preinsert
				System.out.println("wcSw: "+wcSws[i]);
				if ("Y".equals(wcSws[i])){
					this.getGipiWItemPerilDAO().insertPerilToWC(parId, lineCds[i], Integer.parseInt(perilCds[i]));
				}
				
				
				//insert
				GIPIWItemPeril parItemPeril = new GIPIWItemPeril();
				parItemPeril.setParId(parId);
				parItemPeril.setItemNo(Integer.parseInt(itemNos2[i]));
				parItemPeril.setLineCd(lineCds[i]);
				parItemPeril.setPerilCd(Integer.parseInt(perilCds[i]));
				parItemPeril.setPremRt(new BigDecimal(perilRates[i]));
				parItemPeril.setTsiAmt(new BigDecimal((tsiAmounts[i]).replaceAll(",", "")));
				parItemPeril.setPremAmt(new BigDecimal((premAmts[i]).replaceAll(",", "")));
				parItemPeril.setCompRem(compRems[i]);
				this.getGipiWItemPerilDAO().insertWItemPeril(parItemPeril);
				System.out.println("Insert Here!");
			}
			
			
			//update witem
			
			
		}*/
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#deleteWItemPeril(java.lang.Integer, java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@Override
	public boolean deleteWItemPeril(Integer parId, Integer itemNo,
			String lineCd, Integer perilCd) throws SQLException {
		this.gipiWItemPerilDAO.deleteWItemPeril(parId, itemNo, lineCd, perilCd);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#checkDeductibleItemNo(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String checkDeductibleItemNo(Integer parId, String lineCd, String nbtSublineCd)
			throws SQLException {
		//GIPIWDeductibleFacadeService serv = new GIPIWDeductibleFacadeServiceImpl();
		String isNull = this.getGipiWItemPerilDAO().checkDeductibleItemNoIfNull(parId, lineCd, nbtSublineCd);
		return isNull;
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWItemPerilDAO.isExist(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#deleteDeductibles(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> deleteDeductibles(Integer parId, Integer itemNo)
			throws SQLException {
		return this.getGipiWItemPerilDAO().deleteDeductibles(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#updateWItem(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean updateWItem(Integer parId, Integer itemNo)
			throws SQLException {
		this.getGipiWItemPerilDAO().updateWItem(parId, itemNo);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#createWInvoiceForPAR(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean createWInvoiceForPAR(Integer parId, String lineCd,
			String issCd) throws SQLException {
		this.getGipiWItemPerilDAO().createWInvoiceForPAR(parId, lineCd, issCd);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#deleteOtherDiscount(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean deleteOtherDiscount(Integer parId, Integer itemNo)
			throws SQLException {
		this.getGipiWItemPerilDAO().deleteOtherDiscount(parId, itemNo);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemPerilService#isExist(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String isExist(Integer parId, Integer itemNo) throws SQLException {
		return this.getGipiWItemPerilDAO().isExist(parId, itemNo);
	}

	@Override
	public boolean deleteWItemPeril(Map<String, Object> params)
			throws SQLException {
		String[] delPerilItemNos 	= (String[]) params.get("delPerilItemNos");
		String[] delPerilCds 		= (String[]) params.get("delPerilCds");
		String[] delPerilLineCds 	= (String[]) params.get("delPerilLineCds");
		
		int parId = Integer.parseInt(params.get("delParId").toString());
		List<GIPIWItemPeril> itemPerils = new ArrayList<GIPIWItemPeril>();
		GIPIWItemPeril itemPeril = null;
		for(int index=0, length = delPerilItemNos.length; index < length; index++){
			itemPeril = new GIPIWItemPeril();
			itemPeril.setParId(parId);
			itemPeril.setItemNo(Integer.parseInt(delPerilItemNos[index]));
			itemPeril.setPerilCd(Integer.parseInt(delPerilCds[index]));
			itemPeril.setLineCd(delPerilLineCds[index]);			
			itemPerils.add(itemPeril);
		}
		this.getGipiWItemPerilDAO().deleteWItemPeril(itemPerils);
		return true;
	}

	@Override
	public String getIssCdRi() throws SQLException {
		return this.getGipiWItemPerilDAO().getIssCdRi();
	}

	@Override
	public GIPIWItemPeril getPerilDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemPerilDAO().getPerilDetails(params);
	}

	@Override
	public boolean saveEndtItemPeril(Map<String, Object> allEndtPerilParams)
			throws SQLException, Exception {
		
		log.info("Saving Endorsement Item Peril/s...");
		this.getGipiWItemPerilDAO().saveEndtItemPeril(allEndtPerilParams);
		log.info("Endorsement Item Peril/s saved.");
		
		return true;
	}

	@Override
	public String checkEndtPeril(Map<String, Object> params)
			throws SQLException{

		String message = null;
		
		log.info("Checking Endorsement Item Peril...");
		Map<String, Object> checkParams = this.getGipiWItemPerilDAO().checkEndtPeril(params);
		message = (String) checkParams.get("message");
		log.info("Endorsement Item Peril checked.");
		
		return message;
	}

/*	@Override
	public String computePremium(Map<String, Object> params)
			throws SQLException{
		
		String message = null;
		
		log.info("Computing premium...");
		Map<String, Object> newParams = this.getGipiWItemPerilDAO().computePremium(params);
		message = (String) newParams.get("message");			
		log.info("Premium computed.");
		
		return message;
	}*/	
	
	@Override
	public List<GIPIWItemPeril> getEndtItemPeril(int parId)
			throws SQLException {
		
		
		List<GIPIWItemPeril> endtPerils = null; 
		
		log.info("Retrieving Endorsement Item Peril...");
		endtPerils = (List<GIPIWItemPeril>) this.getGipiWItemPerilDAO().getEndtItemPeril(parId);			
		log.info(endtPerils.size() + " Endorsement Item Peril retrieved.");
				
		return endtPerils;
	}

	@Override
	public String isExist2(int parId, int itemNo) throws SQLException {		
		return this.getGipiWItemPerilDAO().isExist2(parId, itemNo);
	}

	@Override
	public String checkIfParItemHasPeril(int parId, int itemNo)
			throws SQLException {		
		return this.getGipiWItemPerilDAO().checkIfParItemHasPeril(parId, itemNo);
	}

/*	@Override
	public List<GIPIWItemPeril> retrievePeril(int policyId, int itemNo)
			throws SQLException {
		
		log.info("Retrieving Endorsement Item Peril/s...");
		List<GIPIWItemPeril> endtPerils = this.getGipiWItemPerilDAO().retrievePeril(policyId, itemNo);
		log.info(endtPerils.size() + " Endorsement Item Peril/s retrieved.");		
		
		return endtPerils;
	}
	*/

	@Override
	public void deleteWItemPeril2(int parId, int itemNo) throws SQLException {		
		this.getGipiWItemPerilDAO().deleteWItemPeril2(parId, itemNo);
	}

	@Override
	public Integer getEndtTariff(Map<String, Object> params)
			throws SQLException {

		log.info("Retrieving Endorsement Item Peril tariff...");
		Integer tariff = this.getGipiWItemPerilDAO().getEndtTariff(params);
		log.info("Endorsement Item Peril tariff retrieved.");		
		
		return tariff;
	}

	@Override
	public GIPIWItemPeril getPostTextTsiAmtDetails(Map<String, Object> params)
			throws SQLException {
		return this.gipiWItemPerilDAO.getPostTextTsiAmtDetails(params);
	}

	@Override
	public List<Map<String, Object>> prepareEndtItemPerilForDelete(JSONArray jsonArray) throws JSONException {
		List<Map<String, Object>> perils = new ArrayList<Map<String,Object>>();
		Map<String, Object> peril = null;
		
		for(int index=0; index<jsonArray.length(); index++) {
			peril = new HashMap<String, Object>();
			
			peril.put("parId", jsonArray.getJSONObject(index).getInt("parId"));
			peril.put("itemNo", jsonArray.getJSONObject(index).getInt("itemNo"));
			peril.put("lineCd", jsonArray.getJSONObject(index).getString("lineCd"));
			peril.put("perilCd", jsonArray.getJSONObject(index).getInt("perilCd"));
			
			perils.add(peril);
		}
		
		return perils;
	}

	@Override
	public List<GIPIWItemPeril> prepareEndtItemPerilForInsert(JSONArray jsonArray) throws JSONException {
		List<GIPIWItemPeril> endtPerils = new ArrayList<GIPIWItemPeril>();
		GIPIWItemPeril endtPeril = null;
		JSONObject json = null;
		
		for (int i = 0; i < jsonArray.length(); i++){
			endtPeril = new GIPIWItemPeril();
			json = jsonArray.getJSONObject(i);
			
			endtPeril.setParId(json.getInt("parId"));
			endtPeril.setLineCd(json.getString("lineCd"));
			endtPeril.setItemNo(json.getInt("itemNo"));
			endtPeril.setPerilCd(json.getInt("perilCd"));
			endtPeril.setPremRt(json.isNull("premiumRate") ? null : new BigDecimal(json.getString("premiumRate")));
			endtPeril.setTsiAmt(json.isNull("tsiAmount") ? null : new BigDecimal(json.getString("tsiAmount")));
			endtPeril.setAnnTsiAmt(json.isNull("annTsiAmount") ? null : new BigDecimal(json.getString("annTsiAmount")));
			endtPeril.setPremAmt(json.isNull("premiumAmount") ? null : new BigDecimal(json.getString("premiumAmount")));
			endtPeril.setAnnPremAmt(json.isNull("annPremiumAmount") ? null : new BigDecimal(json.getString("annPremiumAmount")));
			endtPeril.setCompRem(json.isNull("remarks") ? null : json.getString("remarks"));
			endtPeril.setRiCommAmt(json.isNull("riCommAmount") ? null : new BigDecimal(json.getString("riCommAmount")));
			endtPeril.setRiCommRate(json.isNull("riCommRate") ? null : new BigDecimal(json.getString("riCommRate")));
			endtPeril.setTarfCd(json.isNull("tarfCd") ? null : json.getString("tarfCd"));
			endtPeril.setRecFlag(json.isNull("recFlag") ? null : json.getString("recFlag"));
			endtPerils.add(endtPeril);
			
			/*
			if("Y".equals(wcSws[i])){
				this.includeWC(parId, lineCd, Integer.parseInt(perilCds[i]));
			}*/
		}
		
		return endtPerils;
	}	
	
	public List<Map<String, Object>> preparePerilWCs(JSONArray jsonArray) throws JSONException {
		List<Map<String, Object>> perilWCs = new ArrayList<Map<String,Object>>();
		Map<String, Object> perilWC = null;
		
		for (int index = 0; index<jsonArray.length(); index++){
			perilWC = new HashMap<String, Object>();
			
			perilWC.put("parId", jsonArray.getJSONObject(index).getInt("parId"));
			perilWC.put("itemNo", jsonArray.getJSONObject(index).getInt("itemNo"));
			perilWC.put("perilCd", jsonArray.getJSONObject(index).getInt("perilCd"));
			
			perilWCs.add(perilWC);			
		}
		
		return perilWCs;		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getNegateItemPerils(Map<String, Object> params)
			throws SQLException {
		return (List<GIPIWItemPeril>) StringFormatter.replaceQuotesInList(this.getGipiWItemPerilDAO().getNegateItemPerils(params));
	}

	@Override
	public Map<String, Object> getNegateDeleteItem(HttpServletRequest request)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		
		return this.getGipiWItemPerilDAO().getNegateDeleteItem(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getMaintainedPerilListing(Map<String, Object> params)
			throws SQLException {
		return (List<GIPIWItemPeril>) StringFormatter.replaceQuotesInList(this.getGipiWItemPerilDAO().getMaintainedPerilListing(params));
	}
	
	@Override
	public List<GIPIWItemPeril> prepareGIPIWItemPerilsListing(JSONArray setRows) throws SQLException, JSONException {
		List<GIPIWItemPeril> perils = new ArrayList<GIPIWItemPeril>();
		JSONObject objPeril = null;
		for(int i=0, length=setRows.length(); i < length; i++){
			objPeril = setRows.getJSONObject(i);
			perils.add(this.setObjToGIPIWItemPeril(objPeril));
		}
		System.out.println("perils.length = "+perils.size());
		return perils;
	}
	
	@SuppressWarnings("unused")
	private List<GIPIWItemPeril> prepareGIPIWItemPerils(JSONArray setRows) throws SQLException, JSONException {
		List<GIPIWItemPeril> perils = new ArrayList<GIPIWItemPeril>();
		JSONObject objPeril = null;
		for(int i=0, length=setRows.length(); i < length; i++){
			objPeril = setRows.getJSONObject(i);
			perils.add(this.setObjToGIPIWItemPeril(objPeril));
		}
		return perils;
	}
	
	private GIPIWItemPeril setObjToGIPIWItemPeril(JSONObject objPeril) throws JSONException{
		GIPIWItemPeril perl = null;
		perl = new GIPIWItemPeril();
		perl.setParId(objPeril.getInt("parId"));
		perl.setItemNo(objPeril.getInt("itemNo"));
		perl.setPerilCd(objPeril.getInt("perilCd"));
		perl.setLineCd(objPeril.getString("lineCd"));
		perl.setDiscountSw(objPeril.isNull("discountSw") ? null : objPeril.getString("discountSw"));
		perl.setAggregateSw(objPeril.isNull("aggregateSw") ? null : objPeril.getString("aggregateSw"));
		perl.setSurchargeSw(objPeril.isNull("surchargeSw") ? null : objPeril.getString("surchargeSw"));
		perl.setPrtFlag(objPeril.isNull("prtFlag") ? null : objPeril.getString("prtFlag"));
		perl.setPremRt(objPeril.isNull("premRt") ? null : new BigDecimal (objPeril.getString("premRt")));
		perl.setTsiAmt(objPeril.isNull("tsiAmt") ? null : new BigDecimal (objPeril.getString("tsiAmt")));
		perl.setPremAmt(objPeril.isNull("premAmt") ? null : new BigDecimal (objPeril.getString("premAmt").replaceAll(",", "")));
		perl.setBaseAmt(objPeril.isNull("baseAmt") ? null : (
				"".equals(objPeril.getString("baseAmt")) ? null : new BigDecimal(objPeril.getString("baseAmt"))));
		perl.setNoOfDays(objPeril.isNull("noOfDays") ? null : "".equals(objPeril.getString("noOfDays")) ? null : Integer.parseInt(objPeril.getString("noOfDays")));
		perl.setRiCommRate(objPeril.isNull("riCommRate") ? null : new BigDecimal(objPeril.getString("riCommRate")));
		perl.setRiCommAmt(objPeril.isNull("riCommAmt") ? null : new BigDecimal(objPeril.getString("riCommAmt").replaceAll(",", "")));//edgar 10/20/2014 : added replaceAll function
		perl.setAnnTsiAmt(objPeril.isNull("annTsiAmt") ? null : new BigDecimal(objPeril.getString("annTsiAmt")));
		perl.setAnnPremAmt(objPeril.isNull("annPremAmt") ? null : new BigDecimal(objPeril.getString("annPremAmt")));
		perl.setCompRem(objPeril.isNull("compRem") ? null : StringFormatter.unescapeHtmlJava(objPeril.getString("compRem")));
		perl.setTarfCd(objPeril.isNull("tarfCd") ? null : objPeril.getString("tarfCd"));
		perl.setRecFlag(objPeril.isNull("recFlag") ? null : objPeril.getString("recFlag"));
		
		System.out.println("PERIL: parId - "+perl.getParId()+" - itemNo - "+perl.getItemNo()+" - perilCd - "+perl.getPerilCd());
		return perl;
	}
	
	public Map<String, Object> updateItemServiceParams(Map<String, Object> params, JSONObject objParams)
		throws SQLException, JSONException, ParseException {
		params.put("delDiscSw", objParams.getString("delDiscSw"));
		params.put("deldiscItemNos", (objParams.isNull("deldiscItemNos") ? null : objParams.getString("deldiscItemNos")));
		params.put("globalPackParId", objParams.getString("globalPackParId"));
		params.put("issCd", objParams.getString("issCd"));
		params.put("updateMinPremFlag", objParams.isNull("updateMinPremFlag") ? "N" : objParams.getString("updateMinPremFlag")); //added by: Nica 08.01.2012
		params.put("minPremFlag", objParams.isNull("minPremFlag") ? null : objParams.getString("minPremFlag"));
		params.put("globalPackPolFlag", objParams.getString("globalPackPolFlag"));
		params.put("planSw", objParams.getString("planSw"));
		params.put("planCd", objParams.getString("planCd"));
		params.put("planChTag", objParams.getString("planChTag"));
		return params;
	}
	
	public Integer checkPerilExist(Integer parId) throws SQLException {
		return this.getGipiWItemPerilDAO().checkPerilExist(parId);
	}

	@Override
	public String checkItmPerilExists(HashMap<String, Object> params)
			throws SQLException {
		return this.getGipiWItemPerilDAO().checkItmPerilExists(params);
	}

	@Override
	public List<GIPIWItemPeril> getGIPIWItemPerilsByItem(Integer parId,
			Integer itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		return this.getGipiWItemPerilDAO().getGIPIWItemPerilsByItem(params);
	}

	@Override
	public JSONObject computeTsi(HttpServletRequest request) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("mm-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("changedTag", (!request.getParameter("changedTag").equals("") ? request.getParameter("changedTag") : null));
		params.put("tsiAmt", request.getParameter("tsiAmt").replaceAll(",", ""));
		params.put("premRt", request.getParameter("premRt"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt").replaceAll(",", ""));
		params.put("annPremAmt", request.getParameter("annPremAmt").replaceAll(",", ""));
		params.put("itemTsiAmt", request.getParameter("itemTsiAmt").replaceAll(",", ""));
		params.put("itemPremAmt", request.getParameter("itemPremAmt").replaceAll(",", ""));
		params.put("itemAnnTsiAmt", request.getParameter("itemAnnTsiAmt").replaceAll(",", "")); //change by steven 9/14/2012 mali kasi yung pakakasunod-sunod nung parameter.
		params.put("itemAnnPremAmt", request.getParameter("itemAnnPremAmt").replaceAll(",", ""));
		params.put("noOfDays", (!request.getParameter("noOfDays").equals("") ? request.getParameter("noOfDays") : null));
		params.put("itemToDate", "".equals(request.getParameter("itemToDate")) ? null : 
			df.parse(request.getParameter("itemToDate")));
		params.put("itemFromDate", "".equals(request.getParameter("itemFromDate")) ? null : 
			df.parse(request.getParameter("itemFromDate")));
		params.put("itemCompSw", request.getParameter("itemCompSw"));
		
		System.out.println(request.getParameter("itemFromDate"));
		
		this.gipiWItemPerilDAO.computeTsi(params);
		
		/*String result = null;
		if("SUCCESS".equals(params.get("messageType"))){
			result = params.get("messageType").toString() + ApplicationWideParameters.RESULT_MESSAGE_DELIMITER + params.get("outPremAmt").toString();
		} else {
			result = params.get("messageType").toString() + ApplicationWideParameters.RESULT_MESSAGE_DELIMITER +params.get("message").toString();
		}*/
		//System.out.println(params);
		BigDecimal outAnnTsiAmt = new BigDecimal("0");
		BigDecimal annTsiAmt = new BigDecimal(request.getParameter("annTsiAmt"));
		BigDecimal tsiAmt = new BigDecimal(params.get("tsiAmt").toString());
		outAnnTsiAmt = annTsiAmt.add(tsiAmt);
		
		params.put("outAnnTsiAmt", outAnnTsiAmt);
		
		return new JSONObject(params);
	}

	@Override
	public String checkPerilOnAllItems(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("packParId", request.getParameter("packParId"));
		
		List<Map<String, Object>> noPerilItems = this.getGipiWItemPerilDAO().getItemsWithNoPerils(params);
		if(noPerilItems.size() > 0) {
			String message = "Peril Information are missing for the following items: \n\n";
			String message2 = "";
			Boolean hasPrev = false;
			for(Map<String, Object> items: noPerilItems ) {
				BigDecimal itemNo = (BigDecimal) items.get("itemNo");
				if(hasPrev) {
					message2 += ", "+ String.format("%09d", itemNo.toBigInteger());
				} else {
					message2 += String.format("%09d", itemNo.toBigInteger());
					hasPrev = true;
				}
			}
			return message+message2;
		} else {
			return "SUCCESS";
		}
	}

	@Override
	public String getItemPerilDefaultTag(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemPerilDAO().getItemPerilDefaultTag(params);
	}

	@Override
	public Map<String, Object> validatePremiumAmount(Map<String, Object> params)
			throws SQLException, Exception {
		return this.gipiWItemPerilDAO.validatePremiumAmount(params);
	}

	@Override
	public JSONObject retrievePerils(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("userId", USER.getUserId()); // added by: Nica 06.05.2013
		
		this.gipiWItemPerilDAO.retrievePerils(params);
		
		return new JSONObject(params);
	}

	@Override
	public JSONObject validatePeril(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		
		this.gipiWItemPerilDAO.validatePeril(params);
		
		return new JSONObject(params);
	}

	@Override
	public JSONObject computePremium(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("premAmt", request.getParameter("premAmt").replaceAll(",", ""));
		params.put("tsiAmt", request.getParameter("tsiAmt").replaceAll(",", ""));
		params.put("annTsiAmt", request.getParameter("annTsiAmt").replaceAll(",", ""));
		params.put("annPremAmt", request.getParameter("annPremAmt").replaceAll(",", ""));
		params.put("itemPremAmt", request.getParameter("itemPremAmt").replaceAll(",", ""));
		params.put("itemAnnPremAmt", request.getParameter("itemAnnPremAmt").replaceAll(",", ""));
		params.put("changedTag", (!request.getParameter("changedTag").equals("") ? request.getParameter("changedTag") : null));
		params.put("itemToDate", request.getParameter("itemToDate"));
		params.put("itemFromDate", request.getParameter("itemFromDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("riCommRate", request.getParameter("riCommRate"));	
		params.put("premRate", request.getParameter("premRate"));
		System.out.println("Compute Premium Params: "+params);
		this.gipiWItemPerilDAO.computePremium(params);
		System.out.println("Computed Prem Params: "+params);
		return new JSONObject(params);
	}

	@Override
	public JSONObject computePremiumRate(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("changedTag", (!request.getParameter("changedTag").equals("") ? request.getParameter("changedTag") : null));
		params.put("tsiAmt", request.getParameter("tsiAmt").replaceAll(",", ""));
		params.put("premRt", request.getParameter("premRt"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt").replaceAll(",", ""));
		params.put("annPremAmt", request.getParameter("annPremAmt").replaceAll(",", ""));
		params.put("itemTsiAmt", request.getParameter("itemTsiAmt").replaceAll(",", ""));
		params.put("itemAnnTsiAmt", request.getParameter("itemAnnTsiAmt").replaceAll(",", ""));
		params.put("itemPremAmt", request.getParameter("itemPremAmt").replaceAll(",", ""));
		params.put("itemAnnPremAmt", request.getParameter("itemAnnPremAmt").replaceAll(",", ""));
		params.put("noOfDays", (!request.getParameter("noOfDays").equals("") ? request.getParameter("noOfDays") : null));
		params.put("itemToDate", request.getParameter("itemToDate"));
		params.put("itemFromDate", request.getParameter("itemFromDate"));
		params.put("itemCompSw", request.getParameter("itemCompSw"));
		params.put("recFlag", request.getParameter("recFlag"));
		params.put("coverageCd", request.getParameter("coverageCd"));
		params.put("tariffZone", request.getParameter("tariffZone"));
		params.put("sublineTypeCd", request.getParameter("sublineTypeCd"));
		params.put("motType", request.getParameter("motType"));
		params.put("constructionCd", request.getParameter("constructionCd"));
		params.put("tarfCd", request.getParameter("tarfCd"));

		this.getGipiWItemPerilDAO().computePremiumRate(params);
		
		return new JSONObject(params);
	}

	@Override
	public void saveCopiedPeril(HttpServletRequest request)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setCopiedPeril", prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("setPerils"))));
		params.put("fromItemNo", request.getParameter("fromItemNo"));
		this.getGipiWItemPerilDAO().saveCopiedPeril(params);
	}
	
	@Override
	public void validateBackAllied(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("bascPerlCd", request.getParameter("bascPerlCd"));
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("premAmt", request.getParameter("premAmt"));
		
		JSONArray rows = new JSONArray(request.getParameter("existingPerils"));
		StringBuilder existingPerils = new StringBuilder();
		
		for(int i=0; i<rows.length(); i++){
			if(rows.getJSONObject(i).isNull("recordStatus") || rows.getJSONObject(i).getInt("recordStatus") != -1){
				existingPerils.append(",#@");
				existingPerils.append(rows.getJSONObject(i).getInt("perilCd"));
				existingPerils.append("@");
				existingPerils.append(new BigDecimal(rows.getJSONObject(i).isNull("tsiAmt") ? "0" : rows.getJSONObject(i).getString("tsiAmt")));
				existingPerils.append("@");
				existingPerils.append(new BigDecimal(rows.getJSONObject(i).isNull("annTsiAmt") ? "0" : rows.getJSONObject(i).getString("annTsiAmt")));
				existingPerils.append("@");
				existingPerils.append(rows.getJSONObject(i).getInt("itemNo"));
				existingPerils.append("@");
				existingPerils.append(rows.getJSONObject(i).getString("lineCd"));
				existingPerils.append("@#,");
			}
		}
		params.put("existingPerils", existingPerils.toString());
		System.out.println(params.get("existingPerils"));
		this.getGipiWItemPerilDAO().validateBackAllied(params);
	}

	@Override
	public void updatePlanDetails(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> planParam = new HashMap<String, Object>();
		planParam.put("parId", request.getParameter("parId"));
		planParam.put("planSw", request.getParameter("planSw"));
		planParam.put("planCd", request.getParameter("planCd"));
		planParam.put("planChTag", request.getParameter("planChTag"));
		planParam.put("userId", USER.getUserId());
		this.getGipiWItemPerilDAO().updatePlanDetails(planParam);
	}

	@Override
	public void deleteWitemPerilTariff(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", request.getParameter("parId"));
		param.put("itemNo", request.getParameter("itemNo"));
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("sublineCd", request.getParameter("sublineCd"));
		param.put("appUser", USER.getUserId());
		this.getGipiWItemPerilDAO().deleteWitemPerilTariff(param);
	}

	@Override
	public void updateWithTariffSw(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", request.getParameter("parId"));
		param.put("withTariffSw", request.getParameter("withTariffSw"));
		param.put("userId", USER.getUserId());
		this.getGipiWItemPerilDAO().updateWithTariffSw(param);
	}	

}
