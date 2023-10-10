const setButton = document.getElementById('set-location-button');

setButton.onclick = function () {
	alert(
		' New lon ' +
			localStorage.getItem('userLongitude') +
			' New lat ' +
			localStorage.getItem('userLatitude')
	);
};
