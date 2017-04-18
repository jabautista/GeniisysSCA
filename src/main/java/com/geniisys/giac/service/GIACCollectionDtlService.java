package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.entity.GIACCollectionDtl;

public interface GIACCollectionDtlService {

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
