package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISPackageBenefitDAO;
import com.geniisys.common.entity.GIISPackageBenefit;
import com.geniisys.common.entity.GIISPackageBenefitDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPackageBenefitDAOImpl implements GIISPackageBenefitDAO{
private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIISPackageBenefitDAO.class);

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
	public void saveGiiss120(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			log.info("*****Saving GIISPackageBenefit...");
			List<GIISPackageBenefit> delList = (List<GIISPackageBenefit>) params.get("delGIISPackageBenefit");
			for(GIISPackageBenefit d: delList){
				this.sqlMapClient.update("delGIISPackageBenefit", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPackageBenefit> setList = (List<GIISPackageBenefit>) params.get("setGIISPackageBenefit");
			for(GIISPackageBenefit s: setList){
				this.sqlMapClient.update("setGIISPackageBenefit", s);
			}
			this.sqlMapClient.executeBatch();
			log.info("finished.");
			
			log.info("*****Saving GIISPackageBenefitDtl...");
			List<GIISPackageBenefitDtl> delList2 = (List<GIISPackageBenefitDtl>) params.get("delGIISPackageBenefitDtl");
			for(GIISPackageBenefitDtl d: delList2){
				this.sqlMapClient.update("delGIISPackageBenefitDtl", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPackageBenefitDtl> setList2 = (List<GIISPackageBenefitDtl>) params.get("setGIISPackageBenefitDtl");
			for(GIISPackageBenefitDtl s: setList2){
				if (s.getPackBenCd().equals(null) || s.getPackBenCd().equals("")) {
					for (GIISPackageBenefit compare : setList) {
						if (compare.getPackageCd().equals(s.getPackageCd())) {
							s.setPackBenCd(compare.getPackBenCd());
							this.sqlMapClient.update("setGIISPackageBenefitDtl", s);
						}
					}
				} else {
					this.sqlMapClient.update("setGIISPackageBenefitDtl", s);
				}
			}
			this.sqlMapClient.executeBatch();
			log.info("finished.");
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGiiss120", params);		
	}
	
	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteGiiss120", params);		
	}
}
