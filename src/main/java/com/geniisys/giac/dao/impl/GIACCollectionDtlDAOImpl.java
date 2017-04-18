package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCollectionDtlDAO;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCollectionDtlDAOImpl implements GIACCollectionDtlDAO {

	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACCollectionDtlDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollectionDtlDAO#getGIACCollectionDtl(int)
	 */
	@Override
	public GIACCollectionDtl getGIACCollectionDtl(int tranId)
			throws SQLException {
		log.info("");
		return (GIACCollectionDtl) this.getSqlMapClient().queryForObject("getGIACCollectionDtl", tranId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollectionDtlDAO#getGIACCollnDtl(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACCollectionDtl> getGIACCollnDtl(int tranId) throws SQLException {
		return (List<GIACCollectionDtl>) this.getSqlMapClient().queryForList("getGIACCollnDtl", tranId);
	}
	
}
