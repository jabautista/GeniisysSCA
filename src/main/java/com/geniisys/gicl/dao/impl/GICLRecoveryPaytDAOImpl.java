package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLRecoveryPaytDAO;
import com.geniisys.gicl.entity.GICLRecoveryPayt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLRecoveryPaytDAOImpl implements GICLRecoveryPaytDAO {
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLClaimsDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> cancelRecoveryPayt(Map<String, Object> params)
			throws SQLException {
		log.info("cancelRecoveryPayt - "+params);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("cancelRecoveryPayt", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
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
	public void saveGICLAcctEntries(Map<String, Object> params)
			throws SQLException {
		log.info("Saving GICL Acct Entries...");
		try{
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRecAE");
			List<Map<String, Object>> delRows = (List<Map<String, Object>>) params.get("delRecAE");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(Map<String, Object> ae: delRows) {
				System.out.println("Deleting AE Row: "+ae);
				this.getSqlMapClient().delete("delGICLRecAcctgEntries", ae);
			}
			this.getSqlMapClient().executeBatch();
			
			for(Map<String, Object> ae: setRows) {
				System.out.println("Inserting/Updating AE Row: "+ae);
				this.getSqlMapClient().insert("setGICLRecAcctgEntries", ae);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	public Integer getRecAcctIdNextVal() throws SQLException {
		System.out.println("Getting nextVal for recovery_acct_id...");
		return (Integer) this.getSqlMapClient().queryForObject("getRecAcctIdNextVal");
	}

	@Override
	public Map<String, Object> generateRecAcctInfo(Map<String, Object> params)
			throws SQLException {
		log.info("Generating new recovery acct info...");
		this.getSqlMapClient().queryForObject("generateRecAcctInfo", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String generateRecovery(Map<String, Object> params)
			throws SQLException {
		log.info("Generating Recovery...");
		String mesg = "";
		try{
			List<GICLRecoveryPayt> recPayts = (List<GICLRecoveryPayt>) params.get("setRecPayts");
			Map<String, Object> recAcct = (Map<String, Object>) params.get("setRecAcct");
			//Map<String, Object> aegParam = new HashMap<String, Object>();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("Updating recovery accts...");
			this.getSqlMapClient().insert("setRecoveryAcct", recAcct);
			this.getSqlMapClient().executeBatch();
			System.out.println("Updated recovery accts: "+recAcct);
			
			System.out.println("Updating recovery payts...");
			for(GICLRecoveryPayt rec: recPayts) {
				this.getSqlMapClient().update("updateGeneratedRecovery", rec);
			}
			this.getSqlMapClient().executeBatch();
			
			/*aegParam.put("userId", recAcct.get("userId"));
			aegParam.put("recoveryAcctId", recAcct.get("recoveryAcctId"));
			System.out.println("Setting AEG Parameters: "+aegParam);
			this.getSqlMapClient().update("aegParameterGICLS055", aegParam);
			this.getSqlMapClient().executeBatch();
			System.out.println("AEG Parameters::: "+aegParam);
			mesg = (String) aegParam.get("message");*/
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return mesg;
	}

	@Override
	public String aegParameterGICLS055(Map<String, Object> params)
			throws SQLException {
		log.info("AEG Parameter[GICLS055]...");
		String mesg = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("Updating recovery payts...");
			this.getSqlMapClient().update("aegParameterGICLS055", params);
			this.getSqlMapClient().executeBatch();
			System.out.println("AEG Parameters::: "+params);
			mesg = (String) params.get("message");
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return mesg;
	}

	@Override
	public void setRecoveryAcct(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("Saving Recovery Acct: "+params);
			this.getSqlMapClient().update("setRecoveryAcct2", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> checkRecoveryValidPayt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkRecoveryValidPayt", params);
		return params;
	}

	@Override
	public Map<String, Object> getRecAEAmountSum(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getRecAEAmountSum", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecoveryAccts(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getRecoveryAcct", params);
	}

}
