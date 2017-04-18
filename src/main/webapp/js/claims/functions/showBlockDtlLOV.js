/**
 * Shows Block lov
 * @author niknok
 * @date 10.17.2011
 */
function showBlockDtlLOV(provinceCd, cityCd, districtNo, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getBlockDtlLOV", 
						provinceCd: provinceCd,
						cityCd: cityCd,
						districtNo: districtNo,
						moduleId: moduleId,	
						page : 1},
		title: "",
		width: 489,
		height: 386,
		columnModel : [	{
							id : "blockId",
							title: "Block Id",
							align: "right",
							width: '70px'
						},
						{
							id : "blockNo",
							title: "Block Number",
							width: '70px'
						},
						{
							id : "blockDesc",
							title: "Description",
							width: '320px'
						},
		               	{	id : "districtNo",
							title: "",
							width: '0px',
							visible: false
						},
						{	id : "districtDesc",
							title: "",
							width: '0px',
							visible: false
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
				objCLM.basicInfo.blockId = row.blockId;
				objCLM.basicInfo.blockNo = row.blockNo;
				$("txtBlockNo").value = unescapeHTML2(row.blockNo); 
				$("txtBlockNo").focus();
				 
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
				
				if (nvl(objCLM.basicInfo.districtNumber,"") == "" || $F("txtDistrictNo") == ""){
					objCLM.basicInfo.districtNumber = row.districtNo;
					$("txtDistrictNo").value = unescapeHTML2(row.districtNo); 
				}
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtBlockNo").focus();
  			}
  		}
	  });
}