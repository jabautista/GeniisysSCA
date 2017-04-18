/**
 * @author rey
 * @date 21-12-2011
 */
function showNoClaimMultiYyLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action: 	"getAssdNoLOV",
							page : 1,
							moduleId: "GICLS062"
			},
		title: "List of Assured",
		width: 405,
		height: 386,
		columnModel:[
		             {
		            	 id: "assdNo",
		            	 title: "Assured No.",
		            	 width: "70px",
		            	 type: "number"
		             },
		             {
		            	 id: "assdName",
		            	 title: "Assured Name",
		            	 width: "320px"
		             }
		             ],
		        draggable: true,
		        onSelect : function(row){
		        	clearNoClmMultiYyDetails();
		        	objCLMItem.itemLovSw = true;
		        	$("txtAssdNo").value = row.assdNo;
		        	$("txtAssdName").value = unescapeHTML2(row.assdName);
		        	$("txtAssdNo").focus();
		        	changeTag = 1;	//added by shan 10.16.2013
		        	changeTagFunc = function(){		//added by shan 10.16.2013
		        		fireEvent($("noClaimMultiSave"), "click");
		        	};
		        },
		        prePager: function(){
					//tbgLOV.request.notIn = notIn;
		        }
		});
	}
	catch(e){
		showErrorMessage("showNoClaimMultiYyLOV",e);
	}
}