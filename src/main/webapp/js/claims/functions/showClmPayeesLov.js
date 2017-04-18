/**
 * Shows Payees Class Lov
 * @param moduleId
 * @param lineCd - To allow different value assignments upon selecting a row.
 * @param payeeClassCd
 * @param itemNo
 * @author Irwin Tabisora. 11.13...
 * */
function showClmPayeesLov(moduleId,lineCd,payeeClassCd,itemNo){
	try{
		var notIn = "";
		if (nvl(mcTpDtlGrid,null) instanceof MyTableGrid) notIn = mcTpDtlGrid.createNotInParam("payeeNo");
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisPayeesLOVByClassCdItemNo",
							moduleId : moduleId,
							itemNo: itemNo,
							claimId: objCLMGlobal.claimId,
							payeeClassCd: payeeClassCd,
							notIn : 	notIn,
							page : 1},
			title: "Payee Names",
			width: 620,
			height: 400,
			columnModel : [
							{
								id : "payeeName",
								title: "Payee Name",
								width: '200px'
							},{
								id:"address",
								title: "Address",
								width: '250px'
							},{
								id:"payeeNo",
								title: "Attention",
								visible:false
							}
						],
			draggable: true,
			onSelect : function(row){
				if(lineCd == "MC"){
					$("payeeNo").value = row.payeeNo;
					$("payeeAddress").value = unescapeHTML2(row.address);
					$("payee").value = unescapeHTML2(row.payeeName);
					$("detDriverAddress").value = unescapeHTML2(row.address);	//added by Gzelle 09032014
				}
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmPayeesLov",e);
	}
}