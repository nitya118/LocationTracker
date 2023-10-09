import { getUsersGeoLocation } from './geolocation.js';
import {
	identityPoolId,
	mapName,
	placesName,
	region,
} from '../variables/global-variables.js';

const loader = document.getElementById('loader-container');
const shareButton = document.getElementById('share-button');

const initializeMap = async (authHelper, latitude, longitude) => {
	const map = new maplibregl.Map({
		container: 'map',
		center: [longitude, latitude],
		zoom: 16,
		style: `https://maps.geo.${region}.amazonaws.com/maps/v0/maps/${mapName}/style-descriptor`,
		...authHelper.getMapAuthenticationOptions(),
	});

	map.addControl(new maplibregl.NavigationControl(), 'top-left');
	// Set place marker to users current location
	const marker = new maplibregl.Marker()
		.setLngLat([longitude, latitude])
		.addTo(map);
	console.log('longitude', longitude, 'latititude', latitude);

	return map;
};

async function main() {
	// Show loader
	shareButton.disabled = true;
	loader.style.display = 'flex';

	//  Authorise with Cognito credentials
	const authHelper =
		await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);

	getUsersGeoLocation()
		.then(async () => {
			// Get lat and long in global storage
			const userLatitude = localStorage.getItem('userLatitude');
			const userLongitude = localStorage.getItem('userLongitude');

			// Initialise map with user's location
			return await initializeMap(authHelper, userLatitude, userLongitude);
		})
		.then(() => {
			// Hide loader and enable button
			loader.style.display = 'none';
			shareButton.disabled = false;
		})
		.catch((error) => {
			console.error('Error:', error);
		});
}

main();
