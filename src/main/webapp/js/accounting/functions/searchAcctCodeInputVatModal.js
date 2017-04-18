/**
 * Open modal search for Account Code in module GIACS039
 * 
 * @author Jerome Orio 09.22.2010
 * @version 1.0
 * @param page
 *            no., keyword to search
 * @return
 */
function searchAcctCodeInputVatModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACInputVatController?action=getAcctCodeInputVatListing&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}