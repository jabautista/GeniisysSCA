package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACTaxesWheldDAO;
import com.geniisys.giac.entity.GIACLossRiCollns;
import com.geniisys.giac.entity.GIACTaxesWheld;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTaxesWheldDAOImpl implements GIACTaxesWheldDAO {

	/** The logger */
	private static Logger log = Logger.getLogger(GIACTaxesWheldDAOImpl.class);
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACTaxesWheldDAO#getGiacTaxesWheld(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACTaxesWheld> getGiacTaxesWheld(Integer gaccTranId)
			throws SQLException {
		log.info("");
		return this.getSqlMapClient().queryForList("getGIACTaxesWheld", gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACTaxesWheldDAO#saveGIACTaxesWheld(java.util.List, java.util.List, java.util.Map)
	 */
	@Override
	public String saveGIACTaxesWheld(List<GIACTaxesWheld> setTaxesWheldList,
			List<GIACTaxesWheld> delTaxesWheldList, Map<String, Object> params)
			throws SQLException {
		String message = new String("");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			/** insert/update **/
			this.getSqlMapClient().startBatch();
			this.setGIACTaxesWheld(setTaxesWheldList);
			this.getSqlMapClient().executeBatch();
			
			/** delete **/
			this.getSqlMapClient().startBatch();
			this.delGIACTaxesWheld(delTaxesWheldList);
			this.getSqlMapClient().executeBatch();
			
			/** post-forms commit **/
			if (setTaxesWheldList != null || delTaxesWheldList != null) {
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("giacs022PostFormsCommit", params);
				this.getSqlMapClient().executeBatch();
			}
			message = params.get("message") == null ? "SUCCESS" : params.get("message").toString();
			
			if ("SUCCESS".equals(message)) {
				this.getSqlMapClient().getCurrentConnection().commit();
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		} catch (SQLException e) {
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	private void setGIACTaxesWheld(List<GIACTaxesWheld> setTaxesWheldList) throws SQLException {
		log.info("Saving GIAC Taxes Wheld records...");
		log.info("Gacc Tran Id\tItem No\tPayee Class Cd\tPayee Cd");
		log.info("=======================================================================================");
		
		if (setTaxesWheldList != null) {
			for (GIACTaxesWheld taxesWheld : setTaxesWheldList) {
				log.info(taxesWheld.getGaccTranId() + "\t" + taxesWheld.getItemNo() + "\t" + taxesWheld.getPayeeClassCd() + "\t" + taxesWheld.getPayeeCd());
				this.getSqlMapClient().insert("setGIACTaxesWheld", taxesWheld);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}
	
	private void delGIACTaxesWheld(List<GIACTaxesWheld> delTaxesWheldList) throws SQLException {
		log.info("Deleting GIAC Taxes Wheld records...");
		log.info("Gacc Tran Id\tItem No\tPayee Class Cd\tPayee Cd");
		log.info("=======================================================================================");
		
		if (delTaxesWheldList != null) {
			for (GIACTaxesWheld taxesWheld : delTaxesWheldList) {
				log.info(taxesWheld.getGaccTranId() + "\t" + taxesWheld.getItemNo() + "\t" + taxesWheld.getPayeeClassCd() + "\t" + taxesWheld.getPayeeCd());
				this.getSqlMapClient().insert("delGIACTaxesWheld", taxesWheld);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully deleted!");
	}
	//Added by pjsantos 12/27/2016, GENQA 5898
	@Override
	public String saveBir2307History(Map<String, Object> params) throws SQLException {
		log.info("Saving BIR 2307 records...");
		String message = "SUCCESS";
		try
		{
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().insert("saveBir2307History", params);
		
		}
		catch (SQLException e) {
			e.printStackTrace();
			log.info(e.getMessage());	
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.info(e.getMessage());	
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Records successfully saved!");
			this.getSqlMapClient().endTransaction();
		}
		return message;	
			
	}	
}
