/**
 * Added Module Id - irwin 12.15.12
 * */
function showClmPayeeClassLov2(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGIISPayeeClassLOV2"},
			title: "Class Description",
			width: 390,
			height: 390,
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
				$("payeeClass").value 	= unescapeHTML2(row.payeeClassCd + " - " + row.classDesc);
				$("payeeClass").setAttribute("payeeClassCd", row.payeeClassCd);
				$("payeeClass").focus();
				$("payee").value = "";
				changeTag = 1;
				if(moduleId == "GIACS086"){
					adviceTGurl = "";
					adviceTGurl = "&payeeClassCd=" + row.payeeClassCd +"&condition=1";
					//adviceGrid.url +=  adviceTGurl;
					adviceGrid.url =  specialCSR.originalURL+adviceTGurl;
					adviceGrid._refreshList();
				}else if(moduleId == "GICLS030"){
					$("payeeClass").value 	= unescapeHTML2(row.classDesc);
				}
			}
		});		
		
	}catch(e){
		showErrorMessage("showClmPayeeClassLov2",e);
	}
}