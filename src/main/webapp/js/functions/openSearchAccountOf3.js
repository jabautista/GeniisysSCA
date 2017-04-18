/**
 * Created by Jerome Bautista 08.17.2016 SR 5586
 * For Marketing - to change title of Modal depending on user preference. 
 * 
 */

function openSearchAccountOf3(title) {
	Modalbox.show(contextPath+"/GIISAssuredController?action=openSearchAccountOf&ajaxModal=1",
				  {title: title, 
				  width: 800});
}