/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;


/**
 * The Class ApplicationWideParameters.
 */
public class ApplicationWideParameters {

	/** The Constant Y. */
	public static final String Y = "Y";
	
	/** The Constant N. */
	public static final String N = "N";
	
	/** The Constant PAGE_SIZE. */
	public static final int PAGE_SIZE = 10;
	
	public static final String RESULT_MESSAGE_DELIMITER = "-*|@geniisys@|*-";
	
	/** The default app color. */
	private String defaultAppColor;
	
	/** The default font and fontsize for reports*/
	private String defaultReportFont = "ARIAL";	
	private String clientBanner;
	private boolean autoBugReport;
	
	public static String DATE_FORMAT = "";
	public static final String DEFAULT_DATE_FORMAT = "MM-dd-yyyy";
	
	
	/**
	 * Gets the default app color.
	 * 
	 * @return the default app color
	 */
	public String getDefaultAppColor() {
		return defaultAppColor;
	}
	
	/**
	 * Sets the default app color.
	 * 
	 * @param defaultAppColor the new default app color
	 */
	public void setDefaultAppColor(String defaultAppColor) {
		this.defaultAppColor = defaultAppColor;
	}
	
	/**
	 * Gets the default font for reports
	 * 
	 * @return the default reports font
	 */
	public String getDefaultReportFont() {
		return defaultReportFont;
	}
	
	
	/**
	 * Sets the default font for reports.
	 * 
	 * @param defaultReportFontS the new default reports font
	 */
	public void setDefaultReportFont(String defaultReportFont) {
		this.defaultReportFont = defaultReportFont;
	}

	public void setClientBanner(String clientBanner) {
		this.clientBanner = clientBanner;
	}

	public String getClientBanner() {
		return clientBanner;
	}

	public void setAutoBugReport(boolean autoBugReport) {
		this.autoBugReport = autoBugReport;
	}

	public boolean isAutoBugReport() {
		return autoBugReport;
	}
}
