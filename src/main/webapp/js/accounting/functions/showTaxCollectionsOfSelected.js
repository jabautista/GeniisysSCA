/**
 * function that will show the tax collections for the selected premium payment
 * record
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function showTaxCollectionsOfSelected(taxCollectionTable, taxCollectionContainer, taxRows) {
	taxCollectionTable.show();
	taxCollectionContainer.show();
	
	$$("div[name='taxRow']").each(function (div)	{
		if (objACGlobal.gaccTranId+div.down("label",1).innerHTML+div.down("label", 2).innerHTML+div.down("label", 3).innerHTML+div.down("label", 0).innerHTML == taxRows) {
			div.show();
		}
	});
}