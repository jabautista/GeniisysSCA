package com.geniisys.gipi.entity;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWEndtText extends BaseEntity {
	private static Logger log = Logger.getLogger(GIPIWEndtText.class);
	
	private int parId;
	private String endtText;
	private String endtTax;
	private String endtText01;
	private String endtText02;
	private String endtText03;
	private String endtText04;
	private String endtText05;
	private String endtText06;
	private String endtText07;
	private String endtText08;
	private String endtText09;
	private String endtText10;
	private String endtText11;
	private String endtText12;
	private String endtText13;
	private String endtText14;
	private String endtText15;
	private String endtText16;
	private String endtText17;
	private String endtCd;
	
	public int getParId() {
		return parId;
	}
	public void setParId(int parId) {
		this.parId = parId;
	}
	public String getEndtText() {
		return endtText;
	}
	public void setEndtText(String endtText) {
		this.endtText = endtText;
	}
	public String getEndtTax() {
		return endtTax;
	}
	public void setEndtTax(String endtTax) {
		this.endtTax = endtTax;
	}
	public String getEndtText01() {
		return endtText01;
	}
	public void setEndtText01(String endtText01) {
		this.endtText01 = endtText01;
	}
	public String getEndtText02() {
		return endtText02;
	}
	public void setEndtText02(String endtText02) {
		this.endtText02 = endtText02;
	}
	public String getEndtText03() {
		return endtText03;
	}
	public void setEndtText03(String endtText03) {
		this.endtText03 = endtText03;
	}
	public String getEndtText04() {
		return endtText04;
	}
	public void setEndtText04(String endtText04) {
		this.endtText04 = endtText04;
	}
	public String getEndtText05() {
		return endtText05;
	}
	public void setEndtText05(String endtText05) {
		this.endtText05 = endtText05;
	}
	public String getEndtText06() {
		return endtText06;
	}
	public void setEndtText06(String endtText06) {
		this.endtText06 = endtText06;
	}
	public String getEndtText07() {
		return endtText07;
	}
	public void setEndtText07(String endtText07) {
		this.endtText07 = endtText07;
	}
	public String getEndtText08() {
		return endtText08;
	}
	public void setEndtText08(String endtText08) {
		this.endtText08 = endtText08;
	}
	public String getEndtText09() {
		return endtText09;
	}
	public void setEndtText09(String endtText09) {
		this.endtText09 = endtText09;
	}
	public String getEndtText10() {
		return endtText10;
	}
	public void setEndtText10(String endtText10) {
		this.endtText10 = endtText10;
	}
	public String getEndtText11() {
		return endtText11;
	}
	public void setEndtText11(String endtText11) {
		this.endtText11 = endtText11;
	}
	public String getEndtText12() {
		return endtText12;
	}
	public void setEndtText12(String endtText12) {
		this.endtText12 = endtText12;
	}
	public String getEndtText13() {
		return endtText13;
	}
	public void setEndtText13(String endtText13) {
		this.endtText13 = endtText13;
	}
	public String getEndtText14() {
		return endtText14;
	}
	public void setEndtText14(String endtText14) {
		this.endtText14 = endtText14;
	}
	public String getEndtText15() {
		return endtText15;
	}
	public void setEndtText15(String endtText15) {
		this.endtText15 = endtText15;
	}
	public String getEndtText16() {
		return endtText16;
	}
	public void setEndtText16(String endtText16) {
		this.endtText16 = endtText16;
	}
	public String getEndtText17() {
		return endtText17;
	}
	public void setEndtText17(String endtText17) {
		this.endtText17 = endtText17;
	}
	public String getEndtCd() {
		return endtCd;
	}
	public void setEndtCd(String endtCd) {
		this.endtCd = endtCd;
	}
	
	public GIPIWEndtText(){
		//
	}
	
	public GIPIWEndtText(JSONObject json, String userId){
		try{
			this.parId			= json.isNull("parId") ? null : json.getInt("parId");
			this.endtText		= json.isNull("endtText") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText"));
			this.endtTax		= json.isNull("endtTax") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtTax"));
			this.endtText01		= json.isNull("endtText01") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText01"));
			this.endtText02		= json.isNull("endtText02") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText02"));
			this.endtText03		= json.isNull("endtText03") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText03"));
			this.endtText04		= json.isNull("endtText04") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText04"));
			this.endtText05		= json.isNull("endtText05") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText05"));
			this.endtText06		= json.isNull("endtText06") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText06"));
			this.endtText07		= json.isNull("endtText07") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText07"));
			this.endtText08		= json.isNull("endtText08") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText08"));
			this.endtText09		= json.isNull("endtText09") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText09"));
			this.endtText10		= json.isNull("endtText10") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText10"));
			this.endtText11		= json.isNull("endtText11") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText11"));
			this.endtText12		= json.isNull("endtText12") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText12"));
			this.endtText13		= json.isNull("endtText13") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText13"));
			this.endtText14		= json.isNull("endtText14") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText14"));
			this.endtText15		= json.isNull("endtText15") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText15"));
			this.endtText16		= json.isNull("endtText16") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText16"));
			this.endtText17		= json.isNull("endtText17") ? null : StringEscapeUtils.unescapeHtml(json.getString("endtText17"));
			this.endtCd			= json.isNull("endtCd") ? null : json.getString("endtCd");
			this.setUserId(userId); // added by andrew - 07.09.2012 - to be passed in giis_users_pkg.app_user
		} catch (JSONException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}
}
