/**
 * Shows LOV for Payor Class 
 * @author Niknok Orio 
 * @date   03.22.2012
 */
function showPayorLOV(moduleId, notIn, payeeClassCd, grid, claimId, recoveryId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 		"getGiisPayeesLOV",
							claimId:		claimId,	
							recoveryId:		recoveryId,
							payeeClassCd: 	payeeClassCd,
							notIn : 		notIn,
							itemFrom:		grid.pager.from,
							itemTo:			(Number(grid.pager.from)+2),
							itemSortColumn: nvl(grid.request[grid.sortColumnParameter],""),
							itemAscDescFlg: nvl(grid.request[grid.ascDescFlagParameter],"ASC"),
							itemFilter:		nvl(grid.request['objFilter'],"{}"),
							page : 			1 
			},
			title: "List of Payor",
			width: 411,
			height: 386,
			columnModel:[	
			             	{	id : "payeeNo",
								title: "Payor Code",
								width: '70px',
								type: 'number'
							},
							{	id : "nbtPayeeName",
								title: "Payor Name",
								width: '318px'
							},
							{	id : "payeeClassCd",
								title: "",
								width: '0',
								visible: false
							},
							{	id : "mailAddr1",
								title: "",
								width: '0',
								visible: false
							},
							{	id : "mailAddr2",
								title: "",
								width: '0',
								visible: false
							},
							{	id : "mailAddr3",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtPayorCd").value = unescapeHTML2(row.payeeNo);
					$("txtDspPayorName").value = unescapeHTML2(row.nbtPayeeName);
					$("hidMailAddr1").value = unescapeHTML2(row.mailAddr1);
					$("hidMailAddr2").value = unescapeHTML2(row.mailAddr2);
					$("hidMailAddr3").value = unescapeHTML2(row.mailAddr3);
					$("txtPayorCd").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showPayorLOV",e);
	}
}