package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GIISBondSeqService {

	/**
	 * Generates a number of bond sequences
	 * based on parameter noOfSequence.
	 * @param request
	 * @return Integer - Returns the successfully generated bond sequence
	 * if param noOfSequence is 1. 0 if noOfSequence is > 1.
	 * @throws SQLException
	 */
	Integer generateBondSeq(HttpServletRequest request, Integer noOfSequence, GIISUser USER) throws SQLException;
}
