function deleteAllItemPerils(){
	for (var i=0; i<objGIPIWItemPeril.length; i++){
		objGIPIWItemPeril[i].recordStatus = -1; 
	}
	
	clearItemPerilFields();
	
	$$("div[name='row2']").each(function(row){
		$("perilCd").value = row.getAttribute("peril");
		Effect.Fade(row, {
			duration: .001,
			afterFinish: function (){
				row.remove();			
				checkPerilTableIfEmpty("row2", "itemPerilMotherDiv"+row.getAttribute("item"), "itemPerilMainDiv");
				checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+row.getAttribute("item"), "row2");		
				$("deleteTag").value = "N";
			}
		});
	});
	
	getTotalAmounts();
}