/**
 * Shows Adjusting Companies lov
 * @author niknok
 * @date 10.28.2011
 */
function showAdjusterCoLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPayeesByAdjusterLOV", 
						page : 1},
		title: "List of Adjusting Companies",
		width: 405,
		height: 386,
		columnModel : [	{	id : "id",
							title: "Code",
							align: 'right',
							width: '70px'
						},
						{	id : "desc",
							title: "Payee Name",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				$("txtAdjCompanyCd").value = unescapeHTML2(row.id);
				$("txtAdjCompany").value = unescapeHTML2(row.desc); 
				$("txtPrivAdjCd").value = "";
				$("txtAdjuster").value = ""; 
				$("txtAdjCompany").focus(); 
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtAdjCompany").focus();
  			}
  		}
	  });
}