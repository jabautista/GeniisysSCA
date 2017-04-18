/**
 * Shows District lov
 * @author niknok
 * @date 10.17.2011
 */
function showDistrictDtlLOV(provinceCd, cityCd, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getDistrictDtlLOV", 
						provinceCd: provinceCd,
						cityCd: cityCd,
						moduleId: moduleId,	
						page : 1},
		title: "",
		width: 413,
		height: 386,
		columnModel : [	{	id : "districtNo",
							title: "District No.",
							width: '70px'
						},
						{	id : "districtDesc",
							title: "Description",
							width: '320px'
						},
						{	id : "cityDesc",
							title: "",
							width: '0px',
							visible: false
						},
						{	id : "cityCd",
							title: "",
							width: '0px',
							visible: false
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
				changeTag = 1;
				objCLM.basicInfo.districtNumber = row.districtNo;
				$("txtDistrictNo").value = unescapeHTML2(row.districtNo); 
				$("txtDistrictNo").focus();
				 
				if (nvl(objCLM.basicInfo.provinceCode,"") == "" || $F("txtProvince") == ""){
					objCLM.basicInfo.provinceCode = row.provinceCd; 
					objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;
					$("txtProvince").value = unescapeHTML2(row.provinceDesc); 
				} 
				if (nvl(objCLM.basicInfo.cityCode,"") == "" || $F("txtCity") == ""){
					objCLM.basicInfo.cityCode = row.cityCd; 
					objCLM.basicInfo.dspCityDesc = row.cityDesc;
					$("txtCity").value = unescapeHTML2(row.cityDesc);
				}
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtDistrictNo").focus();
  			}
  		}
	  });
}