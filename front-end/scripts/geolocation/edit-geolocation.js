import { updatedGeolocation } from '../map/search-map.js';

const setLocationButton = document.getElementById('set-location-button');

export function updateLocation() {
	localStorage.setItem(
		'callersGeolocation',
		JSON.stringify(updatedGeolocation)
	);
	window.location.href = './share-location.html';
}

if (setLocationButton) {
	setLocationButton.addEventListener('click', () => updateLocation());
}
