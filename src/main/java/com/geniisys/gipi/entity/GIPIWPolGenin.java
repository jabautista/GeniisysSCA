/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWPolGenin.
 */
public class GIPIWPolGenin extends BaseEntity {
	private static Logger log = Logger.getLogger(GIPIWPolGenin.class);
	
	/** The par id. */
	private int parId;
	
	/** The first info. */
	private String firstInfo;
	
	/** The agreed tag. */
	private String agreedTag;
	
	/** The genin info cd. */
	private String geninInfoCd;
	
	/** The dsp initial info. */
	private String dspInitialInfo;
	
	/** The dsp gen info. */
	private String dspGenInfo;
	
	private String initialInfo01;
	private String initialInfo02;
	private String initialInfo03;
	private String initialInfo04;
	private String initialInfo05;
	private String initialInfo06;
	private String initialInfo07;
	private String initialInfo08;
	private String initialInfo09;
	private String initialInfo10;
	private String initialInfo11;
	private String initialInfo12;
	private String initialInfo13;
	private String initialInfo14;
	private String initialInfo15;
	private String initialInfo16;
	private String initialInfo17;
	private String genInfo01;
	private String genInfo02;
	private String genInfo03;
	private String genInfo04;
	private String genInfo05;
	private String genInfo06;
	private String genInfo07;
	private String genInfo08;
	private String genInfo09;
	private String genInfo10;
	private String genInfo11;
	private String genInfo12;
	private String genInfo13;
	private String genInfo14;
	private String genInfo15;
	private String genInfo16;
	private String genInfo17;
	private String genInfo;
	
	public String getInitialInfo01() {
		return initialInfo01;
	}

	public void setInitialInfo01(String initialInfo01) {
		this.initialInfo01 = initialInfo01;
	}

	public String getInitialInfo02() {
		return initialInfo02;
	}

	public void setInitialInfo02(String initialInfo02) {
		this.initialInfo02 = initialInfo02;
	}

	public String getInitialInfo03() {
		return initialInfo03;
	}

	public void setInitialInfo03(String initialInfo03) {
		this.initialInfo03 = initialInfo03;
	}

	public String getInitialInfo04() {
		return initialInfo04;
	}

	public void setInitialInfo04(String initialInfo04) {
		this.initialInfo04 = initialInfo04;
	}

	public String getInitialInfo05() {
		return initialInfo05;
	}

	public void setInitialInfo05(String initialInfo05) {
		this.initialInfo05 = initialInfo05;
	}

	public String getInitialInfo06() {
		return initialInfo06;
	}

	public void setInitialInfo06(String initialInfo06) {
		this.initialInfo06 = initialInfo06;
	}

	public String getInitialInfo07() {
		return initialInfo07;
	}

	public void setInitialInfo07(String initialInfo07) {
		this.initialInfo07 = initialInfo07;
	}

	public String getInitialInfo08() {
		return initialInfo08;
	}

	public void setInitialInfo08(String initialInfo08) {
		this.initialInfo08 = initialInfo08;
	}

	public String getInitialInfo09() {
		return initialInfo09;
	}

	public void setInitialInfo09(String initialInfo09) {
		this.initialInfo09 = initialInfo09;
	}

	public String getInitialInfo10() {
		return initialInfo10;
	}

	public void setInitialInfo10(String initialInfo10) {
		this.initialInfo10 = initialInfo10;
	}

	public String getInitialInfo11() {
		return initialInfo11;
	}

	public void setInitialInfo11(String initialInfo11) {
		this.initialInfo11 = initialInfo11;
	}

	public String getInitialInfo12() {
		return initialInfo12;
	}

	public void setInitialInfo12(String initialInfo12) {
		this.initialInfo12 = initialInfo12;
	}

	public String getInitialInfo13() {
		return initialInfo13;
	}

	public void setInitialInfo13(String initialInfo13) {
		this.initialInfo13 = initialInfo13;
	}

	public String getInitialInfo14() {
		return initialInfo14;
	}

	public void setInitialInfo14(String initialInfo14) {
		this.initialInfo14 = initialInfo14;
	}

	public String getInitialInfo15() {
		return initialInfo15;
	}

	public void setInitialInfo15(String initialInfo15) {
		this.initialInfo15 = initialInfo15;
	}

	public String getInitialInfo16() {
		return initialInfo16;
	}

	public void setInitialInfo16(String initialInfo16) {
		this.initialInfo16 = initialInfo16;
	}

