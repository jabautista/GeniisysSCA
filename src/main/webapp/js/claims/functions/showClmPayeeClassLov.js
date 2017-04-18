/**
 * Shows Payee Class Lov
 * @param moduleId
 * @param lineCd - To allow different value assignments upon selecting a row.
 * @author Irwin Tabisora. 11.13...
 * */

function showClmPayeeClassLov(moduleId, lineCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGIISPayeeClassLOV2",
							moduleId :  moduleId,
							page : 1},
			title: "Class Description",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "classDesc",
								title: "Class Description",
								width: '373px'
							},
							{
								id : "payeeClassCd",
								title: "",
								width: '0px',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				if(lineCd == "MC"){
					$("payeeClassCd").value = row.payeeClassCd;
					$("payeeClass").value = row.classDesc;
					$("payeeNo").value = "";
					$("payee").value = "";
					$("payeeAddress").value = "";
				}
			}
		});		
		
	}catch(e){
		showErrorMessage("showClmPayeeClassLov",e);
	}
}