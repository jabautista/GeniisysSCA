/**
 * Shows Assured lov
 * @author niknok
 * @date 10.17.2011
 */
function showClmAssuredLOV(lineCd, sublineCd, polIssCd, issueYy, renewNo, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmAssuredDtlLOV", 
						lineCd: lineCd,
						sublineCd: sublineCd,
						polIssCd: polIssCd,
						issueYy: issueYy,
						renewNo: renewNo,
						moduleId: moduleId,	
						page : 1},
		title: "",
		width: 405,
		height: 386,
		columnModel : [	{	id : "assdNo",
							title: "Id",
							align: "right",
							width: '70px'
						},
						{	id : "assuredName",
							title: "Name",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.assuredNo = row.assdNo;
				objCLM.basicInfo.assuredName = row.assuredName;
				$("txtAssuredName").value = unescapeHTML2(row.assuredName); 
				$("txtAssuredName").focus();
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtAssuredName").focus();
  			}
  		}
	  });
}