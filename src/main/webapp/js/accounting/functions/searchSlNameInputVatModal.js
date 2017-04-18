/**
 * Open modal search for SL Name in module GIACS039
 * 
 * @author Jerome Orio 09.22.2010
 * @version 1.0
 * @param page
 *            no. , keyword to search
 * @return
 */
function searchSlNameInputVatModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACInputVatController?action=getSlNameInputVatListing&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				parameters : {
					gsltSlTypeCd : $F("hidGsltSlTypeCdInputVat")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}