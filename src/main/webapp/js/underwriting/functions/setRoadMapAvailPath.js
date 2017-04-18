/**
 * Checks and set the available path for the road map of PAR.
 * @author Veronica V. Raymundo
 * @param context - the id of the canvas
 * 
 */

function setRoadMapAvailPath(context){
	
	/*PAR listing to basic Info*/
	if(nvl(objRoadMapAvail.parlist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.basicInfo, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 20,  lineWidth, 20, BLACK_COLOR);
	}
	
	/*Basic Info. to Package Policy Item*/
	if(nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.itemInfo, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 40,  lineWidth, 80, BLACK_COLOR);
	}
	
	/*Basic Info to Print*/
	if(nvl(objRoadMapAvail.basicInfo, "INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 4, 45, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 4, 45,  lineWidth, 58, BLACK_COLOR);
		makeRectangleLine(context, 4, 103,  lineWidth, 58, BLACK_COLOR);
		makeRectangleLine(context, 4, 160,  lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 4, 185,  lineWidth, 130, BLACK_COLOR);
		makeRectangleLine(context, 4, 315,  lineWidth, 30, BLACK_COLOR);
		makeRectangleLine(context, 4, 345, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Basic Info to Warr and Clause*/
	if(nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.warrClause,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 4, 45, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 4, 45,  lineWidth, 58, BLACK_COLOR);
		makeRectangleLine(context, 4, 100, 95, lineWidth, BLACK_COLOR);
	}
	
	/*Basic Info to Bill Premium*/
	if(nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 4, 180, 75, lineWidth, BLACK_COLOR);
		
	}
	
	/*Item Info to Peril*/
	if(nvl(objRoadMapAvail.itemInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.peril,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 140,  lineWidth, 10, BLACK_COLOR);
	}
	
	/*Basic Info to Peril (for open policy)*/
	if(nvl(objRoadMapAvail.itemInfo,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.peril,"INACCESSIBLE") != "INACCESSIBLE" &&
	   nvl(objRoadMapAvail.basicInfo,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 4, 160, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Warr and Clause to Bill Premium*/
	if(nvl(objRoadMapAvail.warrClause,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 170,  lineWidth, 10, BLACK_COLOR);
		makeRectangleLine(context, 4, 315, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Bill Premium to Co-insurance*/
	if(nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 180,  lineWidth, 70, BLACK_COLOR);
	}
	
	/*Co-insurance to Prelim Dist*/
	if(nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 265,  lineWidth, 40, BLACK_COLOR);
	}
	
	/*Prelim Dist to Print*/
	if(nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 325,  lineWidth, 10, BLACK_COLOR);
	}
	
	/*Print to Post*/
	if(nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE" && 
	   nvl(objRoadMapAvail.print, "INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 355,  lineWidth, 10, BLACK_COLOR);
	}
	
	/*Post to Distribution*/
	if(nvl(objRoadMapAvail.post,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.dist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 385,  lineWidth, 10, BLACK_COLOR);
	}
	
	/* Basic Information */
	
	/* Bill Information */
	
	/*To Discount Surcharge*/
	if(nvl(objRoadMapAvail.discSur,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 79, 140, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 140, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 79, 165, lineWidth, 18, BLACK_COLOR);
		
	}
	
	/*To Group Items Per Bill*/
	if(nvl(objRoadMapAvail.grpItem,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 79, 165, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 165, lineWidth, 18, BLACK_COLOR);		
	}
	
	/*To Bill Premium*/
	if(nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 79, 190, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 183, lineWidth, 10, BLACK_COLOR);
	}
	
	/*To Invoice Commission*/
	if(nvl(objRoadMapAvail.invComm,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.billPrem,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 79, 215, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 190, lineWidth, 25, BLACK_COLOR);
	}
	
	/*Co-insurance*/
	
	/*To Co-insurer*/
	if(nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.coInsurer,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 79, 245, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 45, 255, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 245, lineWidth, 13, BLACK_COLOR);
	}
	
	/*To Lead Policy*/
	if(nvl(objRoadMapAvail.coInsurance,"INACCESSIBLE") != "INACCESSIBLE" && 
       nvl(objRoadMapAvail.leadPol,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 45, 255, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 270, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 255, lineWidth, 15, BLACK_COLOR);
	}
	
	/*Preliminary Distribution*/
	if(nvl(objRoadMapAvail.prelimDist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 45, 315, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 300, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Group Setup*/
	if(nvl(objRoadMapAvail.setupGrp,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 45, 315, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 300, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Peril Distribution*/
	if(nvl(objRoadMapAvail.perilDist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 45, 315, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 300, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 79, 325, 20, lineWidth, BLACK_COLOR);
	}
	
	/*One Risk Distribution*/
	if(nvl(objRoadMapAvail.oneRiskDist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 45, 315, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 325, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 79, 350, 20, lineWidth, BLACK_COLOR);
	}
	
	/*Distribution*/
	if(nvl(objRoadMapAvail.dist,"INACCESSIBLE") != "INACCESSIBLE"){
		makeRectangleLine(context, 33, 385,  lineWidth, 10, BLACK_COLOR);
		makeRectangleLine(context, 79, 395, lineWidth, 25, BLACK_COLOR);
		makeRectangleLine(context, 45, 405, 35, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 395, 20, lineWidth, BLACK_COLOR);
		makeRectangleLine(context, 79, 420, 20, lineWidth, BLACK_COLOR);
	}

}