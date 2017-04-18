/*
 * Created by	: Bryan Joseph Abuluyan
 * Date			: December 28, 2010
 * Description 	: sets noOfCopies and printerName drop-down box propertirs depending on the destination value
 */
function checkPrintDestinationFields(){
	if ("SCREEN" == $("reportDestination").value || "" == $("reportDestination").value || "LOCAL PRINTER" == $("reportDestination").value || "file" == $("reportDestination").value || "screen" == $("reportDestination").value){ // condition added by: nica 05.16.2011
		$("printerName").removeClassName("required");
		$("noOfCopies").removeClassName("required");
		$("printerName").disable();
		$("noOfCopies").disable();
		$("printerName").selectedIndex = 0;
		$("noOfCopies").selectedIndex = 0;
		if ($("isPreview") != undefined){
			$("isPreview").value = 1;
		}
	} else {
		$("printerName").enable();
		$("noOfCopies").enable();
		$("printerName").addClassName("required");
		$("noOfCopies").addClassName("required");
		if ($("isPreview") != undefined){
			$("isPreview").value = 0;
		}
	}
}