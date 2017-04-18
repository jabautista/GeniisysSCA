/**
 * Call modal page for Policy No. in module GIACS026
 * 
 * @author emman 02.08.11
 * @version 1.0
 * @param
 * @return
 */
function openSearchPolicyNo() {
	Modalbox.show(contextPath
			+ "/GIPIPolbasicController?action=openSearchGipdLineCdLovListing",
			{
				title : "Search Policy No.",
				width : 921,
				asynchronous : true
			});
}