/**
 * Open modal search for Payee in module GIACS039
 * 
 * @author Jerome Orio 09.22.2010
 * @version 1.0
 * @param page
 *            no. , keyword to search
 * @return
 */
function searchPayeeInputVatModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACInputVatController?action=getPayeeInputVatListing&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				parameters : {
					payeeClassCd : $F("selPayeeClassCdInputVat")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}