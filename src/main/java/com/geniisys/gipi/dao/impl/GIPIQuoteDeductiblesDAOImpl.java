/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.math.MathContext;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISDeductibleDesc;
import com.geniisys.common.entity.LOV;
import com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;
import com.seer.framework.util.GenericDAOiBatis;


/**
 * The Class GIPIQuoteDeductiblesDAOImpl.
 */
public class GIPIQuoteDeductiblesDAOImpl extends GenericDAOiBatis<GIPIQuoteDeductiblesSummary> implements GIPIQuoteDeductiblesDAO {
	
	/**
	 * Instantiates a new gIPI quote deductibles dao impl.
	 * 
	 * @param persistentClass the persistent class
	 */
	public GIPIQuoteDeductiblesDAOImpl(Class<GIPIQuoteDeductiblesSummary> persistentClass) {
		super(persistentClass);		
	}
	
	/**
	 * Instantiates a new gIPI quote deductibles dao impl.
	 */
	public GIPIQuoteDeductiblesDAOImpl(){
		super(GIPIQuoteDeductiblesSummary.class);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO#getGIPIQuoteDeductiblesSummaryList(int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesSummaryList(int quoteId) throws SQLException {
		log.info("DAO calling getGIPIQuoteDeductiblesSummaryList Params:("+quoteId+")");	
		return getSqlMapClient().queryForList("getAllGIPIQuoteDeduct", quoteId);	//nieko 02162016 replace getGIPIQuoteDeductSummary by getAllGIPIQuoteDeduct
	}

	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO#deleteGIPIQuoteDeductibles(int)
	 */
	public void deleteGIPIQuoteDeductibles(int quoteId) throws SQLException {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("quoteId", quoteId);	
		this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO#saveGIPIQuoteDeductibles(com.geniisys.gipi.entity.GIPIQuoteDeductibles)
	 */
	@Override
	public void saveGIPIQuoteDeductibles(GIPIQuoteDeductibles gipiQuoteDeductibles) throws SQLException {
		//Debug.print("DEDUCTIBLE: " + gipiQuoteDeductibles);
		this.getSqlMapClient().insert("saveGIPIQuoteDeductibles",gipiQuoteDeductibles );
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO#getDeductibleList(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIISDeductibleDesc> getDeductibleList(String lineCd,String sublineCd) throws SQLException {
		log.info("DAO calling getGIPIQuotegetDeductibleList");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		return getSqlMapClient().queryForList("getDeductibleList", params);
		
	}
	
	/* (non-Javadoc)
	 * @see com.seer.framework.util.GenericDAOiBatis#delete(com.seer.framework.util.Entity)
	 */
	@Override
	public void delete(GIPIQuoteDeductiblesSummary object) {

	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.GenericDAOiBatis#findAll()
	 */
	@Override
	public List<GIPIQuoteDeductiblesSummary> findAll() {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.GenericDAOiBatis#findById(java.lang.Object)
	 */
	@Override
	public GIPIQuoteDeductiblesSummary findById(Object id) {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.util.GenericDAOiBatis#save(com.seer.framework.util.Entity)
	 */
	@Override
	public void save(GIPIQuoteDeductiblesSummary object) {

	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO#getDeductibleSum(int)
	 */
	@Override
	public GIPIQuoteDeductibles getDeductibleSum(int quoteId) throws SQLException {
		return (GIPIQuoteDeductibles) getSqlMapClient().queryForObject("getDeductibleSum", quoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteDeductibles> getItemDeductibles(int quoteId)
			throws SQLException {
		return (List<GIPIQuoteDeductibles>) getSqlMapClient().queryForList("getDeductiblesPerItem", quoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesForPackList(
			Integer packQuoteId) throws SQLException {
		return getSqlMapClient().queryForList("getGipiQouteDeductiblesForPack", packQuoteId);
	}
	
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
	@Override
	public void saveGIPIQuoteDeductibles2(Map<String, Object> params)
			throws SQLException {
		System.out.println("DAO now");
		System.out.println(params);
		
		@SuppressWarnings("unchecked")
		List<GIPIQuoteDeductibles> delRows = (List<GIPIQuoteDeductibles>) params.get("delRows");
		@SuppressWarnings("unchecked")
		List<GIPIQuoteDeductibles> setRows = (List<GIPIQuoteDeductibles>) params.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIPIQuoteDeductibles del : delRows){
				this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles3", del);
			}
			for(GIPIQuoteDeductibles set : setRows){	
				System.out.println("test add" + params);
				BigDecimal bdDedRate = set.getDeductibleRate(); //Added by Jerome 11.18.2016 SR 5737
				
				if (bdDedRate != null){
					Double doubleDedRate = bdDedRate.doubleValue();
					BigDecimal newDedRate = new BigDecimal(doubleDedRate, MathContext.DECIMAL64);

					set.setDeductibleRate(newDedRate);
				}
				this.getSqlMapClient().insert("saveGIPIQuoteDeductibles", set);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String checkQuoteDeductible(int globalQuoteId, String deductibleType, int deductibleLevel, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("quoteId", globalQuoteId);
		params.put("itemNo", itemNo);
		params.put("deductibleType", deductibleType);
		params.put("deductibleLevel", deductibleLevel);
		
		this.getSqlMapClient().update("checkQuoteDeductible", params);
		
		return params.get("message").toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<LOV> getQuotePerilList(int quoteId) throws SQLException {
		return getSqlMapClient().queryForList("getQuoteItemPeril", quoteId);
	}
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
}