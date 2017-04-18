package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.dao.GIACCollectionDtlDAO;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.geniisys.giac.service.GIACCollectionDtlService;

public class GIACCollectionDtlServiceImpl implements GIACCollectionDtlService {

	/** The GIAC Collection Dtl dao. */
	private GIACCollectionDtlDAO giacCollectionDtlDAO;
	
	public void setGiacCollectionDtlDAO(GIACCollectionDtlDAO giacCollectionDtlDAO) {
		this.giacCollectionDtlDAO = giacCollectionDtlDAO;
	}

	public GIACCollectionDtlDAO getGiacCollectionDtlDAO() {
		return giacCollectionDtlDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCollectionDtlService#getGIACCollectionDtl(int)
	 */
	@Override
	public GIACCollectionDtl getGIACCollectionDtl(int tranId)
			throws SQLException {
		return this.getGiacCollectionDtlDAO().getGIACCollectionDtl(tranId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCollectionDtlService#getGIACCollnDtl(int)
	 */
	@Override
	public List<GIACCollectionDtl> getGIACCollnDtl(int tranId) throws SQLException {
		return (List<GIACCollectionDtl>) this.getGiacCollectionDtlDAO().getGIACCollnDtl(tranId);
	}
	
}
