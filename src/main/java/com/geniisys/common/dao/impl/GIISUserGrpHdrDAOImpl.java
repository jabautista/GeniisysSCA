/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.common.dao.GIISUserGrpHdrDAO;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.geniisys.common.entity.GIISUserGrpHdr;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.geniisys.common.entity.GIISUserGrpModule;
import com.geniisys.common.entity.GIISUserGrpTran;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserGrpHdrDAOImpl.
 */
public class GIISUserGrpHdrDAOImpl implements GIISUserGrpHdrDAO {

	/** The log. */
	private Logger log = Logger.getLogger(GIISUserGrpHdrDAOImpl.class);
	
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

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpHdrDAO#getGiisUserGrpList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserGrpHdr> getGiisUserGrpList(String param) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserGrpList", param);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpHdrDAO#setGiisUserGrpHdr(com.geniisys.common.entity.GIISUserGrpHdr)
	 */
	@Override
	public void setGiisUserGrpHdr(GIISUserGrpHdr userGrpHdr) throws SQLException {
		log.info("DAO calling setGiisUserGrpHdr...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			// save user grp hdr
			this.getSqlMapClient().insert("setGiisUserGrpHdr", userGrpHdr);

			// save transactions
			for (GIISUserGrpTran t : userGrpHdr.getTransactions()) {
				System.out.println("Saving Transaction: " + t.getTranCd());
				this.getSqlMapClient().insert("setGiisUserGrpTran", t);

				System.out.println("issue sources size : " + t.getIssueSources().size());
				
				// save transaction issue sources
				for (GIISUserGrpDtl i : t.getIssueSources()) {
					System.out.println("Saving Issue: " + i.getIssCd() + " | " + i.getTranCd());
					this.getSqlMapClient().insert("setGiisUserGrpDtl", i);

					// save transaction issue source lines
					for (GIISUserGrpLine l : i.getLines()) {
						System.out.println("Saving Line: " + l.getLineCd() + " | " + l.getIssCd() + " | " + l.getTranCd());
						this.getSqlMapClient().insert("setGiisUserGrpLine", l);
					}
				}
				
				// save transaction modules
				for (GIISUserGrpModule m: t.getModules()) {
					System.out.println("Module: " + m.getUserGrp() + " - " + m.getTranCd() + " - " + m.getModuleId() + " - " + m.getUserId() + " - " + m.getRemarks());
					this.getSqlMapClient().insert("setGiisUserGrpModule", m);
				}
			}

			this.getSqlMapClient().executeBatch();
			// next lines are committed, used only for demo purposes
			/*boolean grr = true;
			if (grr) {
				throw new Exception();
			}*/
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Done saving userGrpHdr...");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpHdrDAO#getGiisUserGrpHdr(int)
	 */
	@Override
	public GIISUserGrpHdr getGiisUserGrpHdr(int userGrp) throws SQLException {
		return (GIISUserGrpHdr) this.getSqlMapClient().queryForObject("getGiisUserGrpHdr", userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpHdrDAO#deleteGiisUserGrpHdr(int)
	 */
	@Override
	public void deleteGiisUserGrpHdr(int userGrp) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserGrpHdr", userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpHdrDAO#deleteGiisUserGrpHdrDetails(com.geniisys.common.entity.GIISUserGrpHdr)
	 */
	@Override
	public void deleteGiisUserGrpHdrDetails(GIISUserGrpHdr userGrpHdr) throws SQLException {
		log.info("DAO calling deleteGiisUserGrpHdr...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.getSqlMapClient().delete("deleteGiisUserGrpLine", userGrpHdr.getUserGrp());
			this.getSqlMapClient().delete("deleteGiisUserGrpDtl", userGrpHdr.getUserGrp());
			this.getSqlMapClient().delete("deleteGiisUserGrpModule", userGrpHdr.getUserGrp());
			this.getSqlMapClient().delete("deleteGiisUserGrpTran", userGrpHdr.getUserGrp());
			
			/*// delete transactions
			for (GIISUserGrpTran t : userGrpHdr.getTransactions()) {
				// delete transaction issue sources
				for (GIISUserGrpDtl i : t.getIssueSources()) {
					// delete transaction issue source lines
					for (GIISUserGrpLine l : i.getLines()) {
						System.out.println("Deleting Line: " + l.getLineCd() + " | " + l.getIssCd() + " | " + l.getTranCd());
						this.getSqlMapClient().delete("deleteGiisUserGrpLine", l);
					}
					
					System.out.println("Deleting Issue: " + i.getIssCd() + " | " + i.getTranCd());
					this.getSqlMapClient().delete("deleteGiisUserGrpDtl", i);
				}
				
				// delete modules
				for (GIISUserGrpModule m: t.getModules()) {
					this.getSqlMapClient().delete("deleteGiisUserGrpModule", m);
				}
				
				System.out.println("Deleting Transaction: " + t.getTranCd());
				this.getSqlMapClient().delete("deleteGiisUserGrpTran", t);
			}*/

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Done deleting userGrpHdr details...");
	}

	@Override
	public String copyUserGrp(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().insert("copyUserGrp", params);
		return "SUCCESS";
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteRecGIISS041", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddRecGIISS041", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS041(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISUserGrpHdr> delList = (List<GIISUserGrpHdr>) params.get("delRows");
			for(GIISUserGrpHdr d: delList){
				this.getSqlMapClient().update("deleteRecGIISS041", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpHdr> setList = (List<GIISUserGrpHdr>) params.get("setRows");
			for(GIISUserGrpHdr s: setList){
				this.getSqlMapClient().update("setRecGIISS041", s);
				this.getSqlMapClient().executeBatch();
				
				if(!s.getCopyTag().toString().equals("0")){
					Map<String, Object> copyParams = new HashMap<String, Object>();
					copyParams.put("userGrp", s.getCopyTag());
					copyParams.put("newUserGrp", s.getUserGrp());
					copyParams.put("userId", s.getUserId());
					
					this.getSqlMapClient().update("copyUserGrpGIISS041", copyParams);
				}
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
