package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACOvrideCommPaytsDAO;
import com.geniisys.giac.entity.GIACOvrideCommPayts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACOvrideCommPaytsDAOImpl implements GIACOvrideCommPaytsDAO {

	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIACOvrideCommPaytsDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#getGIACOvrideCommPayts(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACOvrideCommPayts> getGIACOvrideCommPayts(Integer gaccTranId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIACOvrideCommPayts", gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#chckPremPayts(java.util.Map)
	 */
	@Override
	public void chckPremPayts(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("chckPremPayts", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#chckBalance(java.util.Map)
	 */
	@Override
	public void chckBalance(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("chckBalance", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#validateGiacs040ChildIntmNo(java.util.Map)
	 */
	@Override
	public void validateGiacs040ChildIntmNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIACS040ChildIntmNo", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#validateGiacs040CommAmt(java.util.Map)
	 */
	@Override
	public void validateGiacs040CommAmt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIACS040CommAmt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#validateGiacs040ForeignCurrAmt(java.util.Map)
	 */
	@Override
	public void validateGiacs040ForeignCurrAmt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIACS040ForeignCurrAmt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#deleteGIACOvrideCommPayts(java.util.List)
	 */
	@Override
	public void deleteGIACOvrideCommPayts(List<GIACOvrideCommPayts> ovrideCommPaytsList) 
			throws SQLException {
		log.info("Deleting GIAC Overriding Comm Payts records...");
		log.info("Gacc Tran Id\tIss Cd\tPrem Seq No\tIntm No\tChild Intm No");
		log.info("=======================================================================================");
		
		if (ovrideCommPaytsList != null) {
			for (GIACOvrideCommPayts ovrideCommPayts : ovrideCommPaytsList) {
				log.info(ovrideCommPayts.getGaccTranId() + "\t" + ovrideCommPayts.getIssCd() + "\t" + ovrideCommPayts.getPremSeqNo() + "\t" + ovrideCommPayts.getIntmNo() + "\t" + ovrideCommPayts.getChildIntmNo());
				this.getSqlMapClient().delete("delGIACOvrideCommPayts", ovrideCommPayts);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#setGIACOvrideCommPayts(java.util.List)
	 */
	@Override
	public void setGIACOvrideCommPayts(List<GIACOvrideCommPayts> ovrideCommPaytsList)
			throws SQLException {
		log.info("Saving GIAC Overriding Comm Payts records...");
		log.info("Gacc Tran Id\tIss Cd\tPrem Seq No\tIntm No\tChild Intm No");
		log.info("=======================================================================================");
		
		if (ovrideCommPaytsList != null) {
			for (GIACOvrideCommPayts ovrideCommPayts : ovrideCommPaytsList) {
				log.info(ovrideCommPayts.getGaccTranId() + "\t" + ovrideCommPayts.getIssCd() + "\t" + ovrideCommPayts.getPremSeqNo() + "\t" + ovrideCommPayts.getIntmNo() + "\t" + ovrideCommPayts.getChildIntmNo());
				this.getSqlMapClient().insert("setGIACOvrideCommPayts", ovrideCommPayts);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOvrideCommPaytsDAO#saveGIACOvrideCommPayts(java.util.List, java.util.List, java.util.Map)
	 */
	@Override
	public String saveGIACOvrideCommPayts(
			List<GIACOvrideCommPayts> setOvrideCommPayts,
			List<GIACOvrideCommPayts> delOvrideCommPayts,
			Map<String, Object> params) throws SQLException {
		String message = new String("SUCCESS");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// insert/update
			this.getSqlMapClient().startBatch();
			this.setGIACOvrideCommPayts(setOvrideCommPayts);
			this.getSqlMapClient().executeBatch();
			
			// delete			
			this.getSqlMapClient().startBatch();
			this.deleteGIACOvrideCommPayts(delOvrideCommPayts);
			this.getSqlMapClient().executeBatch();
			
			// post-forms commit
			if (setOvrideCommPayts != null) {
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("executeGIACS040PostFormsCommit", params);
				this.getSqlMapClient().executeBatch();
				message = (String)params.get("message");
			}
			
			if (message != null) {
				if (!"SUCCESS".equals(message)) {
					this.getSqlMapClient().getCurrentConnection().rollback();
				} else {
					this.getSqlMapClient().getCurrentConnection().commit();
				}
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		} catch (SQLException e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
	public String validateTranRefund(Map<String, Object> params) throws SQLException{
		log.info("validate_tran_refund: " + params.toString());
		return (String) this.sqlMapClient.queryForObject("validateTranRefund", params);
	}
	
	public Map<String, Object> getInputVAT(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("getGIACS040InputVAT", params);
		return params;
	}
	
	public void valDeleteRec(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("valDeleteRecGIACS040", params);
	}
	
	public String validateBill(Map<String, Object> params) throws SQLException{
		log.info("validate_bill: " + params.toString());
		return (String) this.sqlMapClient.queryForObject("validateBillGIACS040", params);
	}
}
