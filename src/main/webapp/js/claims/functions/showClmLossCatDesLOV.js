/**
 * Shows LOV for item - peril loss category. 
 * @author Niknok Orio 
 * @date   09.14.2011
 */
function showClmLossCatDesLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getLossCatDtl2",
							//notIn : 	notIn,
							page : 		1,
							lineCd: 	objCLMGlobal.lineCd,
							perilCd:	objCLMItem.perilCd
			},
			title: "List of Loss Category",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "lossCatCd",
								title: "Code",
								width: '70px',
								type: 'number'
							},
							{	id : "lossCatDesc",
								title: "Description",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.lossCatCd = row.lossCatCd;
				$("txtDspLossCatDes").value = unescapeHTML2(row.lossCatDesc);
				$("txtDspLossCatDes").focus();
				if (objCLMItem.newPeril != [] || objCLMItem.newPeril != null){
					objCLMItem.newPeril.lossCatCd = row.lossCatCd;
					objCLMItem.newPeril.dspLossCatDes = unescapeHTML2(row.lossCatDesc); //changed by robert to unescapeHTML2 10.01.2013
				}
				changeTag =1;
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmLossCatDesLOV",e);
	}
}