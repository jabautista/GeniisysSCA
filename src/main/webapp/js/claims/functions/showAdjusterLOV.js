/**
 * Shows Adjuster lov
 * @author niknok
 * @date 10.28.2011
 */
function showAdjusterLOV(claimId, adjCompanyCd, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPayeesByAdjuster2LOV", 
						claimId: claimId, 
						adjCompanyCd: adjCompanyCd,
						page : 1},
		title: "List of Adjuster",
		width: 405,
		height: 386,
		columnModel : [	{	id : "id",
							title: "Code",
							align: 'right',
							width: '70px'
						},
						{	id : "desc",
							title: "Adjuster",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				$("txtPrivAdjCd").value = unescapeHTML2(row.id);
				$("txtAdjuster").value = unescapeHTML2(row.desc); 
				$("txtAdjuster").focus(); 
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtAdjuster").focus();
  			}
  		}
	  });
}