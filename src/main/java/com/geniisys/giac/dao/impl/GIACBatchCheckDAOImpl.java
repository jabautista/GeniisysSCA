package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACBatchCheckDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBatchCheckDAOImpl implements GIACBatchCheckDAO {
	
	private Logger log = Logger.getLogger(GIACBatchCheckDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> getPrevExtractParams(Map<String, Object> params)throws SQLException {
		log.info("Getting previously extracted parameters...");
		List<?> list = this.getSqlMapClient().queryForList("getPrevExtractParams", params);
		params.put("list", list);
		return params;
	}

	@Override
	public String extractBatchChecking(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			log.info("Extracting Records.....");
			this.getSqlMapClient().insert("extractBatchChecking", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("message");
			System.out.println(message);
			log.info("Batch Extract tables updated...");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Map<String, Object> getTotalNet(Map<String, Object> params)throws SQLException {
		log.info("Getting total for Net Premiums...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalNet", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalGross(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Gross Premiums...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalGross", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalFacul(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Premium Ceded to Facul...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalFacul", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalTreaty(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Premiums Ceded to Treaty...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalTreaty", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalGrossDtl(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Gross Premiums Detail...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalGrossDtl", params);
		params.put("list", list);
		return params;
	}
	
	@Override
	public Map<String, Object> getTotalFaculDtl(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Premiums Ceded to Facul Detail...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalFaculDtl", params);
		params.put("list", list);
		return params;
	}
	
	@Override
	public Map<String, Object> getTotalTreatyDtl(Map<String, Object> params) throws SQLException {
		log.info("Getting total for Premiums Ceded to Treaty Details...");
		List<?> list = this.getSqlMapClient().queryForList("getTotalTreatyDtl", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalOutstanding(Map<String, Object> params)
			throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalOutstanding", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalPaid(Map<String, Object> params)
			throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalPaid", params);
		params.put("list", list);
		return params;
	}

	@Override
	public void checkRecords(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkBatchRecords", params);
	}

	@Override
	public Map<String, Object> getTotalOutstandingDtl(Map<String, Object> params)
			throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalOutstandingDtl", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalPaidDtl(Map<String, Object> params)
			throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalPaidDtl", params);
		params.put("list", list);
		return params;
	}

	@Override
	public void checkDetails(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkDetails", params);
	}

}
