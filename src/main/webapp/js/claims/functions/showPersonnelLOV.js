/**
 * @author rey
 * @date 02-25-2012
 */
function showPersonnelLOV(){
	try{
		var notIn = createCompletedNotInParam(personnelGrid,"personnelNo");
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getClmPersonnelLOV",
							page : 		1,				
							lineCd: 	objCLMGlobal.lineCd,
							sublineCd: 	objCLMGlobal.sublineCd,
							polIssCd: 	objCLMGlobal.policyIssueCode,
							issueYy: 	objCLMGlobal.issueYy,
							polSeqNo: 	objCLMGlobal.policySequenceNo,
							renewNo: 	objCLMGlobal.renewNo,
							polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
							expiryDate: objCLMGlobal.strExpiryDate2,
							lossDate: 	objCLMGlobal.strLossDate2,
							claimId:	objCLMGlobal.claimId,
							itemNo:		$F("txtItemNo"),
							itemFrom:	personnelGrid.pager.from,
							moduleId: 	"GICLS016",
							personnelNo: nvl($F("txtPerNo"),""),
							itemTo:		personnelGrid.pager.to,
							itemSortColumn: nvl(personnelGrid.request[personnelGrid.sortColumnParameter],""),
							itemAscDescFlg: nvl(personnelGrid.request[personnelGrid.ascDescFlagParameter],"ASC"),
							notIn : notIn
							},
			title: "List of Personnel",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "personnelNo",
								title: "Personnel No.",
								width: '70px',
								type: 'number',
								align: 'right',
								titleAlign: 'right',
								renderer: function (value){
									return lpad(value,2,0);
								}
							},
							{	id : "name",
								title: "Name",
								width: '320px'
							},
							{
								id : "capacityCd",
								width: '0',
								visible: false
							},
							{
								id : "amountCovered",
								width: '0',
								visible: false,
								renderer: function(value) {
									return formatCurrency(value);
								}
							},
							{
								id : "position",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.itemLovSw = true;
				$("txtPerNo").value = row.personnelNo;
				$("txtPersonnel").value = unescapeHTML2(row.name);
				$("txtCaPosition").value =row.capacityCd ==  null ? "" : row.capacityCd +" - "+ unescapeHTML2(row.position);
				$("txtPosNo").value = row.capacityCd;
				$("txtPosDes").value = unescapeHTML2(row.position);
				$("txtCoverage").value	= formatCurrency(row.amountCovered);
				$("txtPerNo").focus();
				/*$("btnAddPer").removeClassName("disabledButton");
				$("btnAddPer").disabled = false;*/
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showPersonnelLOV",e);
	}
}