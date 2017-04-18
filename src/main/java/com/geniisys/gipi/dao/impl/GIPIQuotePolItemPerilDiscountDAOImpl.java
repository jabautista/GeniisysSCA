package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.controllers.GIPIQuotationController;
import com.geniisys.gipi.dao.GIPIQuotePolItemPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuotePolItemPerilDiscountDAOImpl implements GIPIQuotePolItemPerilDiscountDAO{
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationController.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	
	public void setPolItemPerilDiscount(int quoteId) throws SQLException {
		// TODO Auto-generated method stub
		this.getSqlMapClient().update("setPolItemPerilDiscount", quoteId);
	}

	@SuppressWarnings("unchecked")
	public boolean saveGipiPolItemPerilDetails(int quoteId, BigDecimal gipiQuotePremAmt, Map<String, Object> params) throws Exception {
		log.info("Deleting old basic policy discounts...");
		boolean result = true; 
		Map<String, Object> sequenceListParams = (Map<String, Object>) params.get("oldBasicListToDelete");
		List<GIPIQuotePolicyBasicDiscount> oldBasicListParams =  (List<GIPIQuotePolicyBasicDiscount>) params.get("oldBasic");
		List<GIPIQuoteItem> quoteItemListParams =  (List<GIPIQuoteItem>) params.get("quoteItemList");
		List<GIPIQuotePolicyBasicDiscount> newBasic = (List<GIPIQuotePolicyBasicDiscount>) params.get("newBasic");
		List<GIPIQuoteItemDiscount> newItems = (List<GIPIQuoteItemDiscount>) params.get("newItems");	
		List<GIPIQuoteItemPerilDiscount> newPerils = (List<GIPIQuoteItemPerilDiscount>) params.get("newPerils");	
		List<String> newItemPremAmts = (List<String>) params.get("newItemPremAmts");
		List<String> newPerilPremAmts = (List<String>) params.get("newPerilPremAmts");
		String[] sequenceList =  (String[]) sequenceListParams.get("oldBasicListToDelete");
				
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.deletePolicyDiscount(sequenceList, oldBasicListParams);
			this.deleteItemPerilDiscount(quoteItemListParams);
			this.savePolicyDiscount(newBasic);
			this.saveItemDiscount(newItems);
			this.saveItemPerilDiscount(newPerils);
			this.updateQuotePremAmt(quoteId, gipiQuotePremAmt);
			this.updateQuoteItemPremAmt(quoteId, newItemPremAmts);
			this.updateQuotePerilPremAmt(quoteId, newPerilPremAmts);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return result;
	}
	/**
	 * Saves policy discount.
	 * 
	 * @return boolean result.
	 */
	public boolean savePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list) throws SQLException {
		log.info("Saving Basic Policy Discount...");
		boolean result = true;
		if (list.size()>0){
			log.info("List Size to Save:"+list.size());
			for(GIPIQuotePolicyBasicDiscount polDiscount: list){
				Debug.print(polDiscount);
				this.getSqlMapClient().insert("setGIPIQuotePolicyBasicDiscount", polDiscount);		
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}
	
	/**
	 * Deletes policy discount.
	 * 
	 * @return boolean.
	 */
	public boolean deletePolicyDiscount(String[] sequenceList, List<GIPIQuotePolicyBasicDiscount> oldBasicListParams) throws SQLException{
		log.info("DAO - Deleting Policy Discount...");
		for(int i=0; i < sequenceList.length; i++){
			for(GIPIQuotePolicyBasicDiscount polDiscount: oldBasicListParams){
				if(Integer.parseInt(sequenceList[i]) == polDiscount.getSequenceNo()){
					this.getSqlMapClient().delete("deleteGIPIQuotePolicyBasicDiscount", polDiscount);
				}
			}
		}
		return true;
	}
	/**
	 * Deletes Item Peril discount.
	 * 
	 * @return boolean.
	 */
	public boolean deleteItemPerilDiscount(List<GIPIQuoteItem> quoteItemListParams) throws SQLException{
		for(GIPIQuoteItem item: quoteItemListParams){
			List<GIPIQuoteItemDiscount> oldItem = this.retrieveItemDiscountList(item.getQuoteId(), item.getItemNo());
			this.deleteItemDiscount(oldItem);	
			for(GIPIQuoteItemPerilSummary summary: this.getQuoteItemPerilSummaryList(item.getQuoteId())){
				if(summary.getItemNo().equals(item.getItemNo())){ //if(summary.getItemNo()==item.getItemNo()){ changed. always use .equals when comparing objects ex: Integer - irwin 5.22.2012
					log.info("Deleting old quote item peril discounts...");
					List<GIPIQuoteItemPerilDiscount> oldPerils = this.getItemPerilDiscountList(item.getQuoteId(), item.getItemNo(), summary.getPerilCd());
						this.deletePerilDiscount(oldPerils);								
				}						
			}
		}
		return true;
	}
	
	/**
	 * Retrieves Item discount.
	 * 
	 * @return boolean.
	 */
	public List<GIPIQuoteItemDiscount> retrieveItemDiscountList(int quoteId, int itemNo) throws SQLException {
		log.info("Retrieving Item Discount...");
		List<GIPIQuoteItemDiscount> finalList = new ArrayList<GIPIQuoteItemDiscount>();
		List<GIPIQuoteItemDiscount> list = this.getItemDiscountList(quoteId, itemNo);
		List<GIPIQuoteItem> items = this.getGIPIQuoteItemList(quoteId); 
		for(GIPIQuoteItemDiscount discount: list){
			for (GIPIQuoteItem item: items){
				if(discount.getItemNo()==item.getItemNo()){
					discount.setItemTitle(item.getItemTitle());
					finalList.add(discount);
				}
			}
		}
		log.info("Item Discount Size():"+finalList.size());
		return finalList;
	}
	
	/**
	 * Retrieves Item discount List.
	 * 
	 * @return boolean.
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItemDiscount> getItemDiscountList(int quoteId, int itemNo) throws SQLException {
		log.info("DAO - Retrieving Item Discount List...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		param.put("itemNo", itemNo);
		return getSqlMapClient().queryForList("getGIPIQuoteItemDiscount", param);
	}
	
	/**
	 * Retrieves Item List.
	 * 
	 * @return boolean.
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItem> getGIPIQuoteItemList(int quoteId) throws SQLException {
		log.info("DAO calling getGIPIQuoteItemList Params:("+quoteId+")");
		return getSqlMapClient().queryForList("getGIPIQuoteItemList", quoteId);
	}
	
	/**
	 * Deletes Item discount.
	 * 
	 * @return boolean.
	 */
	public boolean deleteItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException {
		log.info("Deleting Item Discount...");
		boolean result = true;
		if(list.size()>0){
			for(GIPIQuoteItemDiscount itemDiscount: list){				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("quoteId", itemDiscount.getQuoteId());
				param.put("itemNo", itemDiscount.getItemNo());		
				this.getSqlMapClient().delete("deleteGIPIQuoteItemDiscount", param);		
			}
		}
		log.info("Deleting Result:"+result);
		return result;
	}
	
	/**
	 * Retrieves Item Peril Summary List.
	 * 
	 * @return boolean.
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItemPerilSummary> getQuoteItemPerilSummaryList(int quoteId) {
		log.info("Service getting Quote Item Peril Summary List Params:("+quoteId+")");
		List<GIPIQuoteItemPerilSummary> list = null;
		try {
			list = getSqlMapClient().queryForList("getGIPIQuoteItemPerilSummaryList", quoteId);
		} catch (SQLException e) {
			
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		}
		return list;
	}
	
	/**
	 * Deletes Item Peril discount List.
	 * 
	 * @return boolean.
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItemPerilDiscount> getItemPerilDiscountList(int quoteId, int itemNo, int perilCd) throws SQLException {
		log.info("DAO - Retrieving Item Peril Discount List...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		param.put("itemNo", itemNo);
		param.put("perilCd", perilCd);
		return getSqlMapClient().queryForList("getGIPIQuoteItemPerilDiscount", param);
	}
	
	/**
	 * Deletes Peril discount.
	 * 
	 * @return boolean.
	 */
	public boolean deletePerilDiscount(List<GIPIQuoteItemPerilDiscount> list) throws SQLException {
		log.info("Deleting Item Peril Discount...");
		boolean result = true;
		if (list.size()>0){
			for(GIPIQuoteItemPerilDiscount itemPerilDiscount: list){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("quoteId", itemPerilDiscount.getQuoteId());
				param.put("itemNo", itemPerilDiscount.getItemNo());
				param.put("perilCd", itemPerilDiscount.getPerilCd());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemPerilDiscount", param);		
			}
		}
		log.info("Deleting Result:"+result);
		return result;
	}
	
	/**
	 * Saves Item discount.
	 * 
	 * @return boolean.
	 */
	public boolean saveItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException {
		log.info("Saving Item Discount...");
		boolean result = true;
		if(list.size()>0){
		//	log.info("List Size to Save:"+list.size());
			for(GIPIQuoteItemDiscount itemDiscount: list){
				Debug.print(itemDiscount);
				this.getSqlMapClient().insert("setGIPIQuoteItemDiscount", itemDiscount);		
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}	
	
	/**
	 * Saves Item Peril discount.
	 * 
	 * @return boolean.
	 */
	public boolean saveItemPerilDiscount(List<GIPIQuoteItemPerilDiscount> list)	throws SQLException {
		log.info("Saving Item Peril Discount...");
		boolean result = true;
		if (list.size()>0){
			log.info("List Size to Save:"+list.size());
			for(GIPIQuoteItemPerilDiscount itemPerilDiscount: list){
				Debug.print(itemPerilDiscount);
				this.getSqlMapClient().insert("setGIPIQuoteItemPerilDiscount", itemPerilDiscount);	
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}
	
	/**
	 * Updates gipi quote premium amt.
	 * 
	 * @return boolean.
	 */
	public boolean updateQuotePremAmt(int quoteId, BigDecimal premAmt)	throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		param.put("premAmt", premAmt);
		this.getSqlMapClient().queryForObject("updateQuotePremAmt", param);
		return true;
	}
	
	/**
	 * Updates item premium amount.
	 * 
	 * @return boolean.
	 */
	public boolean updateQuoteItemPremAmt(int quoteId, List<String> newItemPremAmts ) throws SQLException{
		for (int i=0; i<newItemPremAmts.size(); i=i+2){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			params.put("itemNo", Integer.parseInt(newItemPremAmts.get(i)));
			params.put("premAmt", new BigDecimal(newItemPremAmts.get(i+1)));
			this.getSqlMapClient().queryForList("updateQuoteItemPremAmt", params);
		}
		return true;
	}
	
	/**
	 * Updates Peril premium amount.
	 * 
	 * @return boolean.
	 */
	public boolean updateQuotePerilPremAmt(int quoteId, List<String> newPerilPremAmts) throws SQLException{
		for (int j=0; j<newPerilPremAmts.size(); j=j+3){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			params.put("itemNo", Integer.parseInt(newPerilPremAmts.get(j)));
			params.put("perilCd", Integer.parseInt(newPerilPremAmts.get(j+1)));
			params.put("premAmt", new BigDecimal(newPerilPremAmts.get(j+2)));
			this.getSqlMapClient().queryForObject("updateItemPerilPremAmt", params);
		}
		return true;
	}
}