	public String getInitialInfo17() {
		return initialInfo17;
	}

	public void setInitialInfo17(String initialInfo17) {
		this.initialInfo17 = initialInfo17;
	}

	public String getGenInfo01() {
		return genInfo01;
	}

	public void setGenInfo01(String genInfo01) {
		this.genInfo01 = genInfo01;
	}

	public String getGenInfo02() {
		return genInfo02;
	}

	public void setGenInfo02(String genInfo02) {
		this.genInfo02 = genInfo02;
	}

	public String getGenInfo03() {
		return genInfo03;
	}

	public void setGenInfo03(String genInfo03) {
		this.genInfo03 = genInfo03;
	}

	public String getGenInfo04() {
		return genInfo04;
	}

	public void setGenInfo04(String genInfo04) {
		this.genInfo04 = genInfo04;
	}

	public String getGenInfo05() {
		return genInfo05;
	}

	public void setGenInfo05(String genInfo05) {
		this.genInfo05 = genInfo05;
	}

	public String getGenInfo06() {
		return genInfo06;
	}

	public void setGenInfo06(String genInfo06) {
		this.genInfo06 = genInfo06;
	}

	public String getGenInfo07() {
		return genInfo07;
	}

	public void setGenInfo07(String genInfo07) {
		this.genInfo07 = genInfo07;
	}

	public String getGenInfo08() {
		return genInfo08;
	}

	public void setGenInfo08(String genInfo08) {
		this.genInfo08 = genInfo08;
	}

	public String getGenInfo09() {
		return genInfo09;
	}

	public void setGenInfo09(String genInfo09) {
		this.genInfo09 = genInfo09;
	}

	public String getGenInfo10() {
		return genInfo10;
	}

	public void setGenInfo10(String genInfo10) {
		this.genInfo10 = genInfo10;
	}

	public String getGenInfo11() {
		return genInfo11;
	}

	public void setGenInfo11(String genInfo11) {
		this.genInfo11 = genInfo11;
	}

	public String getGenInfo12() {
		return genInfo12;
	}

	public void setGenInfo12(String genInfo12) {
		this.genInfo12 = genInfo12;
	}

	public String getGenInfo13() {
		return genInfo13;
	}

	public void setGenInfo13(String genInfo13) {
		this.genInfo13 = genInfo13;
	}

	public String getGenInfo14() {
		return genInfo14;
	}

	public void setGenInfo14(String genInfo14) {
		this.genInfo14 = genInfo14;
	}

	public String getGenInfo15() {
		return genInfo15;
	}

	public void setGenInfo15(String genInfo15) {
		this.genInfo15 = genInfo15;
	}

	public String getGenInfo16() {
		return genInfo16;
	}

	public void setGenInfo16(String genInfo16) {
		this.genInfo16 = genInfo16;
	}

	public String getGenInfo17() {
		return genInfo17;
	}

