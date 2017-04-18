package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLClmRecoveryDtlService {

	void getGiclClmRecoveryDtlGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;

}
