import { getUsersGeoLocation } from './get-geolocation.js';
import { initialiseMap } from './initialise-map.js';
import {
	identityPoolId,
	placesName,
	region,
} from '../variables/global-variables.js';

const ctaButton = document.getElementById('set-location-button');
const loader = document.getElementById('loader-container');
let marker;

export const updatedGeolocation = {
	latitude: null,
	longitude: null,
};

const searchMap = async (authHelper, map) => {
	// Initialize Amazon Location SDK client
	const client = new amazonLocationClient.LocationClient({
		region,
		...authHelper.getLocationClientConfig(), // Provides configuration required to make requests to Amazon Location
	});

	// On mouse click, display marker and get results:
	map.on('click', async function (e) {
		// Remove any existing marker
		if (marker) {
			marker.remove();
		}

		// Render a marker on clicked point
		marker = new maplibregl.Marker()
			.setLngLat([e.lngLat.lng, e.lngLat.lat])
			.addTo(map);

		// Set up parameters for search call
		let params = {
			IndexName: placesName,
			Position: [e.lngLat.lng, e.lngLat.lat],
			Language: 'en',
			MaxResults: '5',
		};

		// Set up command to search for results around clicked point
		const command = new amazonLocationClient.SearchPlaceIndexForPositionCommand(
			params
		);

		try {
			// Make request to search for results around clicked point
			const data = await client.send(command);
			console.log(JSON.stringify(data));

			// Log location points and save them to local storage
			updatedGeolocation.latitude = data.Results[0].Place.Geometry.Point[1];
			updatedGeolocation.longitude = data.Results[0].Place.Geometry.Point[0];

			console.log('Users new coordinates', updatedGeolocation);

			// localStorage.setItem(
			// 	'userLongitude',
			// 	data.Results[0].Place.Geometry.Point[0]
			// );
			// localStorage.setItem(
			// 	'userLatitude',
			// 	data.Results[0].Place.Geometry.Point[1]
			// );
			// console.log(
			// 	'Users new coordinates',
			// 	data.Results[0].Place.Geometry.Point
			// );
		} catch (error) {
			console.log('There was an error searching.');
		}
	});
};

async function main() {
	// Show loader and disable button
	ctaButton.disabled = true;
	loader.style.display = 'flex';

	//  Authorise with Cognito credentials
	const authHelper =
		await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);

	getUsersGeoLocation()
		.then(async (coordinates) => {
			// Get lat and long in global storage
			const userLatitude = coordinates.latitude;
			const userLongitude = coordinates.longitude;

			// Initialise map with user's location
			return await initialiseMap(authHelper, userLatitude, userLongitude);
		})
		.then((map) => {
			// Hide loader
			loader.style.display = 'none';
			ctaButton.disabled = false;

			// Allow user to search map
			searchMap(authHelper, map);
		})
		.catch((error) => {
			console.error('Error:', error);
		});
}

main();
