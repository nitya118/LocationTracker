import { updatedGeolocation } from '../map/search-map.js';

const setLocationButton = document.getElementById('set-location-button');

setLocationButton.onclick = function handleClick() {
	localStorage.setItem(
		'callersGeolocation',
		JSON.stringify(updatedGeolocation)
	);
	window.location.href = './share-location.html';
};
