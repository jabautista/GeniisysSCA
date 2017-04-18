package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWEngBasicDAO;
import com.geniisys.gipi.entity.GIPIWPrincipal;
import com.geniisys.gipi.entity.GIPIWEngBasic;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWEngBasicDAOImpl implements GIPIWEngBasicDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWEngBasic.class);
	
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public GIPIWEngBasic getWEngBasicInfo(int parId) throws SQLException {
		log.info("DAO - Getting engineering basic inf0...");
		GIPIWPolbas x = (GIPIWPolbas) this.getSqlMapClient().queryForObject("getGipiWPolbas", parId);
		GIPIWEngBasic enInfo = (GIPIWEngBasic) this.getSqlMapClient().queryForObject("getAdditionalENBasicInfo", parId);
		System.out.println("DAO retrieved: - " + x.getSublineCd() + "for par: " + parId);
		log.info("DAO - Engineering basic info retrieved...");
		return enInfo;
	}

	@Override
	public void setWEngBasicInfo(GIPIWEngBasic enInfo) throws SQLException {
		log.info("DAO - Saving additional engineering info for par id - " + enInfo.getParId());
		this.getSqlMapClient().insert("setENAdditionalInfo", enInfo);
		log.info("DAO - additional engineering info saved...");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPrincipal> getENPrincipals(int parId, String pType)
			throws SQLException {
		List<GIPIWPrincipal> wPrincipals = new ArrayList<GIPIWPrincipal>();
		if(pType.equals("P")) {
			log.info("DAO - Getting available principals for par id - " + parId);
			wPrincipals = this.getSqlMapClient().queryForList("getENWPrincipalList", parId); 
		} else if (pType.equals("C")) {
			log.info("DAO - Getting available contractors for par id - " + parId);
			wPrincipals = this.getSqlMapClient().queryForList("getENContractorList", parId); 
		}
		log.info("DAO - (Principal) " + wPrincipals.size() + " record/s retrieved...");
		return wPrincipals;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveENPrincipals(Map<String, Object> principals, int parId)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//this.getSqlMapClient().delete("delENPrincipal", parId);
			
			List<GIPIWPrincipal> setPrn = (List<GIPIWPrincipal>) principals.get("enPrincipals");
			//List<GIPIWPrincipal> setCon = (List<GIPIWPrincipal>) principals.get("enContractors");
			List<GIPIWPrincipal> delPrn = (List<GIPIWPrincipal>) principals.get("delPrincipals");
			
			if(delPrn != null) {
				Map<String, Object> paramsDel = new HashMap<String, Object>();
				log.info("DAO - Deleting " + delPrn.size() + " Principals...");
				for (GIPIWPrincipal prn: delPrn) {
					paramsDel.put("parId", prn.getParId());
					paramsDel.put("principalCd", prn.getPrincipalCd());
					this.getSqlMapClient().delete("delENPrincipal", paramsDel);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWPrincipal wprincipal : setPrn) {
				this.getSqlMapClient().insert("setENPrincipal", wprincipal);
				log.info("DAO - saving principal: " + wprincipal.getPrincipalCd());
			}
		/*	for(GIPIWPrincipal wContractors : setCon) {
				this.getSqlMapClient().insert("setENPrincipal", wContractors);
				System.out.println("DAO - saving contractor" + wContractors.getPrincipalCd());
			}*/
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
}
