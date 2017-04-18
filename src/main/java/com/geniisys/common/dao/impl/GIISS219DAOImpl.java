package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISS219DAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISS219DAOImpl implements GIISS219DAO{
	
	private static Logger log = Logger.getLogger(GIISS219DAOImpl.class);
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss219(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			List<Map<String, Object>> delList = (List<Map<String, Object>>) params.get("delGIISPlan");
			if(delList != null){
				log.info("*****deleting GIISPlan...");
				for(Map<String, Object> d: delList){
					this.sqlMapClient.update("delGIISPlan", d);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			List<Map<String, Object>> setList = (List<Map<String, Object>>) params.get("setGIISPlan");
			if(setList != null){
				log.info("*****adding/updating GIISPlan...");
				for(Map<String, Object> s: setList){
					this.sqlMapClient.update("setGIISPlan", s);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			
			
			List<Map<String, Object>> delList2 = (List<Map<String, Object>>) params.get("delGIISPlanDtl");
			if(delList2 != null){
				log.info("*****deleting GIISPlanDtl...");
				for(Map<String, Object> d: delList2){
					this.sqlMapClient.update("delGIISPlanDtl", d);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			List<Map<String, Object>> setList2 = (List<Map<String, Object>>) params.get("setGIISPlanDtl");
			if(setList2 != null){
				log.info("*****adding/updating GIISPlanDtl...");
				for(Map<String, Object> s: setList2){
					if (s.get("planCd").equals(null) || s.get("planCd").equals("")) {
						for (Map<String, Object> withPlanCd : setList) {
							List<Map<String, Object>> setGIISPlanDtl = (List<Map<String, Object>>) withPlanCd.get("setGIISPlanDtl");
							if (setGIISPlanDtl != null) {
								for (Map<String, Object> s2 : setGIISPlanDtl) {
									s2.put("planCd", withPlanCd.get("planCd"));
									this.sqlMapClient.update("setGIISPlanDtl", s2);
								}
							}
						}
						break;
					} else {
						this.sqlMapClient.update("setGIISPlanDtl", s);
					}
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}

			
			List<Map<String, Object>> delList3 = (List<Map<String, Object>>) params.get("delGIISPackPlan");
			if (delList3 != null) {
				log.info("*****deleting GIISPackPlan...");
				for(Map<String, Object> d: delList3){
					this.sqlMapClient.update("delGIISPackPlan", d);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			List<Map<String, Object>> setList3 = (List<Map<String, Object>>) params.get("setGIISPackPlan");
			if (setList3 != null) {
				log.info("*****adding/updating GIISPackPlan...");
				for(Map<String, Object> s: setList3){
					this.sqlMapClient.update("setGIISPackPlan", s);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			
			
			List<Map<String, Object>> delList4 = (List<Map<String, Object>>) params.get("delGIISPackPlanCover");
			if (delList4 != null) {
				log.info("*****deleting giisPackPlanCover...");
				for(Map<String, Object> d: delList4){
					this.sqlMapClient.update("delGIISPackPlanCover", d);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			List<Map<String, Object>> setList4 = (List<Map<String, Object>>) params.get("setGIISPackPlanCover");
			if (setList4 != null) {
				log.info("*****adding/updating giisPackPlanCover...");
				for(Map<String, Object> s: setList4){
					if (s.get("planCd").equals(null) || s.get("planCd").equals("")) {
						for (Map<String, Object> withPlanCd : setList3) {
							List<Map<String, Object>> setGIISPackPlanCover = (List<Map<String, Object>>) withPlanCd.get("setGIISPackPlanCover");
							if (setGIISPackPlanCover != null) {
								for (Map<String, Object> s2 : setGIISPackPlanCover) {
									s2.put("planCd", withPlanCd.get("planCd"));
									this.sqlMapClient.update("setGIISPackPlanCover", s2);
								}
							}
						}
						break;
					} else {
						this.sqlMapClient.update("setGIISPackPlanCover", s);
					}
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			
			
			List<Map<String, Object>> delList5 = (List<Map<String, Object>>) params.get("delGIISPackPlanCoverDtl");
			if (delList5 != null) {
				log.info("*****deleting GIISPackPlanCoverDtl...");
				for(Map<String, Object> d: delList5){
					this.sqlMapClient.update("delGIISPackPlanCoverDtl", d);
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			List<Map<String, Object>> setList5 = (List<Map<String, Object>>) params.get("setGIISPackPlanCoverDtl");
			if (setList5 != null) {
				log.info("*****adding/updating GIISPackPlanCoverDtl...");
				for(Map<String, Object> s: setList5){
					if (s.get("planCd").equals(null) || s.get("planCd").equals("")) {
						for (Map<String, Object> withPlanCd : setList3) {
							List<Map<String, Object>> setGIISPackPlanCover = (List<Map<String, Object>>) withPlanCd.get("setGIISPackPlanCover");
							if (setGIISPackPlanCover != null) {
								for (Map<String, Object> s2 : setGIISPackPlanCover) {
									List<Map<String, Object>> setGIISPackPlanCoverDtl = (List<Map<String, Object>>) s2.get("setGIISPackPlanCoverDtl");
									if (setGIISPackPlanCoverDtl != null) {
										for (Map<String, Object> s3 : setGIISPackPlanCoverDtl) {
											s3.put("planCd", withPlanCd.get("planCd"));
											this.sqlMapClient.update("setGIISPackPlanCoverDtl", s3);
										}
									}
								}
							}
						}
						break;
					} else {
						this.sqlMapClient.update("setGIISPackPlanCoverDtl", s);
					}
				}
				this.sqlMapClient.executeBatch();
				log.info("finished.");
			}
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGiiss219", params);		
	}
	
	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteGiiss219", params);
	}
}
