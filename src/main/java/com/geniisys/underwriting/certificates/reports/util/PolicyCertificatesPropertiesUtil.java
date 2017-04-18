package com.geniisys.underwriting.certificates.reports.util;

public class PolicyCertificatesPropertiesUtil {
	
	public static final String certReportsLocation = "/com/geniisys/underwriting/certificates/reports/";
	
	private String[][] certs = {{"ACCIDENT", 	 "ACCIDENT_COC", 	 "OTHER_LINES_CERTIFICATE"},
			  					{"AVIATION", 	 "AVIATION_COC", 	 "OTHER_LINES_CERTIFICATE"},
			  					{"CASUALTY", 	 "CASUALTY_COC", 	 "CASUALTY_CERTIFICATE"},
			  					{"ENGINEERING",  "ENGINEERING_COC",  "OTHER_LINES_CERTIFICATE"},
			  					{"FIRE", 		 "FIRE_COC", 		 "FIRE_CERTIFICATE"},
			  					{"MOTORCAR", 	 "MOTORCAR_COC", 	 "MOTORCAR_CERTIFICATE"},
			  					{"MARINE_CARGO", "MARINE_CARGO_COC", "OTHER_LINES_CERTIFICATE"},
			  					{"MARINE_HULL",  "MARINE_HULL_COC",  "OTHER_LINES_CERTIFICATE"},
			  					{"SURETYSHIP", 	 "SURETYSHIP_COC", 	 "BOND_CERTIFICATE"}};
	
	public String getCertReportName(String reportCode){
		String reportName = "";
		for (String[] s: certs){
			if (s[0].equals(reportCode)){
				reportName = s[1];
				System.out.println("reportName : "+s[1]);
			}
		}
		return reportName;
	}
	
	public String getCertTargetFilename(String reportCode){
		String targetFilename = "";
		for (String[] s: certs){
			if (s[0].equals(reportCode)){
				targetFilename = s[2];
			}
		}
		return targetFilename;
	}
}
