//belle 12.05.2011
function showClmGrpItemNoLOV(){
	try{	
		var notIn = itemGrid.createNotInParam("groupedItemNo");
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getClmAccidentGrpItemLOV",
							notIn : 	notIn,
							page : 		1,
							lineCd: 	objCLMGlobal.lineCd,
							sublineCd: 	objCLMGlobal.sublineCd,
							polIssCd: 	objCLMGlobal.policyIssueCode,
							issueYy: 	objCLMGlobal.issueYy,
							polSeqNo: 	objCLMGlobal.policySequenceNo,
							renewNo: 	objCLMGlobal.renewNo,
							polEffDate: dateFormat(objCLMGlobal.strPolEffDate, "mm-dd-yyyy"), //belle 05.15.2012 strPolEffDate
							expiryDate: dateFormat(objCLMGlobal.strExpiryDate, "mm-dd-yyyy"),
							lossDate: 	dateFormat(objCLMGlobal.strLossDate, "mm-dd-yyyy"),
							claimId:	objCLMGlobal.claimId,
							itemNo:		$F("txtItemNo"),
							itemFrom:	itemGrid.pager.from,
							itemTo:		itemGrid.pager.to,
							itemSortColumn: nvl(itemGrid.request[itemGrid.sortColumnParameter],""),
							itemAscDescFlg: nvl(itemGrid.request[itemGrid.ascDescFlagParameter],"ASC")
							},
			title: "List of Grouped Item",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "groupedItemNo",
								title: "Grouped Item No.",
								width: '70px',
								type: 'number'
							},
							{	id : "groupedItemTitle",
								title: "Grouped Item Title",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.grpItemLovSw = true;
				$("txtGrpItemNo").value = row.groupedItemNo;
				$("txtGrpItemTitle").value = unescapeHTML2(row.groupedItemTitle);
				$("txtGrpItemNo").focus();
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmGrpItemNoLOV", e);
	}
}