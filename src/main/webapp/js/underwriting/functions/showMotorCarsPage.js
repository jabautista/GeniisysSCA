/**
 * Description - show the motorCars.jsp,contains
 * 				 a list of motor car policies
 * created by  - mosesBC
 */

function showMotorCarsPage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIVehicleController?action=showMotorCarsPage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Motor Cars page, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Motor Cars");
		}
	});

}