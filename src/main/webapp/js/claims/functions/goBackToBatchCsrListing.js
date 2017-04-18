/**
 * Return the page to the batch CSR listing 
 * @author Veronica V. Raymundo
 */
function goBackToBatchCsrListing(){
	Effect.Fade("batchCsrDiv", {
		duration: .001,
		afterFinish: function () {
			$("batchCsrListingMainDiv").show();
			batchCsrTableGrid.clear();
			batchCsrTableGrid.refresh();
		}
	});
	selectedIndex = -1;
}