	public void setGenInfo17(String genInfo17) {
		this.genInfo17 = genInfo17;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public int getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(int parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the first info.
	 * 
	 * @return the first info
	 */
	public String getFirstInfo() {
		return firstInfo;
	}
	
	/**
	 * Sets the first info.
	 * 
	 * @param firstInfo the new first info
	 */
	public void setFirstInfo(String firstInfo) {
		this.firstInfo = firstInfo;
	}
	
	/**
	 * Gets the agreed tag.
	 * 
	 * @return the agreed tag
	 */
	public String getAgreedTag() {
		return agreedTag;
	}
	
	/**
	 * Sets the agreed tag.
	 * 
	 * @param agreedTag the new agreed tag
	 */
	public void setAgreedTag(String agreedTag) {
		this.agreedTag = agreedTag;
	}
	
	/**
	 * Gets the genin info cd.
	 * 
	 * @return the genin info cd
	 */
	public String getGeninInfoCd() {
		return geninInfoCd;
	}
	
	/**
	 * Sets the genin info cd.
	 * 
	 * @param geninInfoCd the new genin info cd
	 */
	public void setGeninInfoCd(String geninInfoCd) {
		this.geninInfoCd = geninInfoCd;
	}
	
	/**
	 * Gets the dsp initial info.
	 * 
	 * @return the dsp initial info
	 */
	public String getDspInitialInfo() {
		return dspInitialInfo;
	}
	
	/**
	 * Sets the dsp initial info.
	 * 
	 * @param dspInitialInfo the new dsp initial info
	 */
	public void setDspInitialInfo(String dspInitialInfo) {
		this.dspInitialInfo = dspInitialInfo;
	}
	
	/**
	 * Gets the dsp gen info.
	 * 
	 * @return the dsp gen info
	 */
	public String getDspGenInfo() {
		return dspGenInfo;
	}
	
	/**
	 * Sets the dsp gen info.
	 * 
	 * @param dspGenInfo the new dsp gen info
	 */
	public void setDspGenInfo(String dspGenInfo) {
		this.dspGenInfo = dspGenInfo;
	}

	public String getGenInfo() {
		return genInfo;
	}

	public void setGenInfo(String genInfo) {
		this.genInfo = genInfo;
	}
	
	public GIPIWPolGenin(){
		//
	}
	
	public GIPIWPolGenin(JSONObject json, String userId){
		try{
			this.parId			= json.isNull("parId") ? null : json.getInt("parId");
			this.firstInfo		= json.isNull("firstInfo") ? null : StringEscapeUtils.unescapeHtml(json.getString("firstInfo"));
			this.agreedTag		= json.isNull("agreedTag") ? null : StringEscapeUtils.unescapeHtml(json.getString("agreedTag"));
			this.geninInfoCd	= json.isNull("geninInfoCd") ? null : StringEscapeUtils.unescapeHtml(json.getString("geninInfoCd"));
			this.dspInitialInfo	= json.isNull("dspInitialInfo") ? null : json.getString("dspInitialInfo");
			this.dspGenInfo		= json.isNull("dspGenInfo") ? null : json.getString("dspGenInfo");
			this.initialInfo01	= json.isNull("initialInfo01") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo01"));
			this.initialInfo02	= json.isNull("initialInfo02") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo02"));
			this.initialInfo03	= json.isNull("initialInfo03") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo03"));
			this.initialInfo04	= json.isNull("initialInfo04") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo04"));
			this.initialInfo05	= json.isNull("initialInfo05") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo05"));
			this.initialInfo06	= json.isNull("initialInfo06") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo06"));
			this.initialInfo07	= json.isNull("initialInfo07") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo07"));
			this.initialInfo08	= json.isNull("initialInfo08") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo08"));
			this.initialInfo09	= json.isNull("initialInfo09") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo09"));
			this.initialInfo10	= json.isNull("initialInfo10") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo10"));
			this.initialInfo11	= json.isNull("initialInfo11") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo11"));
			this.initialInfo12	= json.isNull("initialInfo12") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo12"));
			this.initialInfo13	= json.isNull("initialInfo13") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo13"));
			this.initialInfo14	= json.isNull("initialInfo14") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo14"));
			this.initialInfo15	= json.isNull("initialInfo15") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo15"));
			this.initialInfo16	= json.isNull("initialInfo16") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo16"));
			this.initialInfo17	= json.isNull("initialInfo17") ? null : StringEscapeUtils.unescapeHtml(json.getString("initialInfo17"));
			this.genInfo01		= json.isNull("genInfo01") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo01"));
			this.genInfo02		= json.isNull("genInfo02") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo02"));
			this.genInfo03		= json.isNull("genInfo03") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo03"));
			this.genInfo04		= json.isNull("genInfo04") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo04"));
			this.genInfo05		= json.isNull("genInfo05") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo05"));
			this.genInfo06		= json.isNull("genInfo06") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo06"));
			this.genInfo07		= json.isNull("genInfo07") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo07"));
			this.genInfo08		= json.isNull("genInfo08") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo08"));
			this.genInfo09		= json.isNull("genInfo09") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo09"));
			this.genInfo10		= json.isNull("genInfo10") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo10"));
			this.genInfo11		= json.isNull("genInfo11") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo11"));
			this.genInfo12		= json.isNull("genInfo12") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo12"));
			this.genInfo13		= json.isNull("genInfo13") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo13"));
			this.genInfo14		= json.isNull("genInfo14") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo14"));
			this.genInfo15		= json.isNull("genInfo15") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo15"));
			this.genInfo16		= json.isNull("genInfo16") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo16"));
			this.genInfo17		= json.isNull("genInfo17") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo17"));
			this.genInfo		= json.isNull("genInfo") ? null : StringEscapeUtils.unescapeHtml(json.getString("genInfo"));
			this.setUserId(userId); // added by andrew - 07.09.2012 - to be passed in giis_users_pkg.app_user
		}catch(JSONException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}
	
}
