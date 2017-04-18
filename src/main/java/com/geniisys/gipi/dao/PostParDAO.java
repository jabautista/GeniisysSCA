package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.exceptions.PostingParException;

public interface PostParDAO {

	String postPar(Map<String, Object> params) throws SQLException, PostingParException, Exception;
	Map<String, String> checkBackEndt(Integer parId) throws SQLException;
	Map<String, Object> validateMC(Map<String, Object> params) throws SQLException;
	String postFrps(Map<String, Object> params) throws SQLException;
	String postpackPar(Map<String, Object> params) throws SQLException, Exception;
	String checkBackEndtPack(Integer packParId) throws SQLException;
	List<Map<String, Object>> getParCancellationMsg(Integer parId) throws SQLException;
	List<Map<String, Object>> getParCancellationMsg2(Integer packParId) throws SQLException;
	void validateInstallment(Map<String, Object> params) throws SQLException;
	//COC Authentication
	String checkCOCAuthentication(Map<String, Object> params) throws SQLException;
	String checkPackCOCAuthentication(Map<String, Object> params) throws SQLException;
}
