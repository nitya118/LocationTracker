import { getUsersGeoLocation } from './geolocation.js';

const identityPoolId = 'IDENTITY_POOL_ID';
const mapName = 'MAP_NAME';
const placesName = 'PLACE_NAME';
const region = 'eu-west-2';

const loader = document.getElementById('loader-container');
export let userLocation;
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

			// Log location points
			console.log('location', data.Results[0].Place.Geometry.Point);

			// Dispaly address in html
			const address = JSON.stringify(data.Results[0].Place.Label);
			document.querySelector('#address').textContent = address.replaceAll(
				'"',
				''
			);
		} catch (error) {
			console.log('There was an error searching.');
		}
	});
};

async function main() {
	// Show loader
	loader.style.display = 'flex';

	//  Authorise with Cognito credentials
	const authHelper =
		await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);

	getUsersGeoLocation()
		.then(async (location) => {
			// Initialise map with user's location
			userLocation = location;
			return await initializeMap(
				authHelper,
				location.latitude,
				location.longitude
			);
		})
		.then((map) => {
			// Hide loader
			loader.style.display = 'none';
			// Allow user to search map
			searchMap(authHelper, map);
		})
		.catch((error) => {
			console.error('Error:', error);
		});
}

main();
