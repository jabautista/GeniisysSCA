package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.entity.GIACCollectionDtl;

public interface GIACCollectionDtlDAO {

	/**
	 * Gets GIAC collection detail of specified transaction ID
	 * @param tranId The transaction ID
	 * @return
	 * @throws SQLException
	 */
	GIACCollectionDtl getGIACCollectionDtl(int tranId) throws SQLException;
	
	/**
	 * Gets GIAC collection detail of specified transaction ID
	 * @param tranId The transaction ID
	 * @return
	 * @throws SQLException
	 */
	List<GIACCollectionDtl> getGIACCollnDtl(int tranId) throws SQLException;
}
