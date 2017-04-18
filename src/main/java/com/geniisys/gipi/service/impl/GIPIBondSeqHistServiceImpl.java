package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIBondSeqHistDAO;
import com.geniisys.gipi.service.GIPIBondSeqHistService;

public class GIPIBondSeqHistServiceImpl implements GIPIBondSeqHistService{

	private GIPIBondSeqHistDAO gipiBondSeqHistDAO;
	public GIPIBondSeqHistDAO getGipiBondSeqHistDAO() {
		return gipiBondSeqHistDAO;
	}
	public void setGipiBondSeqHistDAO(GIPIBondSeqHistDAO gipiBondSeqHistDAO) {
		this.gipiBondSeqHistDAO = gipiBondSeqHistDAO;
	}

	@Override
	public List<Integer> getBondSeqNoList(Map<String, Object> param)
			throws SQLException {
		return gipiBondSeqHistDAO.getBondSeqNoList(param);
	}
	@Override
	public void updBondSeqHist(Map<String, Object> param) throws SQLException {
		gipiBondSeqHistDAO.updBondSeqHist(param);
	}
	@Override
	public boolean isValidBondSeq(Map<String, Object> param)
			throws SQLException {
		Integer v = this.gipiBondSeqHistDAO.validateBondSeq(param);
		if (v.equals(1)){
			return true;
		} else {
			return false;
		}
	}
}
