/**
 * Shows City lov
 * @author niknok
 * @date 10.17.2011
 */
function showCityDtlLOV(provinceCd, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getCityDtlLOV", 
						provinceCd: provinceCd,
						moduleId: moduleId,	
						page : 1},
		title: "",
		width: 413,
		height: 386,
		columnModel : [	{	id : "cityCd",
							title: "City Code",
							align: "right",
							width: '70px'
						},
						{	id : "city",
							title: "City",
							width: '320px'
						},
						{	id : "provinceCd",
							title: "",
							width: '0px',
							visible: false
						},
						{	id : "provinceDesc",
							title: "",
							width: '0px',
							visible: false
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.cityCode = row.cityCd; 
				objCLM.basicInfo.dspCityDesc = row.city;
				$("txtCity").value = row.cityCd +" - "+ unescapeHTML2(row.city);
				$("txtCity").focus();
				
				if (nvl(objCLM.basicInfo.provinceCode,"") == "" || $F("txtProvince") == ""){
					objCLM.basicInfo.provinceCode = row.provinceCd; 
					objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;
					$("txtProvince").value = unescapeHTML2(row.provinceDesc); 
				} 
				changeTag = 1;
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtCity").focus();
  			}
  		}
	  });
}