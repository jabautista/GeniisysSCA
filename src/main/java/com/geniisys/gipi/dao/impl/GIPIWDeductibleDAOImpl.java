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

import com.geniisys.gipi.dao.GIPIWDeductibleDAO;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWDeductibleDAOImpl.
 */
public class GIPIWDeductibleDAOImpl implements GIPIWDeductibleDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWDeductibleDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#getWPolicyDeductibles(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWDeductible> getWPolicyDeductibles(int parId)
			throws SQLException {
	
		log.info("DAO - Retrieving WPolicy Deductibles...");
		List<GIPIWDeductible> wdeductibleList = getSqlMapClient().queryForList("getWPolicyDeductible", parId);
		log.info("DAO - WPolicy Deductible Size(): " + wdeductibleList.size());
		
		return wdeductibleList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#getWItemDeductibles(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWDeductible> getWItemDeductibles(int parId)
			throws SQLException {
		
		log.info("DAO - Retrieving WItem Deductibles...");
		List<GIPIWDeductible> wdeductibleList = getSqlMapClient().queryForList("getWItemDeductible", parId);
		log.info("DAO - WItem Deductible Size(): " + wdeductibleList.size());
		
		return wdeductibleList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#getWPerilDeductibles(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWDeductible> getWPerilDeductibles(int parId)
			throws SQLException {

		log.info("DAO - Retrieving WPeril Deductibles...");
		List<GIPIWDeductible> wdeductibleList = getSqlMapClient().queryForList("getWPerilDeductible", parId);
		log.info("DAO - WPeril Deductible Size(): " + wdeductibleList.size());
		
		return wdeductibleList;
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
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#saveGIPIWDeductible(com.geniisys.gipi.entity.GIPIWDeductible)
	 */
	@Override
	public boolean saveGIPIWDeductible(GIPIWDeductible gipiWDeductible)
			throws SQLException {
		
		log.info("DAO - Inserting WDeductible...");
		this.sqlMapClient.insert("saveWDeductible", gipiWDeductible);
		log.info("DAO - WDeductible inserted.");

		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#deleteAllWPolicyDeductibles(int)
	 */
	@Override
	public boolean deleteAllWPolicyDeductibles(int parId) throws SQLException {
	
		log.info("DAO - Deleting all WPolicy Deductibles... ");
		this.getSqlMapClient().delete("deleteWPolicyDeductibles", parId);
		log.info("DAO - All WPolicy Deductibles deleted.");
		
		return true;
	}	
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#deleteAllWItemDeductibles(int)
	 */
	@Override
	public boolean deleteAllWItemDeductibles(int parId) throws SQLException {
		
		log.info("DAO - Deleting all WItem Deductibles... ");
		this.getSqlMapClient().delete("deleteWItemDeductibles", parId);
		log.info("DAO - All WItem Deductibles deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#deleteAllWPerilDeductibles(int)
	 */
	@Override
	public boolean deleteAllWPerilDeductibles(int parId) throws SQLException {
		
		log.info("DAO - Deleting all WPeril Deductibles... ");
		this.getSqlMapClient().delete("deleteWPerilDeductibles", parId);
		log.info("DAO - All WPeril Deductibles deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#checkWDeductible(int, java.lang.String, int, int)
	 */
	@Override
	public String checkWDeductible(int parId, String deductibleType, int deductibleLevel, int itemNo)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("deductibleType", deductibleType);
		params.put("deductibleLevel", deductibleLevel);
		
		log.info("DAO - Checking WDeductibles... ");
		this.getSqlMapClient().update("checkWDeductibles", params);
		log.info("DAO - WDeductibles cheked.");
		
		return params.get("message").toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWDeductibleDAO#deleteWPerilDeductibles(int, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean deleteWPerilDeductibles(int parId, String lineCd,
			String nbtSublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("nbtSublineCd", nbtSublineCd);
		System.out.println("DAO parId: "+parId);
		System.out.println("DAO lineCd: "+lineCd);
		System.out.println("DAO nbtSublineCd: "+nbtSublineCd);
		log.info("Deleting WDeductibles...");
		this.getSqlMapClient().queryForObject("deleteWPerilDeductiblesBeforeCopyPeril", params);
		log.info("Deleting completed.");
		
		return true;
	}

	@Override
	public boolean deleteAllWPolicyDeductibles2(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		log.info("DAO - Deleting all WPolicy Deductibles... ");
		this.getSqlMapClient().delete("deleteWPolicyDeductibles2", params);
		log.info("DAO - All WPolicy Deductibles deleted.");
		
		return true;
	}

	@Override
	public String isExistGipiWdeductible(int parId, String lineCd,
			String sublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		
		log.info("Par Id - " + parId);
		log.info("Line Cd - " + lineCd);
		log.info("Subline Cd - " + sublineCd);
		
		return (String)this.getSqlMapClient().queryForObject("isExistGipiWdeductible", params);
	}

	@Override
	public boolean deleteGipiWDeductibles2(int parId, String lineCd,
			String sublineCd) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		
		log.info("Par Id - " + parId);
		log.info("Line Cd - " + lineCd);
		log.info("Subline Cd - " + sublineCd);
		
		this.getSqlMapClient().delete("deleteWDeductibles2", params);
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWDeductible> getDeductibleItemAndPeril(int parId, String lineCd,
			String sublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		
		log.info("Par Id - " + parId);
		log.info("Line Cd - " + lineCd);
		log.info("Subline Cd - " + sublineCd);
		
		return this.getSqlMapClient().queryForList("getDeductibleItemAndPeril", params);
	}

	public void insertGIPIWDeductibles(Map<String, Object> insParams, int parId, String lineCd, String sublineCd, String userId) throws SQLException {
		String[] itemNos 			= (String[]) insParams.get("itemNos");
		String[] perilCds 			= (String[]) insParams.get("perilCds");
		String[] deductibleCds 		= (String[]) insParams.get("deductibleCds");
		String[] deductibleAmounts 	= (String[]) insParams.get("deductibleAmounts");
		String[] deductibleRates 	= (String[]) insParams.get("deductibleRates");
		String[] deductibleTexts 	= (String[]) insParams.get("deductibleTexts");
		String[] aggregateSws 		= (String[]) insParams.get("aggregateSws");
		String[] ceilingSws 		= (String[]) insParams.get("ceilingSws");
		
		GIPIWDeductible wdeductible = null;
		
		if (deductibleCds != null) {
			log.info("DAO - Inserting deductibles...");
			for (int i=0; i<deductibleCds.length; i++) {
				wdeductible = new GIPIWDeductible();
				
				wdeductible.setParId(parId); 
				wdeductible.setDedLineCd(lineCd); 
				wdeductible.setDedSublineCd(sublineCd);
				wdeductible.setUserId(userId); 
				wdeductible.setItemNo(Integer.parseInt(itemNos[i]));
				wdeductible.setPerilCd(Integer.parseInt(perilCds[i]));
				wdeductible.setDedDeductibleCd(deductibleCds[i].replaceAll("slash", "/"));
				wdeductible.setDeductibleAmount((deductibleAmounts[i] == null || deductibleAmounts[i] == "" ? null : new BigDecimal(deductibleAmounts[i].replaceAll(",", "")))); 
				wdeductible.setDeductibleRate((deductibleRates[i] == null || deductibleRates[i] == "" ? null : new BigDecimal(deductibleRates[i].replaceAll(",", ""))));
				wdeductible.setDeductibleText(deductibleTexts[i]);
				wdeductible.setAggregateSw((aggregateSws[i] == null || aggregateSws[i] == "" ? "N" : aggregateSws[i]));  
				wdeductible.setCeilingSw((ceilingSws[i] == null || ceilingSws[i] == "" ? "N" : ceilingSws[i]));
				
				this.getSqlMapClient().insert("saveWDeductible", wdeductible);
			}
			log.info("DAO - Deductibles inserted.");
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveDeductibles(Map<String, Object> params) throws SQLException {
		log.info("Saving deductibles ...");
		
		List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductibles");
		List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductibles");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// GIPI_WDEDUCTIBLES (delete)
			for(GIPIWDeductible ded : delDeductibles){
				log.info("Deleting record on gipi_wdeductibles ...");
				this.getSqlMapClient().delete("delGipiWDeductible2", ded);
			}
			
			// GIPI_WDEDUCTIBLES (insert/update)
			for(GIPIWDeductible ded : insDeductibles){
				log.info("Inserting/Updating record on gipi_wdeductibles ...");				
				this.getSqlMapClient().insert("saveWDeductible", ded);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWDeductible> getAllGIPIWDeductibles(Integer parId)
			throws SQLException {
		log.info("Getting all deductibles ...");
		return (List<GIPIWDeductible>) StringFormatter.escapeHTMLJavascriptInList(this.getSqlMapClient().queryForList("getAllGIPIWDeductibles", parId));
	}
}
