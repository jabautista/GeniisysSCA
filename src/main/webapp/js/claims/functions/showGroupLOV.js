/**
 * @author rey
 * @date 04.20.2012
 */
function showGroupLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getGroupLOV",
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
							itemAscDescFlg: nvl(personnelGrid.request[personnelGrid.ascDescFlagParameter],"ASC")
							},
			title: "List of Group",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "groupNo",
								title: "Group No.",
								width: '70px',
								type: 'number',
								align: 'right',
								titleAlign: 'right',
								renderer: function (value){
									return lpad(value,2,0);
								}
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtGrpCd").value	= row.groupNo;
				validateGroupItemNo(); // irwin 9.20.2012
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showGroupLov",e);
	}
}