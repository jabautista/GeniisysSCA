/**
 * Call ajax result modal page for Policy No. in module GIACS026
 * 
 * @author emman 02.08.2011
 * @version 1.0
 * @param modalPageNo -
 *            page no. of record
 * @return
 */
function searchPolicyNoModal(modalPageNo) {
	new Ajax.Updater('searchResult',
			'GIPIPolbasicController?action=getGipdLineCdLovListing', {
				parameters : {
					keyword : $F("keyword"),
					pageNo : modalPageNo
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}