package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACMemoDAO;
import com.geniisys.giac.entity.GIACMemo;
import com.geniisys.giac.service.GIACMemoService;

public class GIACMemoServiceImpl implements GIACMemoService{

	private GIACMemoDAO giacMemoDAO;

	public GIACMemoDAO getGiacMemoDAO() {
		return giacMemoDAO;
	}

	public void setGiacMemoDAO(GIACMemoDAO giacMemoDAO) {
		this.giacMemoDAO = giacMemoDAO;
	}

	@Override
	public GIACMemo getDefaultMemo() throws SQLException {
		return this.getGiacMemoDAO().getDefaultMemo();
	}

	@Override
	public GIACMemo saveMemo(HttpServletRequest request,GIISUser USER) throws SQLException, Exception {
		GIACMemo memo = prepareMemo(request,USER.getUserId());
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("memo", memo);
		params.put("moduleId", request.getParameter("moduleId"));
		System.out.println("*********SERVICEIMPL ---- fundCd: " + memo.getFundCd() +"\nbranchCd: " +memo.getBranchCd());	
		
		return this.getGiacMemoDAO().saveMemo(params);
	}

	private GIACMemo prepareMemo(HttpServletRequest request, String userId) {
		GIACMemo memo = new GIACMemo();
		
		try {	
			memo.setGaccTranId((request.getParameter("gaccTranId").equals(null) || request.getParameter("gaccTranId").equals("")) ? null/*getNextTranId()*/ : Integer.parseInt(request.getParameter("gaccTranId")));
			System.out.println("nextId: " + memo.getGaccTranId());
			memo.setFundCd(request.getParameter("fundCd"));
			memo.setBranchCd(request.getParameter("branchCd"));
			memo.setMemoType(request.getParameter("memoType"));
			memo.setMemoStatus(request.getParameter("memoStatus")); 
			memo.setMemoDate(new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("memoDate")));
			memo.setMemoYear(Integer.parseInt(request.getParameter("memoYear")));
			memo.setMemoSeqNo(request.getParameter("memoSeqNo").equals(null) || request.getParameter("memoSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("memoSeqNo")));
			memo.setRecipient(request.getParameter("recipient"));
			memo.setParticulars(request.getParameter("particulars"));
			memo.setCurrencyCd(Integer.parseInt(request.getParameter("currencyCd")));
			//memo.setCurrencyRt(Float.parseFloat(request.getParameter("currencyRt"))); --marco - 06.11.2013 - changed type to double to prevent rounding of values
			memo.setCurrencyRt(Double.parseDouble(request.getParameter("currencyRt")));
			memo.setForeignAmount(new BigDecimal(request.getParameter("foreignAmount")));
			memo.setLocalAmount(new BigDecimal(request.getParameter("localAmount")));
			memo.setUserId(userId);
			memo.setLastUpdate(new SimpleDateFormat("MM-dd-yyyy K:mm:ss a").parse(request.getParameter("lastUpdate")));
			memo.setCancelFlag(request.getParameter("cancelFlag"));
			memo.setRiCommAmt(new BigDecimal(request.getParameter("riCommAmt"))); // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
			memo.setRiCommVat(new BigDecimal(request.getParameter("riCommVat"))); // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
			
		} catch (ParseException e) {
			System.out.println("CAUSE: \n" + e.getCause());
			System.out.println("MESSAGE : \n" + e.getMessage());
		} catch (NumberFormatException e) {
			System.out.println("CAUSE: \n" + e.getCause());
			System.out.println("MESSAGE : \n" + e.getMessage());
		} /*catch (SQLException e) {
			System.out.println("CAUSE: \n" + e.getCause());
			System.out.println("MESSAGE : \n" + e.getMessage());
		}*/
		
		return memo;
	}

	@Override
	public Integer getNextTranId() throws SQLException {
		return this.getGiacMemoDAO().getNextTranId();
	}

	@Override
	public GIACMemo getMemoInfo(Map<String, Object> params) throws SQLException {
		return this.getGiacMemoDAO().getMemoInfo(params);
	}

	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		return this.getGiacMemoDAO().getClosedTag(params);
	}

	@Override
	public String cancelMemo(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacMemoDAO().cancelMemo(params);
	}

	@Override
	public void updateMemoStatus(Map<String, Object> params) throws SQLException, Exception {
		this.getGiacMemoDAO().updateMemoStatus(params);		
	}

	@Override
	public String validateCurrSname(String currSname) throws SQLException {
		return this.getGiacMemoDAO().validateCurrSname(currSname);
	}

}
