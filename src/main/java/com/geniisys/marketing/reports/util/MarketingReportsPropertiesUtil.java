package com.geniisys.marketing.reports.util;

public class MarketingReportsPropertiesUtil {

	//reports locations
	public static final String REPORTS_LOCATION_ACCIDENT = "/com/geniisys/marketing/accident/reports/";
	public static final String REPORTS_LOCATION_FIRE = "/com/geniisys/marketing/fire/reports/";
	public static final String REPORTS_LOCATION_CASUALTY = "/com/geniisys/marketing/casualty/reports/";
	public static final String REPORTS_LOCATION_MARINE_CARGO = "/com/geniisys/marketing/marinecargo/reports/";
	public static final String REPORTS_LOCATION_MARINE_HULL = "/com/geniisys/marketing/marinehull/reports/";
	public static final String REPORTS_LOCATION_AVIATION = "/com/geniisys/marketing/aviation/reports/";
	public static final String REPORTS_LOCATION_MOTORCAR = "/com/geniisys/marketing/motorcar/reports/";
	public static final String REPORTS_LOCATION_ENGINEERING = "/com/geniisys/marketing/engineering/reports/";
	public static final String REPORTS_LOCATION_SURETYSHIP = "/com/geniisys/marketing/bond/reports/";
	public static final String REPORTS_LOCATION_PACKAGE = "/com/geniisys/marketing/pack/reports/";
	public static final String REPORTS_LOCATION_STATISTICAL = "/com/geniisys/marketing/statistical/reports/";
	
	
	//reports in Marketing
	private static final String GIPIR909 = "GIPIR909_AGENT_BROKER_PROD";
	private static final String GIPIR909A = "GIPIR909a_CONVERTED_QUOTES";
	private static final String GIPIR910 = "GIPIR910_AGENT_BROKER_PROD_REP";
	
	//array for reportId(supplied from controller), jasper report name and generated report filename
	private String [][] reportsList = {{"GIPIR909", GIPIR909, "QUOTATION_WITH_AGENT_INTM_BREAK_"},
										{"GIPIR909A", GIPIR909A, "QUOTATION_WITHOUT_AGENT_INTM_BREAK_"},
										{"GIPIR910", GIPIR910, "LOST_BID"}};
	
	
	/************************ LINES *************************/
	private String[][] lines = {{"AC", "ACCIDENT_", REPORTS_LOCATION_ACCIDENT, "PA", "ACCIDENT"},
								{"PA", "ACCIDENT_", REPORTS_LOCATION_ACCIDENT, "AC", "ACCIDENT"},
			                    {"FI", "FIRE_QUOTE_", REPORTS_LOCATION_FIRE, "FI", "FIRE"},
								{"CA", "CASUALTY_", REPORTS_LOCATION_CASUALTY, "LI", "CASUALTY"},
								{"LI", "CASUALTY_", REPORTS_LOCATION_CASUALTY, "CA", "CASUALTY"},
								{"MN", "MARINE_CARGO_", REPORTS_LOCATION_MARINE_CARGO, "MR", "MARINE_CARGO"},
								{"MR", "MARINE_CARGO_", REPORTS_LOCATION_MARINE_CARGO, "MN", "MARINE_CARGO"},
								{"MH", "MARINE_HULL_", REPORTS_LOCATION_MARINE_HULL, "MH", "MARINE_HULL"},
								{"AV", "AVIATION_", REPORTS_LOCATION_AVIATION, "AV", "AVIATION"},
								{"MC", "MOTORCAR_", REPORTS_LOCATION_MOTORCAR, "MC", "MOTORCAR"},
								{"EN", "ENGINEERING_", REPORTS_LOCATION_ENGINEERING, "EN", "ENGINEERING"},
								{"SU", "BOND_QUOTE_", REPORTS_LOCATION_SURETYSHIP, "SU", "BOND"},
								{"PK", "PACKAGE_QUOTE_", REPORTS_LOCATION_PACKAGE, "PK", "PACKAGE"},};
	
	

	
	/*************************************************/

	public String getLine(String lineCd) throws NullPointerException {
		for (String[] l: lines) {
			if (l[0].equals(lineCd)) {
				return l[1];
			}
		}
		throw new NullPointerException();
	}
	
	public String getMenuLineCd(String lineCd) throws NullPointerException {
		for (String[] l: lines) {
			if (l[0].equals(lineCd) || l[3].equals(lineCd)) {
				return l[0];
			}
		}
		throw new NullPointerException();
	}
	
	public String getSubreportDir(String lineCd) throws NullPointerException {
		System.out.println("MarketingReportsPropertiesUtil.getSubreportDir - lineCd - "+lineCd);
		for (String[] l: lines) {
			if (l[0].equals(lineCd)) {
				return l[2];
			}
		}
		throw new NullPointerException();
	}
	
	public String getReportFileName(String reportId){
		for (String[] r: reportsList) {
			if (r[0].equalsIgnoreCase(reportId)) {
				System.out.println("Opening - "+r[1]);
				return r[1];
			}
		}
		throw new NullPointerException();
	}
	
	public String getGeneratedReportFileName(String reportId){
		for (String[] r: reportsList) {
			if (r[0].equalsIgnoreCase(reportId)) {
				System.out.println("Report generated filename: - "+r[2]);
				return r[1];
			}
		}
		throw new NullPointerException();
	}
	
	public String getLineName(String lineCd) throws NullPointerException {
		for (String[] l: lines) {
			if (l[0].equals(lineCd)) {
				return l[4];
			}
		}
		throw new NullPointerException();
	}
}
