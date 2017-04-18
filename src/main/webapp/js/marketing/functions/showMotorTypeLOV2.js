function showMotorTypeLOV2(){
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getMotorTypeLOV",
				sublineCd: objGIPIQuote.sublineCd,
				page : 1			
			},
			title: "Car Company",
			width: 500,
			height: 386,
			columnModel : [
			               {	id : "motorTypeDesc",
							title: "Motor Type Description",
							width: '211px'
						},
						{	id : "sublineCd",
							title: "Subline Code",
							width: '80px'
						},
						{	id : "typeCd",
							title: "Motor Type",
							titleAlign: 'right',
							align: 'right',
							width: '70px'
						},
						{	id : "unladenWt",
							title: "Unladen Wt",
							width: '120px'
						}
			              ],
			draggable : true,
			onSelect : function(row){
				if(row != undefined){
					$("txtDspMotType").value = unescapeHTML2(row.motorTypeDesc);
					$("txtMotType").value 	= row.typeCd;
					$("txtUnladenWt").value 	= unescapeHTML2(row.unladenWt);
				}				
			}			
		});
	}catch(e){
		showErrorMessage("showCarCompanyLOV", e);
	}
}