function getSpoilCdGiuts003LOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getSpoilCdGiuts003LOV"
			},
			title : "Reason for Spoilage",
			width : 380,
			height : 386,
			autoSelectOneRecord: false,//changed from true reymon 04302013
			columnModel : [ {
				id : "spoilCd",
				title : "Spoil Cd",
				width : '110px',
			}, 
			{
				id : "spoilDesc",
				title : "Spoil Desc",
				width : '255px'
			},
			],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("spoilCd").value = unescapeHTML2(row.spoilCd);	// added unescapeHTML2 : shan 07.11.2014
					$("spoilDesc").value = unescapeHTML2(row.spoilDesc);	// added unescapeHTML2 : shan 07.11.2014
				}
			}
		});
	} catch (e) {
		showErrorMessage("getSpoilCdGiuts003LOV", e);
	}
}