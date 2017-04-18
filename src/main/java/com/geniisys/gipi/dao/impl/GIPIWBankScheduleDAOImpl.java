package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWBankScheduleDAO;
import com.geniisys.gipi.entity.GIPIWBankSchedule;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWBankScheduleDAOImpl implements GIPIWBankScheduleDAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIWBankScheduleDAOImpl.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBankScheduleDAO#getGIPIWBankScheduleList(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWBankSchedule> getGIPIWBankScheduleList(Integer parId)
			throws SQLException {
		log.info("Getting bank listings...");
		return this.getSqlMapClient().queryForList("getWBankSchedule", parId);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBankScheduleDAO#saveGIPIWBankScheduleChanges(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveGIPIWBankScheduleChanges(Map<String, Object> params)
			throws SQLException {
		log.info("DAO - Saving bank details...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			List<GIPIWBankSchedule> bankSchedulesForDelete = (List<GIPIWBankSchedule>) params.get("bankSchedulesForDelete");
			List<GIPIWBankSchedule> bankSchedulesForInsert = (List<GIPIWBankSchedule>) params.get("bankSchedulesForInsert");
			
			for (GIPIWBankSchedule bank : bankSchedulesForDelete){
				Map<String, Object> bankMap = new HashMap<String, Object>();
				bankMap.put("parId", bank.getParId());
				bankMap.put("bankItemNo", bank.getBankItemNo());
				this.deleteGIPIWBankSchedule(bankMap);
			}
			
			for (GIPIWBankSchedule bank : bankSchedulesForInsert){
				this.insertGIPIWBankSchedule(bank);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return true;
	}

	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	private boolean deleteGIPIWBankSchedule(Map<String, Object> params)
			throws SQLException {
		log.info("Deleting bank schedule for parId - "+params.get("parId")+" - bankItemNo - "+params.get("bankItemNo")+"...");
		this.getSqlMapClient().queryForObject("deleteWBankSched", params);
		log.info("Deleted.");
		return true;
	}

	/**
	 * 
	 * @param bank
	 * @return
	 * @throws SQLException
	 */
	private boolean insertGIPIWBankSchedule(GIPIWBankSchedule bank)
			throws SQLException {
		log.info("Inserting bank schedulefor parId - "+bank.getParId()+" - bankItemNo - "+bank.getBankItemNo()+"...");
		log.info("bank: "+bank.getBank());
		log.info("address: "+bank.getBankAddress());
		log.info("remarks: "+bank.getRemarks());
		this.getSqlMapClient().insert("insertWBankSched", bank);
		log.info("Inserted.");
		return true;
	}

}
