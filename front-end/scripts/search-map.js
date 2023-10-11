import { getUsersGeoLocation } from './initialise-geolocation.js';
import {
	identityPoolId,
	mapName,
	placesName,
	region,
} from '../variables/global-variables.js';

const setButton = document.getElementById('set-location-button');
const loader = document.getElementById('loader-container');
let marker;

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
	marker = new maplibregl.Marker().setLngLat([longitude, latitude]).addTo(map);

	return map;
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
			console.log('New location', data.Results[0].Place.Geometry.Point);
			localStorage.setItem(
				'userLongitude',
				data.Results[0].Place.Geometry.Point[0]
			);
			localStorage.setItem(
				'userLatitude',
				data.Results[0].Place.Geometry.Point[1]
			);
		} catch (error) {
			console.log('There was an error searching.');
		}
	});
};

async function main() {
	// Show loader and disable button
	setButton.disabled = true;
	loader.style.display = 'flex';

	//  Authorise with Cognito credentials
	const authHelper =
		await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);

	initialiseUsersGeoLocation()
		.then(async (location) => {
			// Get lat and long in global storage
			const userLatitude = localStorage.getItem('userLatitude');
			const userLongitude = localStorage.getItem('userLongitude');

			// Initialise map with user's location
			return await initializeMap(authHelper, userLatitude, userLongitude);
		})
		.then((map) => {
			// Hide loader
			loader.style.display = 'none';
			setButton.disabled = false;

			// Allow user to search map
			searchMap(authHelper, map);
		})
		.catch((error) => {
			console.error('Error:', error);
		});
}

main();
