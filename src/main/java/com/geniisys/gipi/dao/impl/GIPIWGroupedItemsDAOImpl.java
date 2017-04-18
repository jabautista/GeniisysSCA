package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.gipi.dao.GIPIWGroupedItemsDAO;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWGroupedItemsDAOImpl implements GIPIWGroupedItemsDAO{
		private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIWGroupedItemsDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWGroupedItemsDAO#getGipiWGroupedItems(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGipiWGroupedItems(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWGroupedItems", parId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWGroupedItemsDAO#getGipiWGroupedItems2(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGipiWGroupedItems2(Integer parId,Integer itemNo)
			throws SQLException {
		@SuppressWarnings("rawtypes")
		Map<String, String > params = new HashMap();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return this.getSqlMapClient().queryForList("getGipiWGroupedItems2", params);
	}

	@Override
	public void renumberGroupedItems(Map<String, Object> params)
			throws SQLException {
		log.info("Renumbering Grouped Items ...");
		this.getSqlMapClient().queryForObject("renumberGroupedItems", params);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGIPIWGroupedItems(
			Map<String, Object> params) throws SQLException {
		log.info("Getting gipi_wgrouped_items records ...");
		return this.getSqlMapClient().queryForList("getGipiWGroupedItems3", params);
	}

	@Override
	public Map<String, Object> validateGroupedItemNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGroupedItemNo", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGroupedItemTitle(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateGroupedItemTitle", params);
		return params;
	}

	@Override
	public Map<String, Object> validatePrincipalCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePrincipalCd", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGrpFromDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGrpFromDate", params);
		return params;
	}

	@Override
	public Map<String, Object> validateGrpToDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGrpToDate", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validateAmtCovered(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateAmtCovered", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGroupedItem(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getGroupedItem", params);
	}

	@Override
	public Map<String, Object> getDeleteSwVars(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDeleteSwVars", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> setGroupedItemsVars(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("setGroupedItemsVars", params);
	}

	@Override
	public String validateRetrieveGrpItems(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateRetrieveGrpItems", params);
	}

	@Override
	public String preNegateDelete(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("preNegateDelete", params);
	}

	@Override
	public String checkBackEndt(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGrpBackEndt", params);
	}

	@Override
	public void negateDelete(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of Negate/Delete...");
			this.getSqlMapClient().queryForObject("negateDelete", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: insertRecGrpWItem2 :::");
			this.getSqlMapClient().insert("insertRecGrpWItem2", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of Negate/Delete...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGroupedItems(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving grouped items...");
			
			List<GIPIWGroupedItems> setRows = (List<GIPIWGroupedItems>) params.get("setRows");
			List<GIPIWGroupedItems> delRows = (List<GIPIWGroupedItems>) params.get("delRows");
			
			for (GIPIWGroupedItems del : delRows){
				log.info("DELETING: " + del);
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("itemNo", del.getItemNo());
				delParams.put("groupedItemNo", del.getGroupedItemNo());
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delParams);
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary2", delParams);
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			//marco - 11.29.2012 - :(
			//String populate = "N";
			//Map<String, Object> packMap = new HashMap<String, Object>();
			for (GIPIWGroupedItems set : setRows){
				//populate = "N";
				/* if((!(set.getPackBenCd().equals(""))) && (set.getOverwriteBen().equals("Y"))){
					log.info("::: checking package benefit :::");
					packMap.put("parId", set.getParId());
					packMap.put("itemNo", set.getItemNo());
					packMap.put("groupedItemNo", set.getGroupedItemNo());
					populate = (String) this.getSqlMapClient().queryForObject("checkPackage", packMap);
					log.info("::: populate ::: " + populate);
					this.getSqlMapClient().executeBatch();
				} */
				
				log.info("INSERTING: " + set);
				this.getSqlMapClient().insert("setGipiWGroupedItems2", set);
				
				//if(populate.equals("Y")){ -- marco - 11.29.2012
				if((!(set.getPackBenCd().equals(""))) && (set.getOverwriteBen().equals("Y"))){
					log.info("::: populateBenefits :::");
					params.put("packBenCd", set.getPackBenCd());
					params.put("groupedItemNo", set.getGroupedItemNo());
					this.getSqlMapClient().queryForObject("populateBenefits2", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("::: insertRecGrpWItem2 :::");
			this.getSqlMapClient().insert("insertRecGrpWItem2", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving grouped items...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void insertRetrievedGrpItems(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Inserting retrieved grouped items...");
			
			List<GIPIWGroupedItems> setRows = null;
			
			if(params.get("insertAll").equals("N")){
				setRows = (List<GIPIWGroupedItems>) params.get("setRows");
				for (GIPIWGroupedItems set : setRows){
					log.info("INSERTING: " + set);
					this.getSqlMapClient().insert("insertRetrievedGrpItems", set);
				}
				this.getSqlMapClient().executeBatch();
			}else{
				setRows = this.getSqlMapClient().queryForList("getAllRetGrpItems", params);
				for (GIPIWGroupedItems set : setRows){
					log.info("INSERTING: " + set);
					set.setParId((String) params.get("parId"));
					set.setLineCd((String) params.get("lineCd"));
					set.setSublineCd((String) params.get("sublineCd"));
					set.setIssCd((String) params.get("issCd"));
					set.setIssueYy(Integer.parseInt((String)params.get("issueYy")));
					set.setPolSeqNo(Integer.parseInt((String)params.get("polSeqNo")));
					set.setRenewNo(Integer.parseInt((String)params.get("renewNo")));
					set.setEffDate((String) params.get("effDate"));
					this.getSqlMapClient().insert("insertRetrievedGrpItems", set);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().insert("insertRecGrpWItem2", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("Finished inserting retrieved grouped items...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void copyBenefits(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Copying benefits...");
			
			List<GIPIWGroupedItems> setRows = null;
			
			if(params.get("copyAll").equals("N")){
				setRows = (List<GIPIWGroupedItems>) params.get("setRows");
				for (GIPIWGroupedItems set : setRows){
					log.info("INSERTING: " + set);
					this.getSqlMapClient().insert("copyBenefits", set);
				}
				this.getSqlMapClient().executeBatch();
			}else{
				setRows = this.getSqlMapClient().queryForList("getAllCopyBenefitsListing", params);
				for (GIPIWGroupedItems set : setRows){
					log.info("INSERTING: " + set);
					set.setParId((String) params.get("parId"));
					set.setPackBenCd((String) params.get("packBenCd"));
					set.setCol1(Integer.parseInt((String)set.getGroupedItemNo()));
					set.setGroupedItemNo((String) params.get("groupedItemNo"));
					set.setLineCd((String) params.get("lineCd"));
					this.getSqlMapClient().insert("copyBenefits", set);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().insert("insertRecGrpWItem2", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("Finished copying benefits...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void postSaveGroupedItems(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Post save grouped items...");
			
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of post save grouped items...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Integer checkGroupedItems(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkGroupedItems", params);
	}

	@Override
	public Integer validateNoOfPersons(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("validateNoOfPersons", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCAGroupedItems(Map<String, Object> params) throws SQLException { //Deo [01.26.2017]: SR-23702
		return (List<String>) this.getSqlMapClient().queryForList("getCAGroupedItems", params);
	}
}
