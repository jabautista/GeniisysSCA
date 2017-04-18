/**
 * Shows province lov
 * 
 * @author niknok
 * @date 10.17.2011
 */
function showAllProvinceLOV(moduleId) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getProvinceDtlLOV",
			page : 1
		},
		title : "List of Province",
		width : 405,
		height : 386,
		columnModel : [ {
			id : "provinceCd",
			title : "Code",
			align : "right",
			width : '70px'
		}, {
			id : "provinceDesc",
			title : "Description",
			width : '320px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (moduleId == "GICLS010") {
				objCLM.basicInfo.provinceCode = row.provinceCd;
				objCLM.basicInfo.dspProvinceDesc = row.provinceDesc;
				$("txtProvince").value = row.provinceCd + " - "
						+ unescapeHTML2(row.provinceDesc);
				$("txtProvince").focus();
				changeTag = 1;
			}
		},
		onCancel : function() {
			if (moduleId == "GICLS010") {
				$("txtProvince").focus();
			}
		}
	});
}