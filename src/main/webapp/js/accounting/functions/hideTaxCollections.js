/**
 * Function that will hide all the tax collections info
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function hideTaxCollections(taxCollectionTable, taxCollectionContainer) {
	taxCollectionTable.hide();
	taxCollectionContainer.hide();
	$$("div[name='taxRow']").each(function (taxRowDiv)	{
			taxRowDiv.hide();
	});
}