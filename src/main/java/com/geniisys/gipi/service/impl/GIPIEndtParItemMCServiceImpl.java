package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIEndtParItemMCDAO;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.geniisys.gipi.service.GIPIEndtParItemMCService;

public class GIPIEndtParItemMCServiceImpl implements GIPIEndtParItemMCService {
	
	/** The gipi par item mcdao. */
	private GIPIEndtParItemMCDAO gipiEndtParItemMCDAO;

	public void setGipiEndtParItemMCDAO(GIPIEndtParItemMCDAO gipiEndtParItemMCDAO) {
		this.gipiEndtParItemMCDAO = gipiEndtParItemMCDAO;
	}

	public GIPIEndtParItemMCDAO getGipiEndtParItemMCDAO() {
		return gipiEndtParItemMCDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#getGIPIEndtParItemMC(int, int)
	 */
	@Override
	public GIPIParItemMC getGIPIEndtParItemMC(int parId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().getGIPIEndtParItemMC(parId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#getGIPIEndtParItemMCs(int)
	 */
	@Override
	public List<GIPIParItemMC> getGIPIEndtParItemMCs(int parId)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().getGIPIEndtParItemMCs(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#getEndtTax(int)
	 */
	@Override
	public String getEndtTax(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().getEndtTax(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#checkIfDiscountExists(int)
	 */
	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().checkIfDiscountExists(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#deleteItem(int, int[], int)
	 */
	@Override
	public boolean deleteItem(int parId, int[] itemNo, int currentItemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().deleteItem(parId, itemNo, currentItemNo);
	}

	@Override
	public String addItem(int parId, int[] itemNo) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().addItem(parId, itemNo);
	}

	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().checkAddtlInfo(parId);
	}

	@Override
	public String populateOrigItmperil(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().populateOrigItmperil(parId);
	}

	@Override
	public int getDistNo(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().getDistNo(parId);
	}

	@Override
	public String deleteDistribution(int parId, int distNo) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().deleteDistribution(parId, distNo);
	}

	@Override
	public boolean deleteWinvRecords(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiEndtParItemMCDAO().deleteWinvRecords(parId);
	}
}
