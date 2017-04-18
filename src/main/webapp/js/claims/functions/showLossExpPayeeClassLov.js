/**
 * Payee Class Lov Used in GICLS030
 */
function showLossExpPayeeClassLov(page){
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
				if(page == "billInfo"){
					$("txtBillPayeeClassCd").value = unescapeHTML2(row.classDesc);
					$("txtBillPayeeClassCd").setAttribute("payeeClassCd", row.payeeClassCd);
					$("txtBillPayeeCd").value = "";
					$("txtBillPayeeCd").setAttribute("payeeCd", "");
				}else{
					$("payeeClass").focus();
					$("payee").value = "";
					onSelectPayeeClassCd(row);
					//changeTag = 1;
				}
			}
		});		
		
	}catch(e){
		showErrorMessage("showLossExpPayeeClassLov",e);
	}
}