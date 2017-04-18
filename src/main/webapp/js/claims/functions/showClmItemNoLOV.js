/**
 * Shows LOV for item no. 
 * @author Niknok Orio 
 * @date   09.13.2011
 */
function showClmItemNoLOV(){
	try{
		if (nvl(objCLMItem.selItemIndex,null) < 0){
			if (!checkItemLimit()) return false;
		}else{
			if (checkClmItemChanges(nvl(objCLMItem.selItemIndex,null) == null ? true :false)){
				if (!checkItemLimit()) return false;
			}else{
				return false;
			}
		}
		
		var notIn = itemGrid.createNotInParam("itemNo");
		var actionPerLine = "";
		if(objCLMGlobal.menuLineCd == "FI" || objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI){ 
			actionPerLine = "getClmFireItemLOV";
		}else if(objCLMGlobal.menuLineCd == "MC" || objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC){
			actionPerLine = "getClmMotorCarItemLOV";
		}else if(objCLMGlobal.menuLineCd == "EN" || objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN) {
			actionPerLine = "getClmEngineeringItemLOV";
		}else if(objCLMGlobal.menuLineCd == "MN" || objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN){ //change by steven 11/14/2012
			actionPerLine = "getClmMarineCargoItemLOV";
		}else if(objCLMGlobal.menuLineCd == "CA" || objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA || objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI){//added by steven 10/30/2012
			actionPerLine = "getClmCaItemLOV";
		}else if(objCLMGlobal.menuLineCd == "AV" || objCLMGlobal.lineCd == "AV" || objCLMGlobal.lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV){
			actionPerLine = "getClmAviationItemLOV";
		}else if(objCLMGlobal.menuLineCd == "PA" || objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH" || objCLMGlobal.menuLineCd == "AC"){ 
			actionPerLine = "getClmAccidentItemLOV";
		}else if(objCLMGlobal.menuLineCd == "MH" || objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){
			actionPerLine = "getClmMHItemLOV";
		}
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getClmItemLOV",
							action2: 	actionPerLine,
							notIn : 	notIn,
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
							itemFrom:	itemGrid.pager.from,
							itemTo:		itemGrid.pager.to,
							itemSortColumn: nvl(itemGrid.request[itemGrid.sortColumnParameter],""),
							itemAscDescFlg: nvl(itemGrid.request[itemGrid.ascDescFlagParameter],"ASC"),
							issCd:      objCLMGlobal.issCd
							},
			title: "List of Item",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "itemNo",
								title: "Item No.",
								width: '70px',
								type: 'number'
							},
							{	id : "itemTitle",
								title: "Item Title",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.itemLovSw = true;
				$("txtItemNo").value = row.itemNo;
				$("txtItemTitle").value = unescapeHTML2(row.itemTitle);
				$("txtItemNo").focus(); 
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmItemNoLOV", e);
	}
}