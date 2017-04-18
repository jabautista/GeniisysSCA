package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmAdjusterDAO;
import com.geniisys.gicl.entity.GICLClmAdjHist;
import com.geniisys.gicl.entity.GICLClmAdjuster;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmAdjusterDAOImpl implements GICLClmAdjusterDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLClmAdjusterDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClmAdjusterDAO#getClmAdjusterListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClmAdjusterListing(Map<String, Object> params) throws SQLException {
		log.info("get claim adjuster listing");
		return this.getSqlMapClient().queryForList("getClmAdjusterListing", params);
	}

	@Override
	public Map<String, Object> checkBeforeDeleteAdj(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkBeforeDeleteAdjGICLS010", params);
		return params;
	}
	
	private void setGiclClmAdjHist(GICLClmAdjHist hist) throws SQLException{
		if (hist.getClmAdjId() != null){
			log.info("Inserting adjuster history : "+hist.getClaimId()+" - "+hist.getClmAdjId()+" - "+hist.getAdjCompanyCd()+" - "+hist.getUserId());
			this.sqlMapClient.insert("setGiclClmAdjHist", hist);
		}
	}

	private void setNewAdjHist(GICLClmAdjuster set) throws SQLException{
		GICLClmAdjHist hist = new GICLClmAdjHist();
		hist.setClmAdjId(set.getClmAdjId());
		hist.setClaimId(set.getClaimId());
		hist.setAdjCompanyCd(set.getAdjCompanyCd());
		hist.setPrivAdjCd(set.getPrivAdjCd());
		hist.setAssignDate(set.getAssignDate());
		hist.setUserId(set.getUserId()); //robert 01.28.2013
		if ("Y".equals(set.getCancelTag())){
			hist.setCompltDate(null);
			hist.setDeleteDate(null);
			hist.setCancelDate(new Date());
			this.setGiclClmAdjHist(hist);
		}
		if ("Y".equals(set.getDeleteTag())){
			hist.setCancelDate(null);
			hist.setCompltDate(null);
			hist.setDeleteDate(new Date());
			this.setGiclClmAdjHist(hist);
		} 
		if (set.getCompltDate() != null){
			hist.setCancelDate(null);
			hist.setDeleteDate(null);
			hist.setCompltDate(set.getCompltDate());
			this.setGiclClmAdjHist(hist);
		}else{
			if (!"Y".equals(set.getCancelTag())){
				hist.setCancelDate(null);
				hist.setDeleteDate(null);
				hist.setCompltDate(null);
				this.setGiclClmAdjHist(hist);
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmAdjuster(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving adjuster.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLClmAdjuster> adjSetRows = (List<GICLClmAdjuster>) params.get("adjSetRows");
			List<GICLClmAdjuster> adjDelRows = (List<GICLClmAdjuster>) params.get("adjDelRows");
			List<GICLClmAdjHist> histRows = (List<GICLClmAdjHist>) params.get("histRows");
			
			for (GICLClmAdjuster del: adjDelRows){
				log.info("Deleting adjuster : "+del.getClaimId()+" - "+del.getClmAdjId()+" - "+del.getAdjCompanyCd()+" - "+del.getDspAdjCoName());
				log.info(del.getPrivAdjCd()+" - "+del.getDspPrivAdjName());
				this.sqlMapClient.delete("delGiclClmAdjuster", del);
				this.getSqlMapClient().executeBatch();
			}
			
			for (GICLClmAdjuster set: adjSetRows){
				Integer clmAdjId = null;
				Date compltDate = set.getCompltDate();
				if (set.getClmAdjId() == null || "".equals(set.getClmAdjId())){ //for new record
					clmAdjId = (Integer) this.sqlMapClient.queryForObject("getNewClmAdjId");
					set.setClmAdjId(clmAdjId);
					log.info("New claim adjuster id : "+clmAdjId);
				}
				
				log.info("Inserting/Updating adjuster : "+set.getClaimId()+" - "+set.getClmAdjId()+" - "+set.getAdjCompanyCd()+" - "+set.getDspAdjCoName());
				//set.setCompltDate(null); //complete date is not a database item on forms y.o.y --uncommented by robert 01.28.2013
				this.sqlMapClient.insert("setGiclClmAdjuster", set);
				this.getSqlMapClient().executeBatch();
				
				if (clmAdjId != null){
					set.setCompltDate(compltDate);
					this.setNewAdjHist(set);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			for (GICLClmAdjHist hist: histRows){
				this.setGiclClmAdjHist(hist);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
		}catch (Exception e) {
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving adjuster.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClmAdjuster> getLossExpAdjusterList(Integer claimId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getLossExpAdjusterList", claimId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClmAdjuster> getClmAdjusterList(Integer claimId)
			throws SQLException {
		log.info("get claim adjuster list"); 
		return this.getSqlMapClient().queryForList("getClmAdjusterList", claimId);
	}
	
}
