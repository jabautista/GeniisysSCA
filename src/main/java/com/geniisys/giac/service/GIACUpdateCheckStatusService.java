package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACUpdateCheckStatusService {

	void showUpdateCheckStatus(HttpServletRequest request, GIISUser USER) throws SQLException,Exception;

	JSONObject showBankAccount(HttpServletRequest request, GIISUser USER) throws SQLException,Exception;

	JSONObject showDisbursementAccount(HttpServletRequest request, GIISUser USER) throws SQLException,Exception;

	void saveChkDisbursement(HttpServletRequest request, GIISUser USER)throws SQLException,Exception;

}
