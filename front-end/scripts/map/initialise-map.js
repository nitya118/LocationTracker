import { getCallersGeoLocation } from '../geolocation/get-geolocation.js';
import {
	identityPoolId,
	mapName,
	region,
} from '../../variables/global-variables.js';

let marker;
const loader = document.getElementById('loader-container');
// const ctaButton = document.getElementById('show-modal-button');

export const initialiseMap = async (authHelper, latitude, longitude) => {
	const map = new maplibregl.Map({
		container: 'map',
		center: [longitude, latitude],
		zoom: 16,
		style: `https://maps.geo.${region}.amazonaws.com/maps/v0/maps/${mapName}/style-descriptor`,
		...authHelper.getMapAuthenticationOptions(),
	});

	map.addControl(new maplibregl.NavigationControl(), 'top-left');
	// Set place marker to users current location
	marker = new maplibregl.Marker().setLngLat([longitude, latitude]).addTo(map);

	return map;
};

async function main() {
	// Show loader and disable submit button
	ctaButton.disabled = true;
	loader.style.display = 'flex';

	//  Authorise with Cognito credentials
	const authHelper =
		await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);

	getCallersGeoLocation()
		.then(async (coordinates) => {
			const userLatitude = coordinates.latitude;
			const userLongitude = coordinates.longitude;

			// Initialise map with user's location
			return await initialiseMap(authHelper, userLatitude, userLongitude);
		})
		.then(() => {
			// Hide loader and enable submit button
			loader.style.display = 'none';
			ctaButton.disabled = false;
		})
		.catch((error) => {
			console.error('Error:', error);
		});
}

main();
