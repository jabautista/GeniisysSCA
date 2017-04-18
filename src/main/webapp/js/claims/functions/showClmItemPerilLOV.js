/**
 * Shows LOV for item - peril.
 * @author Niknok Orio 
 * @date   09.14.2011
 */
function showClmItemPerilLOV(){
	try{
		
		var notIn = "";
		var action = "";

		if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC  || objCLMGlobal.menuLineCd == "AC"){
			action = 'getPAClmItemPerilList';
			var groupedItemNo = nvl($F("txtGrpItemNo"), 0); 
		}else if(objCLMGlobal.lineCd == objLineCds.MC){
			action = 'getMcClmItemPerilList';
		}else {
			action = 'getClmItemPerilList';	
		}
	
		if (nvl(perilGrid,null) instanceof MyTableGrid) notIn = perilGrid.createNotInParam("perilCd");
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	action,
							notIn : 	notIn,
							page : 		1,
							claimId:	objCLMGlobal.claimId,
							lineCd: 	objCLMGlobal.lineCd,
							sublineCd: 	objCLMGlobal.sublineCd,
							polIssCd: 	objCLMGlobal.policyIssueCode,
							issueYy: 	objCLMGlobal.issueYy,
							polSeqNo: 	objCLMGlobal.policySequenceNo,
							renewNo: 	objCLMGlobal.renewNo,
							polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
							expiryDate: objCLMGlobal.strExpiryDate2,
							lossDate: 	objCLMGlobal.strLossDate2,
							itemNo:		$F("txtItemNo"),
							groupedItemNo: nvl(groupedItemNo,""), 
							perilCd:	nvl(objCLMGlobal.perilCd,""),
							lossCatCd:	nvl(objCLMGlobal.lossCatCd,""),
							lossCatDes: objCLMGlobal.lossCatDes,
							catPerilCd: nvl(objCLMGlobal.perilCd,"")
			},
			title: "List of Peril",
			width: 650, //405
			height: 403, //386,
			hideColumnChildTitle: true,
			columnModel:[
			             {
							   	id: 'claimId',
							   	width: '0',
							   	visible: false,
							   	defaultValue: objCLMGlobal.claimId
							},
							{
							   	id: 'itemNo',
							   	width: '0',
							   	visible: false 
							},
						 	{
								id: 'userId',
							  	width: '0',
							  	visible: false 
						 	},
						 	{
								id: 'lastUpdate',
							  	width: '0',
							  	visible: false 
						 	},
							{
							   	id: 'cpiRecNo',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'cpiBranchCd',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'motshopTag',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'lineCd',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'closeDate',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'closeFlag',
							   	width: '0',
							   	defaultValue: 'AP',
							   	visible: false 
							},
							{
							   	id: 'closeFlag2',
							   	width: '0',
							   	defaultValue: 'AP',
							   	visible: false 
							},
							{
							   	id: 'closeDate2',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'groupedItemNo',
							   	width: '0',
							   //	defaultValue: '0', 
							   	visible: false 
							},
							{
							   	id: 'allowTsiAmt',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'allowNoOfDays',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'nbtCloseFlag',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'nbtCloseFlag2',
							   	width: '0',
							   	visible: false 
							},
							{
							   	id: 'tlossFl',
							   	width: '0',
							   	visible: false 
							}, 
					        {
					            id: 'histIndicator',
					            title: '&#160;&#160;R',
					            altTitle: 'With Reserve',
					            width: '0',
					            maxlength: 1,
					            sortable:	false,
					            defaultValue: false,	
					            otherValue: false,
					            editor: new MyTableGrid.CellCheckbox({
						            getValueOf: function(value){
					            		if (value){
											return "U";
					            		}else{
											return "D";	
					            		}	
					            	}
					            }),
					            visible: false // bat to naka false tapos may width?? i-0 ko ung width -  irwin
					        },
						   	{
								id: 'perilCd dspPerilName',
								title: 'Peril',
								width : 250,
								children : [
						            {
						                id : 'perilCd',
						                width : 50,
						                editable: false 		
						            },
						            {
						                id : 'dspPerilName', 
						                width : 200,
						                editable: false
						            }
								]
							},
							{
							   	id: 'annTsiAmt',
							   	title: 'TSI Amount',
							   	type : 'number',
							  	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC" ? '150' : '0',
							  	geniisysClass : 'money',
							  	editable: false,
							  	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC" ? true : false   
							}, 
							{
							   	id: 'aggregateSw',
							   	title: 'Aggregate',
							   	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '80' : '0',
							   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false
							},
							//{
							//   	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC ? '80' :'0',
							//   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC ? true :false
							//},//objCLMGlobal.lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI ? false :true- changed, because columns Aggregate, No. of Days and Base Amount are only shown for accident 
							{//  irwin - april 19, 2012 
							   	id: 'noOfDays',
								title: 'No. of Days',
							   	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '85' : '0',
							    visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false	
							   			
							  // 	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC ? '85' :'0',
							  // 	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC ? true :false
							},
							/*{ -- removed, based on rsic-test-cpi sr# 10752 - 9.18.2012
							   	id: 'baseAmt',
							   	title: 'Base Amount',
							   	type : 'number',
							   	width: objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == "MC" ? '150' :'0',
							  	geniisysClass : 'money',
							  	visible: objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == "MC" ? true : false,
							  	//visible: objCLMGlobal.lineCd == objLineCds.AC ? true : false
							},*/
						   	{
								id: 'lossCatCd dspLossCatDes',
								title: 'Loss Category',
								width : '250',
								children : [
						            {
						                id : 'lossCatCd',
						                width : 50,
						                editable: false 		
						            },
						            {
						                id : 'dspLossCatDes', 
						                width : 200,
						                editable: false
						            }
								]
							},
							{
							   	id: 'annTsiAmt',
							   	title: objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == "MC" ? "Refund" : 'Tsi Amount',
							   //	title: 'TSI Amount', // modified. irwin - april 19, 2012
							   	type : 'number',
							  	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC" ? '0' : '150',
							  	geniisysClass : 'money',
							  	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC" ? false : true
							} 
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.newPeril = row || [];
				objCLMItem.perilCd = row.perilCd;
				if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC'){
					objCLMItem.newPeril.noOfDays = row.noOfDays;
					objCLMItem.newPeril.annTsiAmt = row.annTsiAmt;
					objCLMItem.newPeril.aggregateSw = row.aggregateSw;
					objCLMItem.newPeril.dspPerilName = row.dspPerilName;
					objCLMItem.newPeril.dspLossCatDes = row.dspLossCatDes;
					checkAggregatePeril();
				}else{
					$("txtDspPerilName").value = unescapeHTML2(row.dspPerilName);
					$("txtDspLossCatDes").value = unescapeHTML2(row.dspLossCatDes);
					$("txtAnnTsiAmt").value = nvl(row.annTsiAmt,"") == "" ? "" :formatCurrency(row.annTsiAmt);
					$("txtDspPerilName").focus();
					
					if (objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA){
						if(nvl($F("txtGrpCd"),"") != ""){
							objCLMItem.newPeril.groupedItemNo = $F("txtGrpCd");
						}
					}

				}
				changeTag = 1;

			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmItemPerilLOV",e);
	}
}