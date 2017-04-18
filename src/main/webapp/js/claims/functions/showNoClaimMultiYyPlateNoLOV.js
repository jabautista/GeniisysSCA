/**
 * @author rey
 * @date 21-12-2011
 * @param assdNo
 */
function showNoClaimMultiYyPlateNoLOV(assdNo){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action: 	"getNoClmMultiYyPlateNoLOV",
							assdNo: 	assdNo
			},
		title: /*"List of Plate No."*/ "Vehicle",	//changed to match LOV title in CS : shan 10.14.2013
		width: 405,
		height: 386,
		columnModel:[
		             {
		            	 id: "plateNo",
		            	 title: "Plate No.",
		            	 width: "100px",
		            	 type: "number"
		             },
		             {
		            	 id: "serialNo",
		            	 title: "Serial No.",
		            	 width: "100px"
		             },
		             {
		            	 id: "motorNo",
		            	 title: "Motor No.",
		            	 width: "100px"
		             }
		             ],
		        draggable: true,
		        onSelect : function(row){
		        	clearNoClmMultiYyDetails2();
		        	objCLMItem.itemLovSw = true;
		        	$("txtPlateNo").value = unescapeHTML2(row.plateNo);
		        	$("txtSerialNo").value = row.serialNo == null || row.serialNo == "" ? "" : unescapeHTML2(row.serialNo).substr(0,20); //added by steven 04.06.2013; ung maxlenght kasi ng column na yan sa table is 20 at ginaya ko ung ginawang paghandle na yan sa CS. // lara 10-10-13 added validation
		        	$("txtMotorNo").value = unescapeHTML2(nvl(row.motorNo,"")); //lara - 11/05/2013
		        	$("txtPlateNo").focus();
		        	changeTag = 1; //trigger saving if any records in Plate Number LOV is selected by MAC 11/20/2013.
		        },
		        prePager: function(){
					//tbgLOV.request.notIn = notIn;
		        }
		});
	}
	catch(e){
		showErrorMessage("showNoClaimMultiYyPlateNoLOV",e);
	}
}