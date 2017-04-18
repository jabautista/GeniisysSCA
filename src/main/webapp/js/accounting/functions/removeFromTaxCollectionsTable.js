/**
 * function that will remove rows from the tax collections info based from
 * selected premium payment record
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function removeFromTaxCollectionsTable (taxRows) {
	$$("div#taxCollectionTable div[name='taxRow']").each(function (div)	{
		if (objACGlobal.gaccTranId+div.down("label",1).innerHTML+div.down("label", 2).innerHTML+div.down("label", 3).innerHTML+div.down("label", 0).innerHTML == taxRows) {

			div.remove();
		}
	});
}