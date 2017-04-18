/**
 * Checks and set the available path for the road map of Package PAR.
 * @author Veronica V. Raymundo
 * @param context - the id of the canvas
 * 
 */

function setPackRoadMapAvailPath(context){
	
	/*PAR listing to basic Info*/
	if(nvl(objRoadMapAvail.parlist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.basicInfo, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 30, lineWidth, 5, BLACK_COLOR);
	}
	
	/*Basic Info. to Package Policy Item*/
	if(nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.packPolItems, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 43, lineWidth, 85, BLACK_COLOR);
	}
	
	/*Basic Info to Print*/
	if(nvl(objRoadMapAvail.basicInfo, "INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 20, 43, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 20, 43, lineWidth, 207, BLACK_COLOR);
		makeRectangleLine(context, 20, 250, lineWidth, 30, BLACK_COLOR);
		makeRectangleLine(context, 20, 280, lineWidth, 60, BLACK_COLOR);
		makeRectangleLine(context, 20, 340, lineWidth, 30, BLACK_COLOR);
		makeRectangleLine(context, 20, 370, 15, lineWidth, BLACK_COLOR);
		
	}
	
	/*Basic Info to Warr and Clause*/
	if(nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.warrClause,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 20, 43, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 20, 43, lineWidth, 207, BLACK_COLOR);
		makeRectangleLine(context, 20, 250, 15, lineWidth, BLACK_COLOR);
		
	}
	
	/*Package Policy Items to Peril*/
	if(nvl(objRoadMapAvail.packPolItems,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.peril,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 145, lineWidth, 55, BLACK_COLOR);
	}
	
	/*Peril to Warr and Clause*/
	if(nvl(objRoadMapAvail.peril, "INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.warrClause, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 220, lineWidth, 20, BLACK_COLOR);
		makeRectangleLine(context, 23, 250, 15, lineWidth, GRAY_COLOR);
	}
	
	/*Warr and Clause to Bill Info*/
	if(nvl(objRoadMapAvail.warrClause,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.billInfo,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 260, lineWidth, 10, BLACK_COLOR);
		makeRectangleLine(context, 23, 250, 15, lineWidth, GRAY_COLOR);
		makeRectangleLine(context, 20, 43, 15, lineWidth,  GRAY_COLOR);
		makeRectangleLine(context, 20, 43, lineWidth, 207, GRAY_COLOR);
		makeRectangleLine(context, 20, 250, lineWidth, 30, GRAY_COLOR);
		makeRectangleLine(context, 20, 280, lineWidth, 60, GRAY_COLOR);
		makeRectangleLine(context, 20, 340, lineWidth, 30, GRAY_COLOR);
		makeRectangleLine(context, 20, 370, 15, lineWidth, GRAY_COLOR);
	}
	
	/*Bill Info to Preliminary Dist*/
	if(nvl(objRoadMapAvail.billInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.coInsurance, "INACCESSIBLE") == "INACCESSIBLE"){
		makeRectangleLine(context, 20, 280, lineWidth, 60, BLACK_COLOR);
		makeRectangleLine(context, 20, 280, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 20, 340, 15, lineWidth, BLACK_COLOR);
	}
	
	/*Bill Info to Print*/
	if(nvl(objRoadMapAvail.billInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") == "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 20, 370, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 20, 280, lineWidth, 60, BLACK_COLOR);
		makeRectangleLine(context, 20, 340, lineWidth, 30, BLACK_COLOR);
		makeRectangleLine(context, 20, 280, 15, lineWidth, BLACK_COLOR);
	}
	
	/*Bill Info to Co-Insurance*/
	if(nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.billInfo, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 290, lineWidth, 10, BLACK_COLOR);
	}
	
	/*Co-insurance to Prelim Dist*/
	if(nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.prelimDist, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 320, lineWidth, 10, BLACK_COLOR);
		makeRectangleLine(context, 20, 280, lineWidth, 60, GRAY_COLOR);
		makeRectangleLine(context, 20, 280, 15, lineWidth, GRAY_COLOR);
		makeRectangleLine(context, 20, 340, 15, lineWidth, GRAY_COLOR);
		makeRectangleLine(context, 20, 250, 15, lineWidth, GRAY_COLOR);
		makeRectangleLine(context, 20, 43, 15, lineWidth, GRAY_COLOR);
		makeRectangleLine(context, 20, 43, lineWidth, 207, GRAY_COLOR);
		makeRectangleLine(context, 20, 250, lineWidth, 30, GRAY_COLOR);
		makeRectangleLine(context, 20, 340, lineWidth, 30, GRAY_COLOR);
		makeRectangleLine(context, 20, 370, 15, lineWidth, GRAY_COLOR);
	}
	
	/*Prelim Dist to Print*/
	if(nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 350, lineWidth, 10, BLACK_COLOR);
	}
	
	/*Print to Post*/
	if(nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 380, lineWidth, 10, BLACK_COLOR);
	}
	
	/*Post to Distribution*/
	if(nvl(objRoadMapAvail.post,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.dist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 43, 410, lineWidth, 10, BLACK_COLOR);
	}
	
	/*To Bond Basic Info*/
	if(nvl(objRoadMapAvail.bondBasicInfo, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 20, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 20, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Eng Info*/
	if(nvl(objRoadMapAvail.engInfo,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, 15, lineWidth, BLACK_COLOR);
		
	}
	
	/*To Line Subline Coverages*/
	if(nvl(objRoadMapAvail.lineSubCov,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
	}
	
	/*To Cargo Limits of Liability*/
	if(nvl(objRoadMapAvail.cargoLiab,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Carrier Info*/
	if(nvl(objRoadMapAvail.cargoLiab,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, 15,lineWidth, BLACK_COLOR);
	}
	
	/*To Bank Collection*/
	if(nvl(objRoadMapAvail.bankColl,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 145, 15,lineWidth, BLACK_COLOR);
	}
	
	/*To Required Docs*/
	if(nvl(objRoadMapAvail.reqDocs,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 145, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 170, 15,lineWidth, BLACK_COLOR);
	}
	
	/*To Initial Acceptance*/
	if(nvl(objRoadMapAvail.initAcc, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 145, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 170, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 195, 15,lineWidth, BLACK_COLOR);
	}
	
	/*To Collateral Transaction*/
	if(nvl(objRoadMapAvail.collTrans,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 145, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 170, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 195, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 220, 15,lineWidth, BLACK_COLOR);
	}
	
	/*To Limits of Liabilities*/
	if(nvl(objRoadMapAvail.limLiab,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 43, 125, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 43, lineWidth, 27, BLACK_COLOR);
		makeRectangleLine(context, 160, 70, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 95, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 120, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 145, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 170, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 195, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 220, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 245, 15,lineWidth, BLACK_COLOR);
	}
	
	/*Package policy Items*/
	
	/*To Marine Cargo Item Information*/
	if(nvl(objRoadMapAvail.itemMN,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Engineering Item Information*/
	if(nvl(objRoadMapAvail.itemEN,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 110, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 110, lineWidth, 25, BLACK_COLOR);
		
	}
	
	/*To Fire Item Information*/
	if(nvl(objRoadMapAvail.itemFI, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 85, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 85, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 110, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Motor Car Item Information*/
	if(nvl(objRoadMapAvail.itemMC, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 60, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 60, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 85, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 110, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Marine Hull Item Information*/
	if(nvl(objRoadMapAvail.itemMH, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 160, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Casualty Item Information*/
	if(nvl(objRoadMapAvail.itemCA, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 185, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 160, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Aviation Item Information*/
	if(nvl(objRoadMapAvail.itemAV, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 210, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 160, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 185, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Accident Item Information*/
	if(nvl(objRoadMapAvail.itemAC, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 235, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 160, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 185, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 210, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Others Item Information*/
	if(nvl(objRoadMapAvail.itemOthers, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 50, 135, 43, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 260, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 135, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 160, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 185, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 210, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 235, lineWidth, 25, BLACK_COLOR);
	}
	/* Bill Information */
	
	/*To Discount Surcharge*/
	if(nvl(objRoadMapAvail.discSur, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 280, 128, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 280, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Group Items Per Bill*/
	if(nvl(objRoadMapAvail.grpItem, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 280, 128, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 280, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 305, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Bill Premium*/
	if(nvl(objRoadMapAvail.billPrem, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 280, 128, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 280, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 305, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 330, 15, lineWidth, BLACK_COLOR);
	}
	
	/*To Invoice Commission*/
	if(nvl(objRoadMapAvail.invComm, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 280, 128, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 280, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 305, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 330, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 160, 355, 15, lineWidth, BLACK_COLOR);
	}
	
	/*Co-Insurance*/
	if(nvl(objRoadMapAvail.coInsurance, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 312, 55, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 300, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 300, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 325, 15, lineWidth, BLACK_COLOR);
	}
	
	/*Peril Distribution*/
	
	/*To Group Set-up*/
	if(nvl(objRoadMapAvail.setupGrp, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 340, 55, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 360, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 340, lineWidth, 20, BLACK_COLOR);
	}
	
	/*To Peril and Distribution*/
	if(nvl(objRoadMapAvail.perilDist, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 340, 55, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 385, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 340, lineWidth, 20, BLACK_COLOR);
		makeRectangleLine(context, 90, 360, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To One Risk Distribution*/
	if(nvl(objRoadMapAvail.oneRiskDist, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 340, 55, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 410, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 90, 340, lineWidth, 20, BLACK_COLOR);
		makeRectangleLine(context, 90, 360, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 90, 385, lineWidth, 25, BLACK_COLOR);
	}
	
	/*To Distribution*/
	if(nvl(objRoadMapAvail.dist, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 35, 430, 130, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 430, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 405, 15, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 160, 405, lineWidth, 25, BLACK_COLOR);
	}
	
}