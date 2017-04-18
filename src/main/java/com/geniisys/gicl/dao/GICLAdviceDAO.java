/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 9, 2010
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLAdvice;

public interface GICLAdviceDAO {
	/**
	 * Retrieve a GICLAdvice from database using its adviceId
	 * @param adviceId
	 * @return a GICLAdvice
	 */
	GICLAdvice getGICLAdvice(Integer adviceId) throws SQLException;
	void gicls032NewFormInstance(Map<String, Object> params) throws SQLException;
	void gicls032EnableDisableButtons(Map<String, Object> params) throws SQLException;
	void gicls032CancelAdvice(Map<String, Object> params) throws SQLException;
	void gicls032GenerateAdvice(Map<String, Object> params) throws SQLException;
	void gicls032ApproveCsr(Map<String, Object> params) throws SQLException;
	void gicls032GenerateAcc(Map<String, Object> params) throws SQLException;
	void gicls032SaveRemarks(Map<String, Object> params) throws SQLException;
	Integer gicls032CheckRequestExist(Map<String, Object> params) throws SQLException;
	void gicls032CreateOverrideRequest(Map<String, Object> params) throws SQLException;
	void gicls032CheckTsi(Map<String, Object> params) throws SQLException;
	String checkGeneratedFla(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGICLS260Advice(Map<String, Object> params) throws SQLException;
}
