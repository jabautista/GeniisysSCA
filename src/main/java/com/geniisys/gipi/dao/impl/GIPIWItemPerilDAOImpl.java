/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemPerilDAOImpl.
 */
public class GIPIWItemPerilDAOImpl implements GIPIWItemPerilDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWItemPerilDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#getGIPIWItemPeril(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getGIPIWItemPeril(Integer parId) throws SQLException {
		//Map<String, Object> params = new HashMap<String, Object>();
		//params.put("parId", parId);
		//params.put("itemNo", itemNo);
		log.info("Getting item perils...");
		log.info("For PAR ID: "+parId);
		List<GIPIWItemPeril> itemPerilListing = (List<GIPIWItemPeril>) this.getSqlMapClient().queryForList("getItemPeril", parId);
		if (!(itemPerilListing != null)){
			log.info("Peril list is null");
		}
		//for (GIPIWItemPeril itemperil: itemPerilListing){
		//	log.info("DAO perilCd: "+itemperil.getPerilCd());
		//}
		log.info("DAO Finish");
		return itemPerilListing;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#insertWItemPeril(com.geniisys.gipi.entity.GIPIWItemPeril)
	 */
	@Override
	public boolean insertWItemPeril(GIPIWItemPeril gipiWItemPeril)
			throws SQLException {
		log.info("DAO - Inserting item peril...");
		System.out.println("parId: "+gipiWItemPeril.getParId());
		System.out.println("itemNo: "+gipiWItemPeril.getItemNo());
		System.out.println("perilCd: "+gipiWItemPeril.getPerilCd());
		System.out.println("linecd: "+gipiWItemPeril.getLineCd());
		System.out.println("premRt: "+gipiWItemPeril.getPremRt());
		System.out.println("tsiAmt: "+gipiWItemPeril.getTsiAmt());
		System.out.println("premAmt: "+gipiWItemPeril.getPremAmt());
		System.out.println("compRem: "+gipiWItemPeril.getCompRem());
		this.getSqlMapClient().insert("addItemPeril", gipiWItemPeril);
		log.info("DAO - Insert successful...");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#deleteWItemPeril(java.lang.Integer, java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@Override
	public boolean deleteWItemPeril(Integer parId, Integer itemNo,
			String lineCd, Integer perilCd) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemNo", itemNo);
		param.put("lineCd", lineCd);
		param.put("perilCd", perilCd);
		
		log.info("DAO - Deleting item peril...");
		this.getSqlMapClient().delete("deleteItemPeril", param);
		log.info("DAO - Deleting successful...");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWItmperl", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#checkDeductibleItemNoIfNull(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String checkDeductibleItemNoIfNull(Integer parId, String lineCd, String nbtSublineCd) throws SQLException {
		log.info("Checking if deductible item no. exists...");
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("PAR ID @ DAO: "+parId);
		System.out.println("LINE CD @ DAO: "+lineCd);
		System.out.println("SUBLINE @ DAO: "+nbtSublineCd);
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", nbtSublineCd);
		String result = (String) this.sqlMapClient.queryForObject("checkDeductiblePerilItemNoIfNull", params);
		log.info("Result: "+result);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#deleteDeductibles(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> deleteDeductibles(Integer parId, Integer itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("DAO parId: "+parId);
		System.out.println("DAO itemNo: "+itemNo);
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().update("deleteDiscounts", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#updateWItem(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean updateWItem(Integer parId, Integer itemNo)
			throws SQLException {
		log.info("Updating GIPIWItem table...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().queryForObject("updateWItem", params);
		log.info("Update successful.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#createWInvoiceForPAR(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean createWInvoiceForPAR(Integer parId, String lineCd,
			String issCd) throws SQLException {
		log.info("Creating winvoice for PAR...");
		log.info("parId: " + parId);
		log.info("lineCd: " + lineCd);
		log.info("issCd: " + issCd);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		System.out.println("DAO -- parId: "+parId);
		System.out.println("DAO -- lineCd: "+lineCd);
		System.out.println("DAO -- issCd: "+issCd);
		this.getSqlMapClient().queryForObject("createWInvoiceForPAR", params);
		log.info("Completed.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#insertPerilToWC(java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@Override
	public boolean insertPerilToWC(Integer parId, String lineCd, Integer perilCd)
			throws SQLException {
		log.info("Inserting peril details into clauses table...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("perilCd", perilCd);
		this.getSqlMapClient().queryForObject("insertPerilToWC", params);
		log.info("Successful.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#deleteOtherDiscount(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean deleteOtherDiscount(Integer parId, Integer itemNo)
			throws SQLException {
		log.info("Deleting other discounts...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().queryForObject("deleteOtherDiscount", params);
		log.info("Deleted.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#isExist(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String isExist(Integer parId, Integer itemNo) throws SQLException {
		log.info("Checking if peril exists...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return (String) this.getSqlMapClient().queryForObject("isExistWItmperlWItemNo", params);
	}

	@Override
	public boolean deleteWItemPeril(List<GIPIWItemPeril> itemPerils)
			throws SQLException {
		log.info("DAO Calling deleteWItemPeril ...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Deleting record/s");
			System.out.println("ParID\tItemNo\tPerilCd");
			System.out.println("=======================================================================================");
			
			for(GIPIWItemPeril p : itemPerils){
				System.out.println(p.getParId() + "\t" + p.getItemNo() + "\t" + p.getPerilCd());
				this.deleteWItemPeril(p.getParId(), p.getItemNo(), p.getLineCd(), p.getPerilCd());
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();			
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
		return false;
	}

	@Override
	public String getIssCdRi() throws SQLException {
		String issCdRi = (String) this.getSqlMapClient().queryForObject("getIssCdRi");
		return issCdRi;
	}

	@Override
	public GIPIWItemPeril getPerilDetails(Map<String, Object> params)
			throws SQLException {
		log.info("Getting peril details...");
		return (GIPIWItemPeril) this.getSqlMapClient().queryForObject("getPerilDetails", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean saveEndtItemPeril(Map<String, Object> allEndtPerilParams)
			throws SQLException, Exception {		
		Map<String, Object> delParams 	= (Map<String, Object>) allEndtPerilParams.get("delParams");
		Map<String, Object> insParams 	= (Map<String, Object>) allEndtPerilParams.get("insParams");
		Map<String, Object> otherParams = (Map<String, Object>) allEndtPerilParams.get("otherParams");
		Map<String, Object> perilDedParams = (Map<String, Object>) allEndtPerilParams.get("perilDedParams");
		String delPercentTsiDeductibles = (String) otherParams.get("delPercentTsiDeductibles");
		Integer parId 				= (Integer) perilDedParams.get("parId");
		Integer packParId			= (Integer) otherParams.get("packParId");
		String issCd				= (String) otherParams.get("issCd");
		String packPolFlag			= (String) otherParams.get("packPolFlag");
		String packLineCd			= (String) otherParams.get("packLineCd");
		String updateEndtTax		= (String) otherParams.get("updateEndtTax");
		String userId				= (String) otherParams.get("userId");
		String lineCd 				= (String) perilDedParams.get("dedLineCd");
		String sublineCd 			= (String) perilDedParams.get("dedSublineCd");
		String[] perilCds 			= (String[]) insParams.get("perilCds");
		BigDecimal parTsiAmount 		= new BigDecimal(otherParams.get("parTsiAmount").toString());
		BigDecimal parAnnTsiAmount 		= new BigDecimal(otherParams.get("parAnnTsiAmount").toString());
		BigDecimal parPremiumAmount 	= new BigDecimal(otherParams.get("parPremiumAmount").toString());
		BigDecimal parAnnPremiumAmount 	= new BigDecimal(otherParams.get("parAnnPremiumAmount").toString());
		
		try {
			log.info("DAO - Saving Endorsement Item Peril/s...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
		
			this.deleteEndtDiscounts((String) otherParams.get("delDiscounts"), (Integer) insParams.get("parId")); 
			this.deleteEndtItemPeril(delParams);
			this.insertEndtItemPeril(insParams);
			this.insertDeductible(perilDedParams, 3);
			this.deletePercentTsiDeductibles(delPercentTsiDeductibles, parId, lineCd, sublineCd);
			this.updateWPolbasAmounts(parId, parTsiAmount, parAnnTsiAmount, parPremiumAmount, parAnnPremiumAmount); 					
			this.updatePackWPolbasAmounts(packParId, parTsiAmount, parAnnTsiAmount, parPremiumAmount, parAnnPremiumAmount);
			this.deleteBill(parId);
			this.populateOrigItemPeril(parId);
			
			if(perilCds != null){
				this.createWInvoice(0, 0, 0, parId, ("Y".equals(packPolFlag) ? packLineCd : lineCd), issCd);
			
				if ("Y".equals(updateEndtTax)){
					this.createWInvoice1EndtItemPeril(parId, lineCd, issCd);					
				}				
			} 
			
			this.insertParHist(parId, userId, null, "5");			
			this.updateParStatusEndtItemPeril(parId, packParId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("DAO - Endorsement Item Peril/s saved.");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return true;
	}
	
	@SuppressWarnings("unchecked")
	public boolean saveEndtItemPeril2(Map<String, Object> allEndtPerilParams)
			throws SQLException, Exception {		
		Map<String, Object> delParams 	= (Map<String, Object>) allEndtPerilParams.get("delParams");
		Map<String, Object> insParams 	= (Map<String, Object>) allEndtPerilParams.get("insParams");
		Map<String, Object> otherParams = (Map<String, Object>) allEndtPerilParams.get("otherParams");
		Map<String, Object> perilDedParams = (Map<String, Object>) allEndtPerilParams.get("perilDedParams");
		String delPercentTsiDeductibles = (String) otherParams.get("delPercentTsiDeductibles");
		Integer parId 				= (Integer) perilDedParams.get("parId");
		Integer packParId			= (Integer) otherParams.get("packParId");
		String issCd				= (String) otherParams.get("issCd");
		String packPolFlag			= (String) otherParams.get("packPolFlag");
		String packLineCd			= (String) otherParams.get("packLineCd");
		String updateEndtTax		= (String) otherParams.get("updateEndtTax");
		String userId				= (String) otherParams.get("userId");
		String lineCd 				= (String) perilDedParams.get("dedLineCd");
		String sublineCd 			= (String) perilDedParams.get("dedSublineCd");
		String[] perilCds 			= (String[]) insParams.get("perilCds");
		BigDecimal parTsiAmount 		= new BigDecimal(otherParams.get("parTsiAmount").toString());
		BigDecimal parAnnTsiAmount 		= new BigDecimal(otherParams.get("parAnnTsiAmount").toString());
		BigDecimal parPremiumAmount 	= new BigDecimal(otherParams.get("parPremiumAmount").toString());
		BigDecimal parAnnPremiumAmount 	= new BigDecimal(otherParams.get("parAnnPremiumAmount").toString());
		
		log.info("DAO - Saving Endorsement Item Peril/s...");
	
		this.deleteEndtDiscounts((String) otherParams.get("delDiscounts"), (Integer) insParams.get("parId")); 
		this.deleteEndtItemPeril(delParams);
		this.insertEndtItemPeril(insParams);
		this.insertDeductible(perilDedParams, 3);
		this.deletePercentTsiDeductibles(delPercentTsiDeductibles, parId, lineCd, sublineCd);
		this.updateWPolbasAmounts(parId, parTsiAmount, parAnnTsiAmount, parPremiumAmount, parAnnPremiumAmount); 					
		this.updatePackWPolbasAmounts(packParId, parTsiAmount, parAnnTsiAmount, parPremiumAmount, parAnnPremiumAmount);
		this.deleteBill(parId);
		this.populateOrigItemPeril(parId);
		
		if(perilCds != null){
			this.createWInvoice(0, 0, 0, parId, ("Y".equals(packPolFlag) ? packLineCd : lineCd), issCd);
		
			if ("Y".equals(updateEndtTax)){
				this.createWInvoice1EndtItemPeril(parId, lineCd, issCd);					
			}				
		} 
		
		this.insertParHist(parId, userId, null, "5");			
		this.updateParStatusEndtItemPeril(parId, packParId);

		log.info("DAO - Endorsement Item Peril/s saved.");

		return true;
	}
	
	private boolean updateParStatusEndtItemPeril(Integer parId, Integer packParId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packParId", packParId);
		
		this.getSqlMapClient().update("updateParStatusEndtItemPeril", params);
		
		return true;
	}
	
	private boolean insertParHist(Integer parId, String userId, String entrySource, String parStatusCd) 
	  throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("userId", userId);
		params.put("entrySource", entrySource);
		params.put("parStatusCd", parStatusCd);
		
		this.getSqlMapClient().insert("insertParHistory", params);
		
		return true;
	}
	
	private boolean createWInvoice1EndtItemPeril(Integer parId, String lineCd, String issCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		
		this.getSqlMapClient().update("createWInvoice1EndtItemPeril", params);
		return true;
	}
	
	private boolean createWInvoice(Integer policyId, Integer polIdN, Integer oldPolicyId, Integer parId, String lineCd, String issCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("polIdN", polIdN);
		params.put("oldParId", oldPolicyId);
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		
		this.getSqlMapClient().update("createWInvoice", params);
	
		return true;
	}
	
	private boolean populateOrigItemPeril(Integer parId) throws SQLException {
		this.getSqlMapClient().delete("populateOrigItemPeril", parId);
		return true;
	}
	
	private boolean deleteBill(Integer parId) throws SQLException{		
		this.getSqlMapClient().delete("deleteBillOnItem", parId);		
		return true;
	}
	
	private boolean updatePackWPolbasAmounts(Integer packParId, BigDecimal tsiAmount, BigDecimal annTsiAmount, BigDecimal premiumAmount, BigDecimal annPremiumAmount)
	  throws SQLException {
		
		if (packParId != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("packParId", packParId);
			params.put("tsiAmt", tsiAmount);
			params.put("annTsiAmt", annTsiAmount);
			params.put("premAmt", premiumAmount);
			params.put("annPremAmt", annPremiumAmount);
			
			this.getSqlMapClient().update("updatePackWPolbasAmounts", params);			
		}
		
		return true;
	}
	private boolean updateWPolbasAmounts(int parId, BigDecimal tsiAmount, BigDecimal annTsiAmount, BigDecimal premiumAmount, BigDecimal annPremiumAmount) 
	  throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("tsiAmt", tsiAmount);
		params.put("annTsiAmt", annTsiAmount);
		params.put("premAmt", premiumAmount);
		params.put("annPremAmt", annPremiumAmount);
		
		this.getSqlMapClient().update("updateWPolbasAmounts", params);
		
		return true;
	}
	
	private boolean deletePercentTsiDeductibles(String delPercentTsiDeductibles, int parId, String lineCd, String sublineCd) throws SQLException {
		if (delPercentTsiDeductibles == "Y"){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("lineCd", lineCd);
			params.put("sublineCd", sublineCd);
			
			this.getSqlMapClient().delete("deleteWPolicyDeductibles2", params);
		}
		return true;
	}
	
	private boolean deleteEndtItemPeril(Map<String, Object> delParams) throws SQLException {
		
		String[] perilCds = (String[]) delParams.get("perilCds");
		String[] itemNos  = (String[]) delParams.get("itemNos");
		int parId  		  = (Integer) delParams.get("parId");
		String lineCd	  = (String) delParams.get("lineCd");
		
		if (perilCds != null){
			log.info("DAO - Deleting Endorsement Item Peril/s...");
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("lineCd", lineCd);
			
			for (int i = 0; i < perilCds.length; i++){								
				params.put("itemNo", itemNos[i]);
				params.put("perilCd", perilCds[i]);
				
				this.getSqlMapClient().delete("deleteWDeductiblesPeril", params);
				this.getSqlMapClient().delete("deleteEndtItemPeril", params);
			}
			log.info("DAO - " + perilCds.length + " Endorsement Item Peril/s deleted");
		}
		
		return true;
	}
		
	private boolean insertEndtItemPeril(Map<String, Object> insParams) throws SQLException{
		
		System.out.println("1");
		String[] perilCds 			= (String[]) insParams.get("perilCds");
		String[] itemNos  			= (String[]) insParams.get("itemNos");
		String[] premiumRates  		= (String[]) insParams.get("premiumRates");
		String[] tsiAmounts  		= (String[]) insParams.get("tsiAmounts");
		String[] annTsiAmounts 		= (String[]) insParams.get("annTsiAmounts");
		String[] premiumAmounts  	= (String[]) insParams.get("premiumAmounts");
		String[] annPremiumAmounts 	= (String[]) insParams.get("annPremiumAmounts");
		String[] remarks 			= (String[]) insParams.get("remarks");
		String[] wcSws				= (String[]) insParams.get("wcSws");
		
		int parId  		  = (Integer) insParams.get("parId");
		String lineCd	  = (String) insParams.get("lineCd");
		
		if (perilCds != null){
			System.out.println("2");	
			log.info("DAO - Inserting Endorsement Item Peril/s...");
			
			GIPIWItemPeril endtPeril = null;
			
			for (int i = 0; i < perilCds.length; i++){
				System.out.println("3");	
				endtPeril = new GIPIWItemPeril();
				
				endtPeril.setParId(parId);
				System.out.println("DAO lineCd: "+lineCd);
				endtPeril.setLineCd(lineCd);
				endtPeril.setItemNo(Integer.parseInt(itemNos[i]));
				endtPeril.setPerilCd(Integer.parseInt(perilCds[i]));
				endtPeril.setPremRt(new BigDecimal(premiumRates[i]));
				endtPeril.setTsiAmt(new BigDecimal(tsiAmounts[i]));
				endtPeril.setAnnTsiAmt(new BigDecimal(annTsiAmounts[i]));
				endtPeril.setPremAmt(new BigDecimal(premiumAmounts[i]));
				endtPeril.setAnnPremAmt(new BigDecimal(annPremiumAmounts[i]));
				endtPeril.setCompRem(remarks[i]);

				this.getSqlMapClient().insert("insertEndtItemPeril", endtPeril);
				
				if("Y".equals(wcSws[i])){
					this.includeWC(parId, lineCd, Integer.parseInt(perilCds[i]));
				}
			}
			log.info("DAO - " + perilCds.length + " Endorsement Item Peril/s inserted.");
		}
		
		System.out.println("4");	
		
		return true;
	}

	public Map<String, Object> checkEndtPeril(Map<String, Object> params) throws SQLException{
		
		log.info("DAO - Checking Endorsement Item Peril...");
		this.getSqlMapClient().update("checkEndtPeril", params);
		log.info("DAO - Endorsement Item Peril checked.");
		
		return params;
	}
	
/*	public Map<String, Object> computePremium(Map<String, Object> params) throws SQLException{
		
		log.info("DAO - Computing premium...");
		this.getSqlMapClient().update("computePremium", params);		
		log.info("DAO - Premium computed.");
		System.out.println(params);
		
		return params;
	}	*/
	
	@SuppressWarnings("unchecked")
	public List<GIPIWItemPeril> getEndtItemPeril(int parId) throws SQLException{
		
		log.info("DAO - Checking Endorsement Item Peril...");
		List<GIPIWItemPeril> endtPerils = this.getSqlMapClient().queryForList("getEndtPeril", parId);
		log.info("DAO - " + endtPerils.size() + " Endorsement Item Peril checked.");
		
		return endtPerils;
	}	
	
	private boolean includeWC(int parId, String lineCd, int perilCd) throws SQLException{
		
		Map<String, Object> includeWCParams = new HashMap<String, Object>();
		includeWCParams.put("parId", parId);
		includeWCParams.put("lineCd", lineCd);
		includeWCParams.put("perilCd", perilCd);
		
		log.info("DAO - Including Warranties and Clauses...");
		this.getSqlMapClient().insert("includeWC", includeWCParams);
		log.info("DAO - Warranties and Clauses included.");

		return true;
	}
	
	public boolean insertDeductible(Map<String, Object> parameters, int deductibleLevel)
			throws SQLException {
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
		
		this.getSqlMapClient().delete("deleteWPerilDeductibles", parId);
		
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
				wdeductible.setDeductibleAmount((deductibleAmounts[i] == null || deductibleAmounts[i] == "" ? new BigDecimal("0") : new BigDecimal(deductibleAmounts[i].replaceAll(",", "")))); 
				wdeductible.setDeductibleRate((deductibleRates[i] == null || deductibleRates[i] == "" ? new BigDecimal("0") : new BigDecimal(deductibleRates[i].replaceAll(",", ""))));
				wdeductible.setDeductibleText(deductibleTexts[i]);
				wdeductible.setAggregateSw((aggregateSws[i] == null || aggregateSws[i] == "" ? "N" : aggregateSws[i]));  
				wdeductible.setCeilingSw((ceilingSws[i] == null || ceilingSws[i] == "" ? "N" : ceilingSws[i])); 
					
				this.getSqlMapClient().insert("saveWDeductible", wdeductible);
			}
		}
		
		return true;
	}	
	
	public boolean deleteEndtDiscounts(String delDiscounts, int parId) throws SQLException {
		
		if (delDiscounts.equals("Y")){
			log.info("DAO - Deleting Discounts...");
			this.getSqlMapClient().update("deleteEndtDiscounts", parId);
			log.info("DAO - Discounts deleted.");			
		}	
		
		return true;
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#isExist2(int, int)
	 */
	@Override
	public String isExist2(int parId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return (String)this.getSqlMapClient().queryForObject("isExistWItmperl2", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#checkIfParItemHasPeril(int, int)
	 */
	@Override
	public String checkIfParItemHasPeril(int parId, int itemNo)
			throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo",itemNo);
		return (String)this.getSqlMapClient().queryForObject("checkIfParItemHasPeril", params);
	}

/*	@SuppressWarnings("unchecked")
	public List<GIPIWItemPeril> retrievePeril (int policyId, int itemNo)
			throws SQLException {
							
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Endorsement Item Peril/s...");
		List<GIPIWItemPeril> perils = this.getSqlMapClient().queryForList("retrievePeril", params);
		log.info("DAO - " + perils.size() + " Endorsement Item Peril/s retrieved.");
		
		return perils; 
	}*/	


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemPerilDAO#deleteWItemPeril2(int, int)
	 */
	@Override
	public void deleteWItemPeril2(int parId, int itemNo) throws SQLException {		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemNo", itemNo);
		log.info("DAO - Deleting item peril...");
		this.getSqlMapClient().delete("deleteItemPeril2", param);
		log.info("DAO - Deleting successful...");
	}

	@Override
	public Integer getEndtTariff(Map<String, Object> params)
			throws SQLException {
		
		log.info("DAO - Retrieving Endorsement Item Peril tariff...");
		Integer tariff = this.getSqlMapClient().update("getEndtTariff", params);
		log.info("DAO - Endorsement Item Peril tariff retrieved.");		
		
		return tariff;
	}

	@Override
	public GIPIWItemPeril getPostTextTsiAmtDetails(Map<String, Object> params)
			throws SQLException {
		log.info("Getting post-text details for TSI...");
		/*params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("perilCd", perilCd);
				params.put("premRt", premRt);
				params.put("tsiAmt", tsiAmt);
				params.put("premAmt", premAmt);
				params.put("annTsiAmt", annTsiAmt);
				params.put("annPremAmt", annPremAmt);
				params.put("itemTsiAmt", itemTsiAmt);
				params.put("itemPremAmt", itemPremAmt);
				params.put("itemAnnTsiAmt", itemAnnTsiAmt);
				params.put("itemAnnPremAmt", itemAnnPremAmt);
		 * */
		 
		log.info("parId: "+params.get("parId"));
		log.info("itemNo: "+params.get("itemNo"));
		log.info("perilCd: "+params.get("perilCd"));
		log.info("premRt: "+params.get("premRt"));
		log.info("tsiAmt: "+params.get("tsiAmt"));
		log.info("premAmt: "+params.get("premAmt"));
		log.info("annTsiAmt: "+params.get("annTsiAmt"));
		log.info("annPremAmt: "+params.get("annPremAmt"));
		log.info("itemTsiAmt: "+params.get("itemTsiAmt"));
		log.info("itemPremAmt: "+params.get("itemPremAmt"));
		log.info("itemAnnTsiAmt: "+params.get("itemAnnTsiAmt"));
		log.info("itemAnnPremAmt: "+params.get("itemAnnPremAmt"));
		GIPIWItemPeril a = (GIPIWItemPeril) this.getSqlMapClient().queryForObject("getPostTextTsiAmtDetails", params);
		log.info("premAmt: "+a.getPerilPremAmt());
		log.info("tsiAmt: "+a.getPerilTsiAmt());
		return a;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getNegateItemPerils(Map<String, Object> params)
			throws SQLException {
		log.info("Getting negated item perils for par id -"+params.get("parId")+"- item no -"+params.get("itemNo"));
		List<GIPIWItemPeril> itmPerlList = this.getSqlMapClient().queryForList("getNegateItemPerils", params);
		return itmPerlList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNegateDeleteItem(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			List<Map<String, Object>> setItems	= (List<Map<String, Object>>) params.get("setItems");
			
			// GIPI_WITEM (insert/update)			
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
			}
			
			this.getSqlMapClient().queryForObject("getNegateDeletedItem", params);
			//this.getSqlMapClient().getCurrentConnection().rollback(); //edgar 01/23/2015
			this.getSqlMapClient().getCurrentConnection().commit(); //edgar 01/23/2015
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getMaintainedPerilListing(Map<String, Object> params)
			throws SQLException {
		log.info("Getting maintained perils listing for parId - "+params.get("parId")+"...");
		return this.getSqlMapClient().queryForList("getMaintainedPerilListing", params);
	}	
	
	@SuppressWarnings("unchecked")
	public void updateItemPerilRecords(Map<String, Object> param) throws SQLException {
		Map<String, Object> others	= (Map<String, Object>) param.get("others");
		Map<String, Object> globals = (Map<String, Object>) param.get("globals");
		String delDiscItemNos = (String) param.get("deldiscItemNos");
		String[] masterItemNos = (String[]) param.get("masterItemNos");
		Integer parId = (Integer) param.get("parId");
		
		if ("Y".equals(param.get("delDiscSw"))){
			log.info("Deleting discounts in all levels for par_id "+parId);
			this.getSqlMapClient().delete("deleteAllDiscounts", parId);
		}
		
		//ALL GIPIS038 PROCEDURES BEFORE INSERT/DELETE/UPDATE PERIL DATA
		if ((param.get("delPerils") != null && ((List<Map<String, Object>>) param.get("delPerils")).size() > 0)
				|| (param.get("setPerils") != null && ((List<Map<String, Object>>) param.get("setPerils")).size() > 0)){
			log.info("Saving item peril ...");
			
			//DEDUCT DISCOUNTS
			/*if ("".equals(delDiscItemNos)){ /
				//do nothing
			} else {*/
			if(delDiscItemNos != null){
				log.info("Deleting discounts...");
				Map<String, Object> delDiscParams = new HashMap<String, Object>();
				delDiscParams.put("parId", parId); //Integer.parseInt(globals.get("globalParId").toString())); //belle 03242011
				delDiscParams.put("itemNo", Integer.parseInt(delDiscItemNos));
				this.getSqlMapClient().update("deleteDiscounts", delDiscParams);
			}
			
			//DELETE OTHER DISCOUNTS
			if(masterItemNos != null && masterItemNos.length > 0){
				Map<String, Object> perilMap = null;
				for(int i=0, length=masterItemNos.length; i<length; i++){
					System.out.println("masterItemNos: "+masterItemNos[i]);
					perilMap = new HashMap<String, Object>();
					perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
					perilMap.put("itemNo", Integer.parseInt(masterItemNos[i]));
					System.out.println("delDiscSw: "+others.get("delDiscSw"));
					if("Y".equals((String) others.get("delDiscSw"))){
						log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo") + ") - Deleting other discount ...");
						this.getSqlMapClient().queryForObject("deleteOtherDiscount", perilMap);
					}
					perilMap = null;
				}
			}
		}
		
		//DELETE
		if(param.get("delPerils") != null && ((List<Map<String, Object>>) param.get("delPerils")).size() > 0){			
			for(GIPIWItemPeril p : (List<GIPIWItemPeril>) param.get("delPerils")){
				Map<String, Object> perilMap = new HashMap<String, Object>();
				perilMap.put("parId", p.getParId());
				perilMap.put("itemNo", p.getItemNo());
				perilMap.put("lineCd", p.getLineCd());
				perilMap.put("perilCd", p.getPerilCd());
				log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo") + ", perilCd= "+perilMap.get("perilCd")+") - Deleting item peril ...");
				this.getSqlMapClient().delete("deleteItemPeril", perilMap);
			}
		}
		
		//INSERT AND UPDATE
		
		if(param.get("setPerils") != null && ((List<Map<String, Object>>) param.get("setPerils")).size() > 0){
			for(GIPIWItemPeril p : (List<GIPIWItemPeril>) param.get("setPerils")){
				log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Inserting record to peril ...");	
				log.info("tsiAmt: "+p.getTsiAmt());
				log.info("premRt: "+p.getPremRt());
				log.info("premAmt: "+p.getPremAmt());
				log.info("parId: "+p.getParId());
				log.info("itemNo: "+p.getItemNo());
				log.info("perilCd: "+p.getPerilCd());
				this.getSqlMapClient().insert("addItemPeril", p);
			}				
		}
			
/*		//ALL GIPIS038 PROCEDURES AFTER INSERT/DELETE/UPDATE PERIL DATA
		
		//adds warranty and clauses
		Map<String, Object> perilMap = null;
		if(param.get("setWCs") != null && ((List<GIPIWPolicyWarrantyAndClause>) param.get("setWCs")).size() > 0){
			for (GIPIWPolicyWarrantyAndClause wc : (List<GIPIWPolicyWarrantyAndClause>) param.get("setWCs")){
				log.info("Inserting warranties and clauses...");
				this.getSqlMapClient().queryForObject("saveWPolWC", wc);
			}
		}
		
		if ((param.get("delPerils") != null && ((List<Map<String, Object>>) param.get("delPerils")).size() > 0)
				|| (param.get("setPerils") != null && ((List<Map<String, Object>>) param.get("setPerils")).size() > 0)){
		
			//DELETE BILLS
			log.info("Item Peril (parId=" + parId + ") - Deleting bill details ...");
			//Map<String, Object> parParam = new HashMap<String, Object>();
			//parParam.put("parId", parId);
			this.getSqlMapClient().delete("deleteBills", parId);
			
			//INSERT TO PARHIST
			log.info("Item Peril (parId=" + parId + ") - Inserting record to parhist ...");
			perilMap = new HashMap<String, Object>();
			perilMap.put("parId", parId);
			perilMap.put("userId", param.get("userId"));
			perilMap.put("entrySource", "");
			perilMap.put("parstatCd", "5");					
			this.getSqlMapClient().queryForObject("insertPARHist", perilMap);
			perilMap = null;
			
			//UPDATE PACK WPOLBAS
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Updating pack_wpolbas ...");
				this.getSqlMapClient().update("updatePackWPolbas", Integer.parseInt(param.get("globalPackParId").toString()));
			}
			//log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Deleting bill details ...");
			//this.getSqlMapClient().queryForObject("deleteBillsDetails", p.getParId());
			
			//CREATE WINVOICE
			System.out.println("PACK PAR ID ------>"+param.get("globalPackParId"));
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 1...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("lineCd", (String) param.get("lineCd"));
				perilMap.put("issCd", (String) param.get("issCd"));		
				log.info("parId: "+perilMap.get("parId"));
				log.info("lineCd: "+perilMap.get("lineCd"));
				log.info("issCd: "+perilMap.get("issCd"));
				this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				perilMap = null;
			}else{
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("lineCd", (String) param.get("lineCd"));
				perilMap.put("issCd", (String) param.get("issCd"));						
				log.info("parId: "+perilMap.get("parId"));
				log.info("lineCd: "+perilMap.get("lineCd"));
				log.info("issCd: "+perilMap.get("issCd"));
				if("Y".equals((String) param.get("globalPackPolFlag"))){
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 2...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}else{
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 3...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}
				
				perilMap = null;
			}
			
			//GET TSI
			log.info("Item Peril (parId=" + parId + ") - Getting tsi amt ...");
			this.getSqlMapClient().queryForObject("getTsi2", parId);
			
			//SETTING PAR STATUS WITH PERIL
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("packParId", Integer.parseInt(param.get("globalPackParId").toString()));						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril", perilMap);
				perilMap = null;
			}else{
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril1", Integer.parseInt(param.get("parId").toString()));						
			}
			
			//SETTING PLAN DETAILS
			log.info("Updating plan details...");
			//String planSw = (String) others.get("planSw");
			System.out.println("PLANCD: "+param.get("planCd"));
			//Integer planCd = (others.get("planCd")).equals(null) ? null : (Integer) others.get("planCd");
			Map<String, Object> planParam = new HashMap<String, Object>();
			planParam.put("parId", parId);
			planParam.put("planSw", param.get("planSw"));
			planParam.put("planCd", param.get("planCd"));
			planParam.put("planChTag", param.get("planChTag"));
			planParam.put("userId", param.get("userId"));
			this.getSqlMapClient().queryForObject("updatePlanDetails", planParam);
			if (!("0".equals(param.get("globalPackParId")))){
				this.getSqlMapClient().queryForObject("updatePackPlanDetails", planParam);
			}
		}*/
	}

	@SuppressWarnings("unchecked")
	@Override
	public void parItemPerilPostFormsCommit(Map<String, Object> param)
			throws SQLException {
		Map<String, Object> perilMap = null;
		Integer parId = (Integer) param.get("parId");
		//ALL GIPIS038 PROCEDURES AFTER INSERT/DELETE/UPDATE PERIL DATA
		
		//adds warranty and clauses		
		if(param.get("setWCs") != null && ((List<GIPIWPolicyWarrantyAndClause>) param.get("setWCs")).size() > 0){
			for (GIPIWPolicyWarrantyAndClause wc : (List<GIPIWPolicyWarrantyAndClause>) param.get("setWCs")){
				log.info("Inserting warranties and clauses...");
				wc.setUserId((String) param.get("userId"));	//added by Gzelle 09122014
				this.getSqlMapClient().queryForObject("saveWPolWC", wc);
			}
		}
		
		if ((param.get("delPerils") != null && ((List<Map<String, Object>>) param.get("delPerils")).size() > 0)
				|| (param.get("setPerils") != null && ((List<Map<String, Object>>) param.get("setPerils")).size() > 0)){
			
			//added by: Nica 06.25.2012 - to delete %TSI deductible
//			Map<String, Object> perilDeductMap = new HashMap<String, Object>();
//			perilDeductMap.put("parId", parId);
//			perilDeductMap.put("lineCd", param.get("lineCd"));
//			perilDeductMap.put("nbtSublineCd", param.get("sublineCd"));
//			perilDeductMap.put("userId", param.get("userId"));
//			log.info("Deleting deductibles of %TSI: "+perilDeductMap);
//			this.getSqlMapClient().delete("deleteWPerilDeductiblesBeforeCopyPeril", perilDeductMap); //remove by steven 10/23/2012 - it delete the deductible even if it is newly added.
			
			//DELETE BILLS
			log.info("Item Peril (parId=" + parId + ") - Deleting bill details ...");
			//Map<String, Object> parParam = new HashMap<String, Object>();
			//parParam.put("parId", parId);
			this.getSqlMapClient().delete("deleteBills", parId);
			
			//Apollo 09.30.2014 - deletes co-insurance details
			log.info("Deleting co-insurance details...");
			this.getSqlMapClient().delete("delAllRelatedCoInsRecs", parId);
			
			//INSERT TO PARHIST
			log.info("Item Peril (parId=" + parId + ") - Inserting record to parhist ...");
			perilMap = new HashMap<String, Object>();
			perilMap.put("parId", parId);
			perilMap.put("userId", param.get("userId"));			
			perilMap.put("entrySource", "");
			perilMap.put("parstatCd", "5");					
			this.getSqlMapClient().queryForObject("insertPARHist", perilMap);
			perilMap = null;
			
			//UPDATE PACK WPOLBAS
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Updating pack_wpolbas ...");
				this.getSqlMapClient().update("updatePackWPolbas", Integer.parseInt(param.get("globalPackParId").toString()));
			}
			//log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Deleting bill details ...");
			//this.getSqlMapClient().queryForObject("deleteBillsDetails", p.getParId());
			
			//CREATE WINVOICE			
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 1...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("appUser", param.get("userId"));
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("lineCd", (String) param.get("lineCd"));
				perilMap.put("issCd", (String) param.get("issCd"));		
				log.info("parId: "+perilMap.get("parId"));
				log.info("lineCd: "+perilMap.get("lineCd"));
				log.info("issCd: "+perilMap.get("issCd"));
				this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				perilMap = null;
			}else{
				perilMap = new HashMap<String, Object>();
				perilMap.put("appUser", param.get("userId"));
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("lineCd", (String) param.get("lineCd"));
				perilMap.put("issCd", (String) param.get("issCd"));						
				log.info("parId: "+perilMap.get("parId"));
				log.info("lineCd: "+perilMap.get("lineCd"));
				log.info("issCd: "+perilMap.get("issCd"));
				if("Y".equals((String) param.get("globalPackPolFlag"))){
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 2...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}else{
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par 3...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}
				
				perilMap = null;
			}
			
			//GET TSI
			log.info("Item Peril (parId=" + parId + ") - Getting tsi amt ...");
			this.getSqlMapClient().queryForObject("getTsi2", parId);
			
			//SETTING PAR STATUS WITH PERIL
			if(param.get("globalPackParId") != null && Integer.parseInt(param.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(param.get("parId").toString()));
				perilMap.put("packParId", Integer.parseInt(param.get("globalPackParId").toString()));						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril", perilMap);
				perilMap = null;
			}else{
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril1", Integer.parseInt(param.get("parId").toString()));						
			}
			
			//SETTING PLAN DETAILS
			log.info("Updating plan details...");
			//String planSw = (String) others.get("planSw");
			System.out.println("PLANCD: "+param.get("planCd"));
			//Integer planCd = (others.get("planCd")).equals(null) ? null : (Integer) others.get("planCd");
			Map<String, Object> planParam = new HashMap<String, Object>();
			planParam.put("parId", parId);
			planParam.put("planSw", param.get("planSw"));
			planParam.put("planCd", param.get("planCd"));
			planParam.put("planChTag", param.get("planChTag"));
			planParam.put("userId", param.get("userId"));
			this.getSqlMapClient().queryForObject("updatePlanDetails", planParam);
			if (!("0".equals(param.get("globalPackParId")))){
				this.getSqlMapClient().queryForObject("updatePackPlanDetails", planParam);
			}
			
			// added by: Nica 08.01.2012 - to update the min_prem_flag column of gipi_wpolbas
			log.info("Update min_prem_flag with min_prem_flag="+ param.get("minPremFlag")+" ? "+ param.get("updateMinPremFlag"));
			if(param.get("updateMinPremFlag").equals("Y")){
				Map<String, Object> minPremMap = new HashMap<String, Object>();
				Integer minPremFlag = param.get("minPremFlag").equals("") ? null : Integer.parseInt((String) param.get("minPremFlag"));
				minPremMap.put("userId", param.get("userId"));
				minPremMap.put("minPremFlag", minPremFlag);
				minPremMap.put("parId", parId);
				this.getSqlMapClient().update("updateMinPremFlag", minPremMap);
			}
		}	
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWItemPeril(Map<String, Object> params)
			throws SQLException {
		
		List<GIPIWItemPeril> setPerils	= (List<GIPIWItemPeril>) params.get("setPerils");
		List<GIPIWItemPeril> delPerils	= (List<GIPIWItemPeril>) params.get("delPerils");
		
		for(GIPIWItemPeril delPeril: delPerils){
			Map<String, Object> perilMap = new HashMap<String, Object>();
			perilMap.put("parId", delPeril.getParId());
			perilMap.put("itemNo", delPeril.getItemNo());
			perilMap.put("lineCd", delPeril.getLineCd());
			perilMap.put("perilCd", delPeril.getPerilCd());
			System.out.println("Deleting peril record: "+ perilMap);
			this.getSqlMapClient().insert("deleteItemPeril", perilMap);
		}
		
		for(GIPIWItemPeril peril: setPerils){
			System.out.println("Inserting peril record: "+ peril);
			this.getSqlMapClient().insert("addItemPeril", peril);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void endtItemPerilPostFormsCommit(Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> defaultWCs = (List<Map<String, Object>>) params.get("setWCs");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		System.out.println("PARAMETERS:::" + params);	
		//adds warranty and clauses
		if(defaultWCs != null && defaultWCs.size() > 0){
			for (Map<String, Object> wc : defaultWCs){
				log.info("Inserting warranties and clauses...");
				this.getSqlMapClient().queryForObject("insertPerilDefaultWC", wc);
			}
		}
		
		//for(Map<String, Object> item: setItems){
			paramMap.put("parId", params.get("parId"));
			paramMap.put("userId", params.get("userId"));
			//paramMap.put("itemNo", item.get("itemNo"));
			//paramMap.put("tsiAmt", item.get("tsiAmt"));
			//paramMap.put("annTsiAmt", item.get("annTsiAmt"));
			//paramMap.put("premAmt", item.get("premAmt"));
			//paramMap.put("annPremAmt", item.get("annPremAmt"));		
			paramMap.put("varPackageSw", "N"); // andrew - N muna.. under construction.. :)
			paramMap.put("varDelDiscSw", "N");// andrew - N muna.. under construction.. :)
			paramMap.put("varNegateItem", "N");// andrew - N muna.. under construction.. :)
			System.out.println("endtItemPerilPostFormsCommit PARAMETERS :: " + paramMap);
		
			this.getSqlMapClient().update("endtItemPerilPostFormsCommit", paramMap);
		//}
	}

	public Integer checkPerilExist(Integer parId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkPerilExist", parId);
	}

	@Override
	public String checkItmPerilExists(HashMap<String, Object> params)
			throws SQLException {
		log.info("Checking if item peril exists...");
		return (String) this.getSqlMapClient().queryForObject("checkItemPerilExistsGIPIS065", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemPeril> getGIPIWItemPerilsByItem(Map<String, Object> params) throws SQLException {		
		log.info("Getting item perils by item no ...");		
		return (List<GIPIWItemPeril>) StringFormatter.escapeHTMLInList(this.getSqlMapClient().queryForList("getGIPIWItemPeril", params));
	}

	@Override
	public void computeTsi(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("computeTsi", params);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getItemsWithNoPerils(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getItemsWithNoPerils", params);
	}

	@Override
	public String getItemPerilDefaultTag(Map<String, Object> params)
			throws SQLException {
		System.out.println("getItemPerilDefaultTag - "+params);
		return (String) this.getSqlMapClient().queryForObject("getItemPerilDefaultTag", params);
	}

	@Override
	public Map<String, Object> validatePremiumAmount(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Validate premium amount before: "+params);
		this.getSqlMapClient().update("validatePremiumAmount", params);
		log.info("Validate premium amount after: "+params);
		return params;
	}

	public void retrievePerils(Map<String, Object> params) throws SQLException{
		log.info("Retrieving perils");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("retrievePerils", params);
			this.getSqlMapClient().executeBatch();
			
			// added by: Nica 06.05.2013 - to execute post form commit trigger of GIPIS097
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("parId", (params.get("parId") == null || ("".equals(params.get("parId"))) ? 0 : Integer.parseInt((String) params.get("parId"))));
			paramMap.put("userId", params.get("userId"));
			paramMap.put("varPackageSw", "N"); 
			paramMap.put("varDelDiscSw", "N");
			paramMap.put("varNegateItem", "N");
			this.getSqlMapClient().update("endtItemPerilPostFormsCommit", paramMap);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void validatePeril(Map<String, Object> params) throws SQLException {		
		this.getSqlMapClient().update("gipis097WhenValPeril", params);
	}

	@Override
	public void computePremium(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("gipis097ComputePremium", params);
	}

	@Override
	public void computePremiumRate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gipis097ComputePremiumRate", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveCopiedPeril(Map<String, Object> params)
			throws SQLException, Exception {
		try{
		List<GIPIWItemPeril> setCopiedPeril = (List<GIPIWItemPeril>) params.get("setCopiedPeril");
		
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
		if (setCopiedPeril != null){
			Map<String, Object> perilParams =new HashMap<String, Object>();
			for (GIPIWItemPeril gipiwItemPeril1 : setCopiedPeril) {
				perilParams.put("parId", gipiwItemPeril1.getParId());
				perilParams.put("itemNo",gipiwItemPeril1.getItemNo());
				break;
			}
			log.info("Deleting all Item Peril/s : " + perilParams.toString());
			this.getSqlMapClient().delete("delItemPerilPerItem",perilParams);
			for (GIPIWItemPeril gipiwItemPeril : setCopiedPeril) {
				log.info("Copying Item Peril/s : parId = "+gipiwItemPeril.getParId() +" itemNo = "+gipiwItemPeril.getItemNo());
				this.getSqlMapClient().insert("saveCopiedPeril",gipiwItemPeril);
			}
			perilParams.put("fromItemNo",params.get("fromItemNo"));
			log.info("Copying Item Peril/s Amount" + perilParams.toString());
			this.getSqlMapClient().update("saveCopiedPerilAmt",perilParams);
		}
		log.info("Copying Item Peril/s Successfull");
		this.getSqlMapClient().executeBatch();
		this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
		log.info(e.getMessage());
		this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
		log.info(e.getMessage());
		this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
		this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void validateBackAllied(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateBackAllied", params);
	}

	@Override
	public void updatePlanDetails(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> planParam = new HashMap<String, Object>();
		planParam.put("parId", params.get("parId"));
		planParam.put("planSw", params.get("planSw"));
		planParam.put("planCd", params.get("planCd"));
		planParam.put("planChTag", params.get("planChTag"));
		planParam.put("userId", params.get("userId"));
		this.getSqlMapClient().queryForObject("updatePlanDetails", planParam);
		
	}

	@Override
	public void deleteWitemPerilTariff(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("Deleting Witem Peril Tariff ...");
			this.sqlMapClient.update("deleteWitemPerilTariff", params);
			
			this.getSqlMapClient().executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();		
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void updateWithTariffSw(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("updateWithTariffSw", params);
	}	

}
